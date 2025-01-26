# Get a clean list of AD group members along with nested groups and their members
$group = Read-Host "Enter the group name"
$groupmembers = Get-ADGroupMember $group
foreach ($member in $groupmembers) {
    if ($member.objectClass -eq "group") {
        $nestedgroup = Get-ADGroup $member.Name
        Write-Host "Nested group: $($nestedgroup.Name)" -ForegroundColor Magenta
        $nestedgroupmembers = Get-ADGroupMember $nestedgroup.Name
        foreach ($nestedgroupmember in $nestedgroupmembers) {
            $user = Get-ADUser $nestedgroupmember.Name
            Write-Host "  User: $($user.Name)" -ForegroundColor Cyan
        }
    } else {
        $user = Get-ADUser $member.Name
        Write-Host "User: $($user.Name)" -ForegroundColor Cyan
    }
}
# Created by Robert Puryear # Updated 2/24/2023