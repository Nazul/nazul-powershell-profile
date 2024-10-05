# PowerShell (7 or later) personal profile of Mario Contreras

#region Call common profile
Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Nazul/nazul-powershell-profile/refs/heads/main/profile-common.ps1').Content
#endregion

#region GitHub Copilot
. (Join-Path $env:OneDriveConsumer '\Documents\PowerShell\gh-copilot.ps1')
#endregion GitHub Copilot

#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# EOF
