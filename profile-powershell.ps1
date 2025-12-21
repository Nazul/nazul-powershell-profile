# PowerShell (5.1 or earlier) personal profile of Mario Contreras

#region Encoding Settings
$OutputEncoding = [Console]::OutputEncoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#endregion

#region Call common profile
. (Join-Path $env:OneDriveConsumer 'Dev\src\nazul-powershell-profile\profile-common.ps1')
#endregion

# EOF
