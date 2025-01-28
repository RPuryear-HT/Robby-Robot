# Show multi users groups. Must have a list located at C:\scripts\showgroups.txt.

# Read the list of users from the specified text file and sort them
$userlist = Get-Content C:\scripts\showgroups.txt | Sort-Object

# Loop through each user in the list
foreach ($user in $userlist) {

    # Display the user's name with a green foreground color
    Write-Host "Groups for "$user":" -ForegroundColor Green

    # Retrieve the groups the user is a member of, extract and sort the group names
    $usergroups = Get-ADUser $user -Properties MemberOf | Select-Object -ExpandProperty MemberOf | ForEach-Object {($_ -split ",")[0] -replace "CN="} | Sort-Object
    
    # Loop through each group
    foreach ($group in $usergroups) {
        # Display the group name with a magenta foreground color
        Write-Host " $group" -ForegroundColor Magenta
    }
}

# Created by Robert Puryear 2/24/2023 # Updated 1/28/2025
