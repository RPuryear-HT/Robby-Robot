# Set "change password at next logon" value to false. Requires a list of users in (C:\scripts\dontchangepassword.txt).
$users = Get-Content C:\scripts\dontchangepassword.txt
foreach ($user in $users) {
    Set-ADUser -identity $user -ChangePasswordAtLogon $true
    }
# Created by Robert Puryear # Updated 9/27/2023