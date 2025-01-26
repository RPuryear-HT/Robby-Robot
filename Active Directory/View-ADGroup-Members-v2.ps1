#Get a clean list of AD group members outputted to a grid view.
$group = Read-Host "Enter the group name (pre-Windows 2000)"
Get-ADGroupMember -identity $group -Recursive | Select-Object -ExpandProperty Name | Sort-Object | Out-GridView
# Created by Robert Puryear # Updated 2/26/2023
