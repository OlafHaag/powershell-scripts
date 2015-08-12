This script creates start menu tiles for shutdown, restart, logoff, and suspend/hibernate.
Download the file to your DESKTOP and paste following command into the search bar/run:

`powershell start-process powershell -verb runas -argument '-command Set-ExecutionPolicy RemoteSigned -scope currentuser;sl $Env:userprofile\desktop;.\CreateWindowsShutdownTiles.ps1'`

To create the tiles it needs administrative rights, so choose yes if you're asked. That's it.

Should work in Windows8 & Windows10

Note, that suspend only induces energy saving mode, if hibernation is turned off, else it will send the pc to hibernation.
