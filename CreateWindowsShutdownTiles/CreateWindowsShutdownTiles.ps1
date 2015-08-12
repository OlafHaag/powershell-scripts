#requires -Version 3.0

<#
 	.SYNOPSIS
        This script can be used to create a Windows 8 tile to the Start menu.
    .DESCRIPTION
        This script can be used to create a Windows 8 tile to the Start menu.
    .PARAMETER  ShutdownTile
		create a shutdown Windows 8 tile to the Start menu.
	.PARAMETER  RestartTile
		create a restart Windows 8 tile to the Start menu.
	.PARAMETER  LogoffTile
		create a logoff Windows 8 tile to the Start menu.
    .PARAMETER  SuspendTile
        create a suspend Windows 8 tile to the Start menu.
    .EXAMPLE
        C:\PS> C:\Script\CreateWindowsTile.ps1
		This example shows how to create a shutdown, restart and logoff Windows 8 tile to the Start menu.
    .EXAMPLE
        C:\PS> C:\Script\CreateWindowsTile.ps1 -ShutdownTile
		This example shows how to create a shutdown Windows 8 tile to the Start menu.
#>

Param
(
    [Parameter(Position=0,Mandatory=$false)]
    [Alias('st','shutdown')][Switch]$ShutdownTile,
    [Parameter(Position=1,Mandatory=$false)]
    [Alias('rt','restart')][Switch]$RestartTile,
    [Parameter(Position=2,Mandatory=$false)]
    [Alias('lt','logoff')][Switch]$LogoffTile,
    [Parameter(Position=3,Mandatory=$false)]
    [Alias('sp','suspend')][Switch]$SuspendTile
)

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator

   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;

   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";

   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);

   # Exit from the current, unelevated, process
   exit
   }

# code that needs to be elevated

$Shell = New-Object -ComObject Shell.Application
$Desktop = $Shell.NameSpace(0X0)
$WshShell = New-Object -comObject WScript.Shell

Function CreateShutdownTile
{
    Write-Verbose "Creating Windows shutdown tile to Start menu."
    #create a new shortcut of shutdown
    $ShutdownShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Shutdown.lnk"
    $ShutdownShortcut = $WshShell.CreateShortcut($ShutdownShortcutPath)
    $ShutdownShortcut.TargetPath = "$env:SystemRoot\System32\shutdown.exe"
    $ShutdownShortcut.Arguments = "-s -t 0"
    $ShutdownShortcut.Save()

    #change the default icon of shutdown shortcut
    $ShutdownLnk = $Desktop.ParseName($ShutdownShortcutPath)
    $ShutdownLnkPath = $ShutdownLnk.GetLink
    $ShutdownLnkPath.SetIconLocation("$env:SystemRoot\System32\SHELL32.dll",27)
    $ShutdownLnkPath.Save()

    #pin application to windows Start menu
    $ShutdownVerbs = $ShutdownLnk.Verbs()
    Foreach($ShutdownVerb in $ShutdownVerbs)
    {
        If($ShutdownVerb.Name.Replace("&","") -match "Pin to Start")
        {
            $ShutdownVerb.DoIt()
        }
    }

    If(Test-Path -Path $ShutdownShortcutPath)
    {
	    Write-Host "Create Windows shutdown tile successfully." -ForegroundColor Green
    }
    Else
    {
        Write-Host "Failed to create Windows shutdown tile." -ForegroundColor Red
    }
}

Function CreateRestartTile
{
    Write-Verbose "Creating Windows restart tile to Start menu."
    #create a new shortcut of restart
    $RestartShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Restart.lnk"
    $RestartShortcut = $WshShell.CreateShortcut($RestartShortcutPath)
    $RestartShortcut.TargetPath = "$env:SystemRoot\System32\shutdown.exe"
    #to avoid double quote in target path, we need to use Arguments property.
    $RestartShortcut.Arguments  = "-r -t 0"
    $RestartShortcut.Save()

    #change the default icon of restart shortcut
    $RestartLnk = $Desktop.ParseName($RestartShortcutPath)
    $RestartLnkPath = $RestartLnk.GetLink
    $RestartLnkPath.SetIconLocation("$env:SystemRoot\System32\SHELL32.dll",238)
    $RestartLnkPath.Save()

    #pin application to windows Start menu
    $RestartVerbs = $RestartLnk.Verbs()
    Foreach($RestartVerb in $RestartVerbs)
    {
        If($RestartVerb.Name.Replace("&","") -match "Pin to Start")
        {
            $RestartVerb.DoIt()
        }
    }

    If(Test-Path -Path $RestartShortcutPath)
    {
	    Write-Host "Create Windows restart tile successfully." -ForegroundColor Green
    }
    Else
    {
        Write-Host "Failed to create Windows restart tile." -ForegroundColor Red
    }
}

Function CreateLogoffTile
{
    Write-Verbose "Creating Windows log off tile to Start menu."
    #create a new shortcut of logoff
    $LogoffShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Logoff.lnk"
    $LogoffShortcut = $WshShell.CreateShortcut($LogoffShortcutPath)
    $LogoffShortcut.TargetPath = "$env:SystemRoot\System32\logoff.exe"
    $LogoffShortcut.Save()

    #change the default icon of logoff shortcut
    $LogoffLnk = $Desktop.ParseName($LogoffShortcutPath)
    $LogoffLnkPath = $LogoffLnk.GetLink
    $LogoffLnkPath.SetIconLocation("$env:SystemRoot\System32\SHELL32.dll",44)
    $LogoffLnkPath.Save()

    #pin application to windows Start menu
    $LogoffVerbs = $LogoffLnk.Verbs()
    Foreach($LogoffVerb in $LogoffVerbs)
    {
        If($LogoffVerb.Name.Replace("&","") -match "Pin to Start")
        {
            $LogoffVerb.DoIt()
        }
    }

    If(Test-Path -Path $LogoffShortcutPath)
    {
	    Write-Host "Create Windows log off tile successfully." -ForegroundColor Green
    }
    Else
    {
        Write-Host "Failed to create Windows log off tile." -ForegroundColor Red
    }
}

Function CreateSuspendTile
{
    Write-Verbose "Creating Windows suspend tile to Start menu."
    #create a new shortcut of suspend
    $SuspendShortcutPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Suspend.lnk"
    $SuspendShortcut = $WshShell.CreateShortcut($SuspendShortcutPath)
    $SuspendShortcut.TargetPath = "$env:SystemRoot\System32\rundll32.exe "
    $SuspendShortcut.Arguments = "powrprof.dll,SetSuspendState 0,1,0"
    $SuspendShortcut.Save()

    #change the default icon of suspend shortcut
    $SuspendLnk = $Desktop.ParseName($SuspendShortcutPath)
    $SuspendLnkPath = $SuspendLnk.GetLink
    $SuspendLnkPath.SetIconLocation("$env:SystemRoot\System32\SHELL32.dll",112)
    $SuspendLnkPath.Save()

    #pin application to windows Start menu
    $SuspendVerbs = $SuspendLnk.Verbs()
    Foreach($SuspendVerb in $SuspendVerbs)
    {
        If($SuspendVerb.Name.Replace("&","") -match "Pin to Start")
        {
            $SuspendVerb.DoIt()
        }
    }

    If(Test-Path -Path $SuspendShortcutPath)
    {
	    Write-Host "Create Windows suspend tile successfully." -ForegroundColor Green
    }
    Else
    {
        Write-Host "Failed to create Windows suspend tile." -ForegroundColor Red
    }
}

If($ShutdownTile)
{
    CreateShutdownTile
}
ElseIf($RestartTile)
{
    CreateRestartTile
}
ElseIf($LogoffTile)
{
    CreateLogoffTile
}
ElseIf($SuspendTile)
{
    CreateSuspendTile
}
Else
{
    CreateShutdownTile
    CreateRestartTile
    CreateLogoffTile
    CreateSuspendTile
}

[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Shell) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($WshShell) | Out-Null
Remove-Variable Shell
Remove-Variable WshShell
