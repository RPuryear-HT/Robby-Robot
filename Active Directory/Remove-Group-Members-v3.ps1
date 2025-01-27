<#

                         _______                                                                                           
                        |       \                                                                                          
                        | $$$$$$$\ ______  ______ ____   ______ __     __  ______                                          
                        | $$__| $$/      \|      \    \ /      |  \   /  \/      \                                         
                        | $$    $|  $$$$$$| $$$$$$\$$$$|  $$$$$$\$$\ /  $|  $$$$$$\                                        
                        | $$$$$$$| $$    $| $$ | $$ | $| $$  | $$\$$\  $$| $$    $$                                        
                        | $$  | $| $$$$$$$| $$ | $$ | $| $$__/ $$ \$$ $$ | $$$$$$$$                                        
                        | $$  | $$\$$     | $$ | $$ | $$\$$    $$  \$$$   \$$     \                                        
  ______                 \$$   \$$ \$$$$$$$\$$  \$$  __$ \$$$$__    \$     \$$$$$$$    __                                  
 /      \                                           |  \     /  \                     |  \                                 
|  $$$$$$\ ______   ______  __    __  ______        | $$\   /  $$ ______  ______ ____ | $$____   ______   ______   _______ 
| $$ __\$$/      \ /      \|  \  |  \/      \       | $$$\ /  $$$/      \|      \    \| $$    \ /      \ /      \ /       \
| $$|    |  $$$$$$|  $$$$$$| $$  | $|  $$$$$$\      | $$$$\  $$$|  $$$$$$| $$$$$$\$$$$| $$$$$$$|  $$$$$$|  $$$$$$|  $$$$$$$
| $$ \$$$| $$   \$| $$  | $| $$  | $| $$  | $$      | $$\$$ $$ $| $$    $| $$ | $$ | $| $$  | $| $$    $| $$   \$$\$$    \ 
| $$__| $| $$     | $$__/ $| $$__/ $| $$__/ $$      | $$ \$$$| $| $$$$$$$| $$ | $$ | $| $$__/ $| $$$$$$$| $$      _\$$$$$$\
 \$$    $| $$      \$$    $$\$$    $| $$    $$      | $$  \$ | $$\$$     | $$ | $$ | $| $$    $$\$$     | $$     |       $$
  \$$$$$$ \$$       \$$$$$$  \$$$$$$| $$$$$$$        \$$      \$$ \$$$$$$$\$$  \$$  \$$\$$$$$$$  \$$$$$$$\$$      \$$$$$$$ 
                                    | $$                                                                                   
                                    | $$                                                                                   
                                     \$$                                                                                   

                                                                                                                                        
Description: Remove a list of users from an AD group.
==============================================================================================================================
Note: Must have a user list located at "C:\scripts\removeusers.txt". This will not ask for confirmation. Use at your own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/27/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
6/18/2024
Created original script.
12/27/2024
Added changelog.
Added ASCII art.
Added code to remove the variables used.
1/6/2025
Added notes to the code.
Added special characters and edited status messages.
Added code execution timer. Formatted run time output message.
1/25/2025
Removed special characters to increase compatibility.
1/27/2025
Edited code to capture the group name before the script timer starts.
==============================================================================================================================

#>

# Prompt the user to enter the group name
$group = Read-Host "Enter the group name"

# Measure the time taken to run the script
$runtime = Measure-Command {

# Set the error action preference to stop on errors
$ErrorActionPreference = "stop"

# Read the list of users to be removed from a file
$userlist = Get-Content C:\scripts\removeusers.txt

# Count the total number of users
$total = $userlist.count

Write-Output "Removing $total users from $group" | Out-Host

# Loop through each user in the list and remove them from the specified group
foreach ($user in $userlist) {
    Remove-ADGroupMember $group -Members $user -Confirm:$False -ErrorAction SilentlyContinue
}

# Output the list of users removed
$userlist | Select-Object | Format-Table

# Output a message indicating the number of users removed from the group
Write-Output "Removed $total users from $group successfully" | Out-Host

# Output a message to allow time for replication
Write-Output "Please allow up to a few minutes to replicate" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the removeusers.txt file
Clear-Content C:\scripts\removeusers.txt
