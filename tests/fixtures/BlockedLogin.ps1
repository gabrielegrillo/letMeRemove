# Models a native authentication call that does not cooperate with PowerShell.Stop.
[IO.File]::WriteAllText($env:LMR_LOGIN_STAGE_FILE, 'login')
[Console]::WriteLine("BLOCKED_LOGIN_READY PID=$PID")
[Threading.Thread]::Sleep(30000)
throw 'A blocked login should have been terminated by its supervisor.'
