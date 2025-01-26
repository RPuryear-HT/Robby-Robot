<# Deletes multiple AD accounts. Must have a user list located at C:\scripts\deletes.txt. No spaces allowed in user list.
Will prompt to confirm before performing delete. #>
$usernames = Get-Content C:\scripts\deletes.txt
$usernames = $usernames.ToUpper()
$ErrorActionPreference = "continue"
foreach ($username in $usernames){
    $username = $username.Trim()
    Remove-ADUser -Identity $username
}
$total = $usernames.count
Write-Host "Deleted $total users ($usernames) successfully" -ForegroundColor DarkRed
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
Clear-Content C:\scripts\deletes.txt
# Created by Robert Puryear # Updated 2/8/2024