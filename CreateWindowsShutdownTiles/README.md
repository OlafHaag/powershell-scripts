This script creates start menu tiles for shutdown, restart, logoff, and suspend/hibernate.
Browse to the folder to where you downloaded the CreateWindowsShutdownTiles.ps1 file and paste following command into the adress bar of the windows explorer:

`cmd /C powershell "".\CreateWindowsTile.ps1""`

To create the tiles it needs administrative rights, so choose yes if you're asked. That's it.

Should work in Windows8 & Windows10

Note, that suspend only induces energy saving mode, if hibernation is turned off, else it will send the pc to hibernation.
