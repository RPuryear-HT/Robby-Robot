<#

  ______         __        __         ______                                                   
 /      \       |  \      |  \       /      \                                                  
|  $$$$$$\  ____| $$  ____| $$      |  $$$$$$\  ______    ______   __    __   ______           
| $$__| $$ /      $$ /      $$      | $$ __\$$ /      \  /      \ |  \  |  \ /      \          
| $$    $$|  $$$$$$$|  $$$$$$$      | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\         
| $$$$$$$$| $$  | $$| $$  | $$      | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$         
| $$  | $$| $$__| $$| $$__| $$      | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$         
| $$  | $$ \$$    $$ \$$    $$       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$         
 \$$   \$$  \$$$$$$$  \$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$          
                   __       __                          __                  | $$               
                  |  \     /  \                        |  \                 | $$               
                  | $$\   /  $$  ______   ______ ____  | $$____    ______    ______    _______ 
                  | $$$\ /  $$$ /      \ |      \    \ | $$    \  /      \  /      \  /       \
                  | $$$$\  $$$$|  $$$$$$\| $$$$$$\$$$$\| $$$$$$$\|  $$$$$$\|  $$$$$$\|  $$$$$$$
                  | $$\$$ $$ $$| $$    $$| $$ | $$ | $$| $$  | $$| $$    $$| $$   \$$ \$$    \ 
                  | $$ \$$$| $$| $$$$$$$$| $$ | $$ | $$| $$__/ $$| $$$$$$$$| $$       _\$$$$$$\
                  | $$  \$ | $$ \$$     \| $$ | $$ | $$| $$    $$ \$$     \| $$      |       $$
                   \$$      \$$  \$$$$$$$ \$$  \$$  \$$ \$$$$$$$   \$$$$$$$ \$$       \$$$$$$$ 
                                                                                               
                                                                                               
Description: Add a list of users to an AD group. 
==============================================================================================================================
Note: Account credentials must have Active Directory Object permissions. Must have a list of users at "C:\scripts\users.txt".
The text file and any variables used are purged at script completion to avoid any conflicts or unnecessary data retention. 
Backup your user list as needed, before executing. Use at your own risk.
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
2/3/2023
Created original script to pull users from a comma-separated array.
12/12/2023
Updated the user list array to pull the users from a text file.
2/13/2024
Added code to clear the text file.
Added code to remove the variables used.
12/27/2024
Added changelog.
Added ASCII art.
Added notes to the code.
Added special characters and edited completion message.
1/6/2025
Added code execution timer. Formatted output message.
1/25/2025
Removed special characters to increase compatibility.
1/27/2025
Added code to import AD module.
==============================================================================================================================

#>

# Import the Active Directory module
Import-Module ActiveDirectory 

# Measure the time taken to run the script
$runtime = Measure-Command {

# Set the error action preference to stop on errors
$ErrorActionPreference = "stop"

# Prompt the user to enter the group name
$group = Read-Host "Enter the group name"

# Read the list of users from a file
$userlist = Get-Content C:\scripts\users.txt

# Loop through each user in the list and add them to the specified group
foreach ($user in $userlist) {
    Add-ADGroupMember $group -Members $user -ErrorAction SilentlyContinue
}

# Count the total number of users added
$total = $userlist.count

# Display the user list to the terminal
$userlist | Format-Table

# Display a message indicating the number of users added to the group
Write-Output "Added $total users to $group successfully" | Out-Host

# Display a message to allow time for synchronization
Write-Output "Please allow up to a few minutes to replicate" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the users.txt file
Clear-Content C:\scripts\users.txt
