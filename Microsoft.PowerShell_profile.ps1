# Host name autocompletion
using namespace System.Management.Automation
Register-ArgumentCompleter -CommandName ssh,scp,sftp -Native -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    $knownHosts = Get-Content ${Env:HOMEPATH}\.ssh\known_hosts `
    | ForEach-Object { ([string]$_).Split(' ')[0] } `
    | ForEach-Object { $_.Split(',') } `
    | Sort-Object -Unique
    # For now just assume it's a hostname.
    $textToComplete = $wordToComplete
    $generateCompletionText = {
        param($x)
        $x
    }
    if ($wordToComplete -match "^(?<user>[-\w/\\]+)@(?<host>[-.\w]+)$") {
        $textToComplete = $Matches["host"]
        $generateCompletionText = {
            param($hostname)
            $Matches["user"] + "@" + $hostname
        }
    }
    $knownHosts `
    | Where-Object { $_ -like "${textToComplete}*" } `
    | ForEach-Object { [CompletionResult]::new((&$generateCompletionText($_)), $_, [CompletionResultType]::ParameterValue, $_) }
}

# Extension modules
Import-Module posh-git

# History searching using arrow keys
Set-PSReadlineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadlineKeyHandler -Key "UpArrow" -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key "DownArrow" -Function HistorySearchForward

# Prompt configuration
function Prompt{
    $user = $env:USERNAME
    $hostname = hostname
    $directory = Get-Location
    Write-Host("$user@$hostname ") -NoNewline -ForegroundColor "Green" 
    Write-Host("$directory") -ForegroundColor "Blue" 
    ">: "
}

# Clear shell
cls
