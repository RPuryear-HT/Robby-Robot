# Check display names of multiple accounts. Requires a list of users in (C:\scripts\names.txt).
$users = Get-Content C:\scripts\names.txt
foreach ($user in $users) {
    Get-ADUser -identity $user -properties * | Select-Object SamAccountName, DisplayName
    }
# Created by Robert Puryear # Updated 9/27/2023