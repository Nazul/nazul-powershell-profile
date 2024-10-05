# Common PowerShell (5.1 or later) personal profile of Mario Contreras

#region Aliases
Set-Alias ll ls
Set-Alias clip Set-Clipboard
#endregion

#region Functions
function Get-UpgradableModule {
    $modules = Get-InstalledModule | ForEach-Object {
        New-Object -TypeName PSCustomObject -Property @{
            Name      = $_.Name
            Installed = $_.Version
            Available = (Find-Module -Name $_.Name).Version
        }
    }
    $modules | Where-Object { $_.Installed -ne $_.Available } | Select-Object Name, Installed, Available
} # Get-UpgradableModule

# Get latest release version from a GitHub repo
function Get-GitHubRepoLatestRelease {
    param (
        [String]$RepoName
    )
    $url = "https://api.github.com/repos/$RepoName/releases/latest"
    $latest = $null
    try {
        $latest = curl -s $url | ConvertFrom-Json
    }
    catch {
        throw 'An error occured while getting the latest version or the repo name is invalid'
    }
    if ($latest) {
        $latest | Select-Object name, tag_name, draft, prerelease, created_at, published_at
    }
} # Get-GitHubRepoLatestRelease

function Get-ScheduledTaskDetail {
    param(
        [String[]]$Server
    )
    Get-ScheduledTask -CimSession $Server | 
    Where-Object TaskName -NotMatch 'shadowcopy|user_feed_sync|Google|optimize' | 
    Select-Object @{Name = "Server"; Expression = { $_.PSComputerName } },
    TaskPath, TaskName, State, @{Name = "Run As"; Expression = { $_.Principal.UserID } }
}
#endregion Functions

#region 1Password CLI
$env:OP_BIOMETRIC_UNLOCK_ENABLED = "false"
Invoke-Expression $(op signin)
#region 1Password CLI

#region Variables for Working with Flex Environments
try {
    $tenantId = (op read "op://6vui2id7esaeer32cfd65lftf4/Flex Prod M365 Tenant/TenantID")
    $defEnv = (op read "op://6vui2id7esaeer32cfd65lftf4/Flex Prod M365 Tenant/PowerPlatform-DefEnv")
    $devEnv = (op read "op://6vui2id7esaeer32cfd65lftf4/Flex Prod M365 Tenant/PowerPlatform-O365GovDevEnv")
    $prodEnv = (op read "op://6vui2id7esaeer32cfd65lftf4/Flex Prod M365 Tenant/PowerPlatform-O365GovProdEnv")
    # Removing warnings
    $tenantId | Out-Null
    $defEnv | Out-Null
    $devEnv | Out-Null
    $prodEnv | Out-Null
}
catch {
    Write-Host "An error ocurred while trying to read the Flex environment variables" -ForegroundColor Red
}
#endregion Variables for Working with Flex Environments

#region Chocolatey Profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
#endregion Chocolatey Profile

#region Azure CLI Tab Completition
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  $completion_file = New-TemporaryFile
  $env:ARGCOMPLETE_USE_TEMPFILES = 1
  $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
  $env:COMP_LINE = $wordToComplete
  $env:COMP_POINT = $cursorPosition
  $env:_ARGCOMPLETE = 1
  $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
  $env:_ARGCOMPLETE_IFS = "`n"
  $env:_ARGCOMPLETE_SHELL = 'powershell'
  az 2>&1 | Out-Null
  Get-Content $completion_file | Sort-Object | ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
  }
  Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}
#endregion Azure CLI Tab Completition

#region 1Password CLI Tab Completition
op completion powershell | Out-String | Invoke-Expression
#endregion 1Password CLI Tab Completition

#region For Windows Terminal
Import-Module Terminal-Icons
Import-Module posh-git
$env:POSH_POWERSHELL_TYPE = if ($PSVersionTable.PSEdition -eq 'Desktop') {'Windows PowerShell'} else {'PowerShell'}
oh-my-posh init pwsh --config (Join-Path $env:OneDriveConsumer '\Dev\src\oh-my-posh-nazul-themes\Nazul-Theme-1-Windows.json') | Invoke-Expression
#endregion For Windows Terminal

#region Scoop
Invoke-Expression (&scoop-search --hook)
#endregion Scoop

# EOF
