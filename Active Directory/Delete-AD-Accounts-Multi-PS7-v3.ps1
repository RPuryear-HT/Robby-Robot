<# Deletes multiple AD accounts. Must have a user list located at C:\scripts\deletes.txt. No spaces allowed in user list.
Will NOT prompt to confirm before performing delete. #>
$usernames = Get-Content C:\scripts\deletes.txt
$usernames = $usernames.ToUpper()
$ErrorActionPreference = "continue"

$usernames | ForEach-Object -Parallel {
    $username | Remove-ADUser -Identity $username -Confirm:$False
}

$total = $usernames.count
Write-Host "Deleted $total users ($usernames) successfully" -ForegroundColor DarkRed
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
Clear-Content C:\scripts\deletes.txt
# Created by Robert Puryear # Updated 1/20/2025