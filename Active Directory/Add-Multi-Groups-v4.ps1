<#

  ______         __        __        __       __            __    __      __ 
 /      \       |  \      |  \      |  \     /  \          |  \  |  \    |  \
|  $$$$$$\  ____| $$  ____| $$      | $$\   /  $$ __    __ | $$ _| $$_    \$$
| $$__| $$ /      $$ /      $$      | $$$\ /  $$$|  \  |  \| $$|   $$ \  |  \
| $$    $$|  $$$$$$$|  $$$$$$$      | $$$$\  $$$$| $$  | $$| $$ \$$$$$$  | $$
| $$$$$$$$| $$  | $$| $$  | $$      | $$\$$ $$ $$| $$  | $$| $$  | $$ __ | $$
| $$  | $$| $$__| $$| $$__| $$      | $$ \$$$| $$| $$__/ $$| $$  | $$|  \| $$
| $$  | $$ \$$    $$ \$$    $$      | $$  \$ | $$ \$$    $$| $$   \$$  $$| $$
 \$$   \$$  \$$$$$$$  \$$$$$$$       \$$      \$$  \$$$$$$  \$$    \$$$$  \$$
              ______                                                         
             /      \                                                        
            |  $$$$$$\  ______    ______   __    __   ______    _______      
            | $$ __\$$ /      \  /      \ |  \  |  \ /      \  /       \     
            | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\|  $$$$$$$     
            | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$ \$$    \      
            | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$ _\$$$$$$\     
             \$$    $$| $$       \$$    $$ \$$    $$| $$    $$|       $$     
              \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$  \$$$$$$$      
                                                    | $$                     
                                                    | $$                     
                                                     \$$                     

                                                     
Description: Add a list of groups to any user.
==============================================================================================================================
Note: Account credentials must have Active Directory Object permissions. Must have a list of groups located in "C:\scripts\groups.txt".
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/25/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
12/1/2023
Created original script.
12/27/2024
Added changelog.
Added ASCII art.
Added notes to the code.
Added special characters and edited completion message.
1/6/2025
Added execution timer. Formatted output message.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Measure the time taken to run the script
$runtime = Measure-Command {

# Set the error action preference to stop on errors
$ErrorActionPreference = "stop"

# Read the list of groups from a file
$grouplist = Get-Content C:\scripts\groups.txt

# Prompt the user to enter the username
$user = Read-Host "Enter the username"

# Loop through each group in the list and add the user to the specified group
foreach ($group in $grouplist) {
    Add-ADGroupMember $group -Members $user -ErrorAction SilentlyContinue
}

# Count the total number of groups the user was added to
$total = $grouplist.count

#Display the group list to the terminal
$grouplist | Format-Table

# Display a message indicating the number of groups the user was added to
Write-Output "Added $total groups to $user successfully" | Out-Host

# Display a message to allow time for synchronization
Write-Output "Please allow up to a few minutes to replicate" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the groups.txt file
Clear-Content C:\scripts\groups.txt