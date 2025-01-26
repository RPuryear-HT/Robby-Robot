# Unlock multiple AD accounts and check lockout status. Must have a list located in "C:\scripts\unlock.txt".
Import-Module ActiveDirectory
$users = Get-Content C:\scripts\unlock.txt
$ErrorActionPreference = 'Stop'
foreach($user in $users)
    {
if((Get-ADUser $user -Properties * | Select-Object -ExpandProperty LockedOut) -eq $true)
        {
            Unlock-ADAccount $user
            Write-Host "$user UNLOCKED" -ForegroundColor Green
        }
        else
        {
            Write-Host "$user NOT LOCKED" -ForegroundColor Magenta
        }}
# Created by Robert Puryear # Updated 2/24/23