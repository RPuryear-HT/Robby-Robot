# Show group memberships for a user
$username = Read-Host "Enter the Username"
$user = Get-ADUser -Identity $username -Properties memberof
$groups = $user.memberof
foreach ($group in $groups) {
    (Get-ADGroup -Identity $group).name | Sort-Object Name
}
# Created by Robert Puryear 1/26/2023
