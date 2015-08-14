This script creates start menu tiles for shutdown, restart, logoff, and suspend/hibernate.
Open up the command prompt by typing "cmd" into the start menu searchfield, hit enter and paste the following code into the console that just opened:

`powershell start-process powershell -verb runas -argumentlist '–NoProfile', '–ExecutionPolicy Bypass', '-command Invoke-WebRequest https://raw.githubusercontent.com/Vaquero84/powershell-scripts/master/CreateWindowsShutdownTiles/CreateWindowsShutdownTiles.ps1 -OutFile $Env:userprofile\desktop\ShutdownTile.ps1;sl $Env:userprofile\desktop;.\ShutdownTile.ps1;Remove-Item .\ShutdownTile.ps1'`

To create the tiles it needs administrative rights, so choose yes if you're asked. That's it.

Should work in Windows8 & Windows10

Note, that suspend only induces energy saving mode, if hibernation is turned off, else it will send the pc to hibernation.
