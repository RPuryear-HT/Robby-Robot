#Get a clean list of AD group members
$group = Read-Host "Enter the group name (pre-Windows 2000)"
Get-ADGroupMember -identity $group -Recursive | Select-Object -ExpandProperty Name | Sort-Object
# Created by Robert Puryear # Updated 2/24/2023
