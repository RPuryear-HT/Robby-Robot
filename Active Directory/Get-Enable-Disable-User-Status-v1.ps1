# Check if multiple accounts are enabled/disabled. Requires a list of users in (C:\scripts\userstatus.txt).
$users = Get-Content C:\scripts\userstatus.txt
foreach ($user in $users) {
    Get-ADUser -identity $user -properties * | Select-Object Enabled, SamAccountName, DisplayName
    }
# Created by Robert Puryear # Updated 9/21/2023