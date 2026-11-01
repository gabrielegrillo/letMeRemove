import os,sys
if os.name != 'posix':
 print('SKIP: existing-shell PTY check requires POSIX')
 sys.exit(0)
import pty,subprocess,select,time,termios,fcntl,struct
from pathlib import Path
root=str(Path(__file__).resolve().parent.parent);m,s=pty.openpty();fcntl.ioctl(s,termios.TIOCSWINSZ,struct.pack('HHHH',30,90,0,0))
env=os.environ.copy();env['TERM']='xterm-256color';env.pop('NO_COLOR',None)
def setup():
 os.setsid();fcntl.ioctl(s,termios.TIOCSCTTY,0)
p=subprocess.Popen(['pwsh','-NoProfile','-NoExit','-Command',f"& '{root}/tests/Invoke-Supervisor.ps1'"],stdin=s,stdout=s,stderr=s,env=env,preexec_fn=setup)
buf=b''
def read_until(token,seconds=8):
 global buf
 limit=time.monotonic()+seconds
 while token not in buf and time.monotonic()<limit:
  if select.select([m],[],[],.05)[0]:
   try:d=os.read(m,65536)
   except OSError:break
   buf+=d
   if b'\x1b[6n' in d:os.write(m,b'\x1b[1;1R')
 assert token in buf,(token,buf[-500:])
try:
 read_until(b'BLOCKED_LOGIN_READY')
 time.sleep(.2);os.write(m,b'\x03')
 read_until(b'PS ',4)
 assert p.poll() is None,'The existing shell was terminated'
 # Disable line editing to test command execution without a graphical terminal emulator.
 os.write(m,b"Remove-Module PSReadLine; [Console]::WriteLine('SHELL_' + 'STILL_ALIVE')\r")
 read_until(b'SHELL_STILL_ALIVE',5)
 print('PASS: Ctrl+C ends blocked authentication and leaves the existing PowerShell session usable.')
finally:
 p.kill();p.wait();os.close(m);os.close(s)
