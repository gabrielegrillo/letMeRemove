using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Text;
using System.Threading;

namespace LetMeRemove.Terminal
{
    // All console writes are serialized. Timer callbacks never execute PowerShell.
    public static class Output
    {
        internal static readonly object Gate = new object();
        public static void Write(string value) { lock (Gate) Console.Write(value); }
    }

    public static class Cells
    {
        public static int ElementWidth(string element)
        {
            int width = 0;
            foreach (var rune in element.EnumerateRunes())
            {
                var category = Rune.GetUnicodeCategory(rune);
                if (category == UnicodeCategory.NonSpacingMark || category == UnicodeCategory.EnclosingMark ||
                    category == UnicodeCategory.Format || category == UnicodeCategory.Control) continue;
                int c = rune.Value;
                bool wide = c >= 0x1100 && (c <= 0x115f || c == 0x2329 || c == 0x232a ||
                    (c >= 0x2e80 && c <= 0xa4cf && c != 0x303f) || (c >= 0xac00 && c <= 0xd7a3) ||
                    (c >= 0xf900 && c <= 0xfaff) || (c >= 0xfe10 && c <= 0xfe19) ||
                    (c >= 0xfe30 && c <= 0xfe6f) || (c >= 0xff00 && c <= 0xff60) ||
                    (c >= 0xffe0 && c <= 0xffe6) || (c >= 0x1f000 && c <= 0x1faff) ||
                    (c >= 0x20000 && c <= 0x3fffd));
                width = Math.Max(width, wide ? 2 : 1);
            }
            if (element.Contains('\ufe0f') || element.Contains('\u20e3')) width = Math.Max(width, 2);
            return width;
        }

        // Grapheme-aware truncation: never split emoji, combining marks or surrogate pairs.
        public static string Fit(string value, int cells)
        {
            cells = Math.Max(0, cells);
            var parts = new List<string>();
            var sizes = new List<int>();
            int used = 0;
            var iterator = StringInfo.GetTextElementEnumerator(value ?? "");
            bool truncated = false;
            while (iterator.MoveNext())
            {
                string part = iterator.GetTextElement();
                int size = ElementWidth(part);
                if (used + size > cells) { truncated = true; break; }
                parts.Add(part); sizes.Add(size); used += size;
            }
            if (truncated && cells > 0)
            {
                while (used > cells - 1 && parts.Count > 0)
                {
                    used -= sizes[sizes.Count - 1];
                    parts.RemoveAt(parts.Count - 1); sizes.RemoveAt(sizes.Count - 1);
                }
                parts.Add("…"); used++;
            }
            return string.Concat(parts) + new string(' ', Math.Max(0, cells - used));
        }

        public static string[] Wrap(string value, int cells)
        {
            cells = Math.Max(2, cells);
            var lines = new List<string>();
            var line = new StringBuilder();
            int used = 0;
            foreach (string word in (value ?? "").Split(' ', StringSplitOptions.RemoveEmptyEntries))
            {
                int wordWidth = 0;
                var iterator = StringInfo.GetTextElementEnumerator(word);
                while (iterator.MoveNext()) wordWidth += ElementWidth(iterator.GetTextElement());
                if (used > 0 && used + 1 + wordWidth > cells)
                {
                    lines.Add(Fit(line.ToString(), cells)); line.Clear(); used = 0;
                }
                if (used > 0) { line.Append(' '); used++; }
                iterator = StringInfo.GetTextElementEnumerator(word);
                while (iterator.MoveNext())
                {
                    string part = iterator.GetTextElement();
                    int size = ElementWidth(part);
                    if (used + size > cells) { lines.Add(Fit(line.ToString(), cells)); line.Clear(); used = 0; }
                    line.Append(part); used += size;
                }
            }
            if (line.Length > 0 || lines.Count == 0) lines.Add(Fit(line.ToString(), cells));
            return lines.ToArray();
        }
    }

    public sealed class Screen : IDisposable
    {
        private string[] previous = Array.Empty<string>();
        private bool opened;

        public void Open()
        {
            if (opened) return;
            Output.Write("\x1b[?1049h\x1b[?25l");
            opened = true;
        }

        // Pure diff builder, also used by offline tests. No erase-screen per frame.
        public string BuildPatch(string[] lines, bool invalidate)
        {
            var batch = new StringBuilder();
            int count = Math.Max(lines.Length, previous.Length);
            for (int row = 0; row < count; row++)
            {
                string next = row < lines.Length ? lines[row] : "";
                string old = row < previous.Length ? previous[row] : "";
                if (!invalidate && next == old) continue;
                batch.Append("\x1b[").Append(row + 1).Append(";1H");
                batch.Append(next).Append("\x1b[0m\x1b[K");
            }
            previous = (string[])lines.Clone();
            return batch.ToString();
        }

        public void Render(string[] lines, bool invalidate)
        {
            string patch = BuildPatch(lines, invalidate);
            if (patch.Length != 0) Output.Write(patch);
        }

        // Forget obsolete row addresses before repainting a resized viewport.
        public void Reset() { previous = Array.Empty<string>(); }

        public void Dispose()
        {
            if (!opened) return;
            Output.Write("\x1b[0m\x1b[?1049l\x1b[?25h");
            opened = false;
        }
    }

    public sealed class Activity : IDisposable
    {
        private readonly string title;
        private readonly Stopwatch watch = Stopwatch.StartNew();
        private readonly Timer timer;
        private bool closed;
        private int tick;
        private int previousWidth;
        private static readonly char[] Frames = { '|', '/', '-', '\\' };

        public Activity(string title)
        {
            this.title = title;
            Paint(null);
            timer = new Timer(_ => Paint(null), null, 100, 100);
        }

        private void Paint(bool? succeeded)
        {
            lock (Output.Gate)
            {
                if (closed) return;
                try
                {
                    int width = Math.Max(12, Console.WindowWidth - 2);
                    string elapsed = watch.Elapsed.TotalSeconds.ToString("0.0", CultureInfo.InvariantCulture) + "s";
                    string mark = succeeded.HasValue ? (succeeded.Value ? "+" : "!") : Frames[tick % Frames.Length].ToString();
                    string color = succeeded.HasValue ? (succeeded.Value ? "\x1b[92m" : "\x1b[91m") : "\x1b[96m";
                    int phase = tick++ % 16;
                    int position = phase <= 8 ? phase : 16 - phase;
                    string meter = succeeded.HasValue ? (succeeded.Value ? "━━━━━━━━━━" : "──────────") :
                        new string('·', position) + "━━" + new string('·', 8 - position);
                    string text = "[" + mark + "] " + Cells.Fit(title, Math.Max(6, width - 28)).TrimEnd() +
                        "  [" + meter + "] " + elapsed;
                    int target = Math.Min(width, Math.Max(previousWidth, text.Length));
                    Console.Write("\r" + color + Cells.Fit(text, target) + "\x1b[0m");
                    previousWidth = target;
                    if (succeeded.HasValue) Console.WriteLine();
                }
                catch { /* An animation failure must never repeat or cancel a service action. */ }
            }
        }

        public void Finish(bool succeeded)
        {
            lock (Output.Gate)
            {
                if (closed) return;
                Paint(succeeded);
                closed = true;
            }
            timer.Dispose();
        }

        public void Dispose() { Finish(false); }
    }
}
