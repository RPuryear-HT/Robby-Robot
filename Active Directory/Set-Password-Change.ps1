# Set "change password at next logon" value to true. Requires a list of users in (C:\scripts\changepassword.txt).
$users = Get-Content C:\scripts\changepassword.txt
foreach ($user in $users) {
    Set-ADUser -identity $user -ChangePasswordAtLogon $true
    }
# Created by Robert Puryear # Updated 10/19/2023