# Set "change password at next logon" value to false. Requires a list of users at C:\scripts\dontchangepassword.txt.

# Read the list of users from the specified text file
$users = Get-Content C:\scripts\dontchangepassword.txt

# Loop through each user in the list
foreach ($user in $users) {
    # Bypass password change at logon
    Set-ADUser -identity $user -ChangePasswordAtLogon $false
    }

# Created by Robert Puryear 9/27/2023 # Updated 1/28/2025
