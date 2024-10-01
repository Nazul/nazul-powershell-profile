# PowerShell (5.1 or earlier) personal profile of Mario Contreras

#region Encoding Settings
$OutputEncoding = [Console]::OutputEncoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#endregion

#region Call common profile
(New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Nazul/nazul-powershell-profile/refs/heads/main/profile-common.ps1') | Invoke-Expression
#endregion

# EOF
