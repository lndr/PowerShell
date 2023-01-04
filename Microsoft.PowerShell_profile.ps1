Import-Module posh-git

Set-PSReadlineKeyHandler -Key "Tab" -Function MenuComplete
Set-PSReadlineKeyHandler -Key "UpArrow" -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key "DownArrow" -Function HistorySearchForward

function Prompt{
    $user = $env:USERNAME
    $hostname = $env:COMPUTERNAME.ToLower()
    $directory = Get-Location
    Write-Host("$user@$hostname ") -NoNewline -ForegroundColor "Green" 
    Write-Host("$directory") -ForegroundColor "Blue" 
    ">: "
}

cls
