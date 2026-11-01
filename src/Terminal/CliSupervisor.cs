using System;
using System.Diagnostics;
using System.IO;
using System.Threading;

namespace LetMeRemove.Terminal
{
    // Owns exactly one child process. It never terminates the user's PowerShell host.
    public static class CliSupervisor
    {
        public static int Run(string executable, string[] arguments, string stageFile, int loginSeconds)
        {
            var start = new ProcessStartInfo(executable) { UseShellExecute = false };
            foreach (string argument in arguments) start.ArgumentList.Add(argument);
            start.Environment["LMR_LOGIN_STAGE_FILE"] = stageFile;
            using var child = new Process { StartInfo = start };
            bool interactive = !Console.IsInputRedirected;
            bool? oldMode = null;
            int cancelled = 0;
            bool timeout = false;
            long loginStarted = 0;
            bool completed = false;
            ConsoleCancelEventHandler interrupt = (_, e) => {
                if (e.SpecialKey != ConsoleSpecialKey.ControlC) return;
                e.Cancel = true;
                Interlocked.Exchange(ref cancelled, 1);
                Kill(child);
            };
            try
            {
                Console.CancelKeyPress += interrupt;
                if (interactive) { try { oldMode = Console.TreatControlCAsInput; } catch { } }
                child.Start();
                while (!child.WaitForExit(20))
                {
                    string phase = "";
                    try { if (File.Exists(stageFile)) phase = File.ReadAllText(stageFile).Trim(); } catch (IOException) { }
                    if (phase == "login" && !completed)
                    {
                        if (loginStarted == 0) loginStarted = Environment.TickCount64;
                        // During device sign-in the worker needs no keyboard input.
                        // Handle both a literal ETX and a normal console interrupt.
                        if (interactive)
                        {
                            try {
                                Console.TreatControlCAsInput = true;
                                while (Console.KeyAvailable) {
                                    var key = Console.ReadKey(true);
                                    if (key.KeyChar == '\x03' || (key.Key == ConsoleKey.C && (key.Modifiers & ConsoleModifiers.Control) != 0)) {
                                        Interlocked.Exchange(ref cancelled, 1);
                                        Kill(child);
                                        break;
                                    }
                                }
                            } catch (InvalidOperationException) { }
                        }
                        if (Environment.TickCount64 - loginStarted >= loginSeconds * 1000L) {
                            timeout = true;
                            Kill(child);
                        }
                    }
                    else if (phase == "ready" && !completed)
                    {
                        completed = true;
                        if (oldMode.HasValue) { try { Console.TreatControlCAsInput = oldMode.Value; } catch { } }
                    }
                    if (Volatile.Read(ref cancelled) != 0) Kill(child);
                }
                if (Volatile.Read(ref cancelled) != 0) return 130;
                if (timeout) { Console.WriteLine("\nLogin timed out after " + loginSeconds + " seconds. Run the tool again to request a new code."); return 1; }
                return child.ExitCode;
            }
            finally
            {
                Console.CancelKeyPress -= interrupt;
                Kill(child);
                if (oldMode.HasValue) { try { Console.TreatControlCAsInput = oldMode.Value; } catch { } }
                if (interactive && !Console.IsOutputRedirected) {
                    try { Console.Write("\x1b[0m\x1b[?1000l\x1b[?1006l\x1b[?1049l\x1b[?25h"); } catch { }
                }
            }
        }
        private static void Kill(Process child)
        {
            try { if (!child.HasExited) child.Kill(true); }
            catch (InvalidOperationException) { }
            catch (System.ComponentModel.Win32Exception) { }
        }
    }
}
