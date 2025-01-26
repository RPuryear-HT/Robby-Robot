# Show multi users groups. Must have a list located in "C:\scripts\showgroups.txt". 
$userlist = Get-Content C:\scripts\showgroups.txt | Sort-Object
foreach ($user in $userlist) {
    Write-Host "Groups for "$user":" -ForegroundColor Green
    $usergroups = Get-ADUser $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {($_ -split ",")[0] -replace "CN="} | Sort-Object
    foreach ($group in $usergroups) {
        Write-Host " $group" -ForegroundColor Magenta
    }
}
# Created by Robert Puryear # Updated 2/24/2023