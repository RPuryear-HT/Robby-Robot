# Unlock AD account and check lockout status
Import-Module ActiveDirectory
$user = Read-Host "Enter Username to unlock"
$ErrorActionPreference = 'Stop'
if((Get-ADUser $user -Properties * | Select-Object -ExpandProperty LockedOut) -eq $true)
        {
            Unlock-ADAccount $user
            Write-Host "$user UNLOCKED" -ForegroundColor Green
        }
        elseif ((Get-ADUser $user -Properties * | Select-Object -ExpandProperty LockedOut) -eq $false)
        {
            Write-Host "$user NOT LOCKED" -ForegroundColor Magenta
        }
# Created by Robert Puryear # Updated 2/24/23
