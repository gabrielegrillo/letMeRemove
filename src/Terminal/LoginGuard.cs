using System;
using System.Management.Automation;
using System.Text.RegularExpressions;
using System.Threading;

namespace LetMeRemove.Terminal
{
    public sealed class LoginGuard : IDisposable
    {
        private readonly PowerShell pipeline;
        private readonly Timer timer;
        private readonly long deadline;
        private int stopped;
        private bool? previousControlMode;
        public bool Cancelled { get; private set; }
        public bool TimedOut { get; private set; }
        public LoginGuard(PowerShell pipeline, int seconds)
        {
            this.pipeline = pipeline;
            if (!Console.IsInputRedirected) {
                try { previousControlMode = Console.TreatControlCAsInput; Console.TreatControlCAsInput = false; } catch { }
                Console.CancelKeyPress += OnInterrupt;
            }
            deadline = seconds > 0 ? Environment.TickCount64 + seconds * 1000L : long.MaxValue;
            pipeline.Streams.Warning.DataAdded += (_, e) => Show(pipeline.Streams.Warning[e.Index].ToString());
            pipeline.Streams.Information.DataAdded += (_, e) => Show(pipeline.Streams.Information[e.Index].ToString());
            timer = new Timer(Check, null, 50, 50);
        }
        private static void Show(string text)
        {
            var code = Regex.Match(text, @"\bcode\s+([A-Z0-9]{6,16})\b");
            string safe = code.Success ? "Login code: " + code.Groups[1].Value : Regex.Replace(text, @"[\p{Cc}\p{Cf}]", " ");
            Console.WriteLine(safe);
        }
        private void Check(object state)
        {
            if (Environment.TickCount64 < deadline) return;
            if (Interlocked.Exchange(ref stopped, 1) != 0) return;
            TimedOut = true;
            try { pipeline.BeginStop(null, null); } catch { }
        }
        private void OnInterrupt(object sender, ConsoleCancelEventArgs args)
        {
            if (args.SpecialKey != ConsoleSpecialKey.ControlC) return;
            args.Cancel = true;
            if (Interlocked.Exchange(ref stopped, 1) != 0) return;
            Cancelled = true;
            try { pipeline.BeginStop(null, null); } catch { }
        }
        public void Dispose()
        {
            Console.CancelKeyPress -= OnInterrupt;
            timer.Dispose();
            if (previousControlMode.HasValue) { try { Console.TreatControlCAsInput = previousControlMode.Value; } catch { } }
        }
    }
}
