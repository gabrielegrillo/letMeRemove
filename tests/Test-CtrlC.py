# POSIX terminal integration checks. Uses only the offline MicrosoftTeams fixture.
import os, sys
if os.name != 'posix':
 print('SKIP: POSIX PTY test; verify Ctrl+C manually on Windows Terminal.')
 sys.exit(0)
import pty, subprocess, select, time, termios, fcntl, struct
from pathlib import Path
root=str(Path(__file__).resolve().parent.parent)
for scenario, args, marker in [
 ('blocked-native-login',['-File',root+'/tests/Invoke-Supervisor.ps1'],b'BLOCKED_LOGIN_READY'),
 ('picker',['-File',root+'/letMeRemove.ps1','-Demo'],b'Nothing is sent yet.'),
 ('login',['-File',root+'/tests/Invoke-EntryPoint.ps1','-Repository',root,'-Scenario','List','-LoginDelayMs','10000'],b'Complete sign-in within'),
 ('fetch',['-File',root+'/tests/Invoke-EntryPoint.ps1','-Repository',root,'-Scenario','Remove','-Interface','Rich','-ServiceDelayMs','10000'],b'Finding your teams')]:
 m,s=pty.openpty();fcntl.ioctl(s,termios.TIOCSWINSZ,struct.pack('HHHH',30,90,0,0))
 env=os.environ.copy();env.pop('NO_COLOR',None);env['TERM']='xterm-256color'
 def setup():
  os.setsid();fcntl.ioctl(s,termios.TIOCSCTTY,0)
 p=subprocess.Popen(['pwsh','-NoProfile',*args],stdin=s,stdout=s,stderr=s,env=env,cwd=root,preexec_fn=setup)
 data=b'';deadline=time.monotonic()+8
 try:
  while marker not in data and time.monotonic()<deadline:
   if select.select([m],[],[],.1)[0]:data+=os.read(m,65536)
  assert marker in data,(scenario,data[-300:])
  time.sleep(.3);os.write(m,b'\x03');start=time.monotonic()
  while p.poll() is None and time.monotonic()-start<4:
   if select.select([m],[],[],.1)[0]:
    try:data+=os.read(m,65536)
    except OSError:break
  assert p.poll() is not None,(scenario,'Ctrl+C failed',data[-300:])
  if scenario=='picker':assert b'\x1b[?1049l' in data and b'\x1b[?1000l' in data
  print('PASS:',scenario,'interrupted in',round(time.monotonic()-start,2),'seconds; exit',p.returncode)
 finally:
  if p.poll() is None:p.kill();p.wait()
  os.close(m);os.close(s)
