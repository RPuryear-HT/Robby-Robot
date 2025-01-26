#List AD user's groups
Import-Module ActiveDirectory
$username = Read-Host "Enter the Username"
$user = Get-ADUser -Identity $username -Properties memberof
$groups = $user.memberof
foreach ($group in $groups) {
    (Get-ADGroup -Filter { DistinguishedName -eq $group } -Properties name | Select-Object -ExpandProperty name | Sort-Object)
}
#  Created by Robert Puryear 1/26/2023