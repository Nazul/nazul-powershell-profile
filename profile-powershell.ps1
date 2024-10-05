# PowerShell (5.1 or earlier) personal profile of Mario Contreras

#region Encoding Settings
$OutputEncoding = [Console]::OutputEncoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#endregion

#region Call common profile
Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Nazul/nazul-powershell-profile/refs/heads/main/profile-common.ps1').Content
#endregion

# EOF
