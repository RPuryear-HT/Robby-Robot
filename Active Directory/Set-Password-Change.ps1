# Set "change password at next logon" value to true. Requires a list of users in (C:\scripts\changepassword.txt).

# Read the list of users from the specified text file
$users = Get-Content C:\scripts\changepassword.txt

# Loop through each user in the list
foreach ($user in $users) {
    # Set the user to change their password at next logon
    Set-ADUser -identity $user -ChangePasswordAtLogon $true
    }

# Created by Robert Puryear 10/19/2023 # Updated 1/28/2025
