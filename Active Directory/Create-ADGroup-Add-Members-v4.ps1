<#

  ______                                   __                       ______                                             
 /      \                                 |  \                     /      \                                            
|  $$$$$$\  ______    ______    ______   _| $$_     ______        |  $$$$$$\  ______    ______   __    __   ______     
| $$   \$$ /      \  /      \  |      \ |   $$ \   /      \       | $$ __\$$ /      \  /      \ |  \  |  \ /      \    
| $$      |  $$$$$$\|  $$$$$$\  \$$$$$$\ \$$$$$$  |  $$$$$$\      | $$|    \|  $$$$$$\|  $$$$$$\| $$  | $$|  $$$$$$\   
| $$   __ | $$   \$$| $$    $$ /      $$  | $$ __ | $$    $$      | $$ \$$$$| $$   \$$| $$  | $$| $$  | $$| $$  | $$   
| $$__/  \| $$      | $$$$$$$$|  $$$$$$$  | $$|  \| $$$$$$$$      | $$__| $$| $$      | $$__/ $$| $$__/ $$| $$__/ $$   
 \$$    $$| $$       \$$     \ \$$    $$   \$$  $$ \$$     \       \$$    $$| $$       \$$    $$ \$$    $$| $$    $$   
  \$$$$$$  \$$        \$$$$$$$  \$$$$$$$    \$$$$   \$$$$$$$        \$$$$$$  \$$        \$$$$$$   \$$$$$$ | $$$$$$$    
        ______         __        __        __       __                          __                        | $$         
       /      \       |  \      |  \      |  \     /  \                        |  \                       | $$         
      |  $$$$$$\  ____| $$  ____| $$      | $$\   /  $$  ______   ______ ____  | $$____    ______    ______\$$ _______ 
      | $$__| $$ /      $$ /      $$      | $$$\ /  $$$ /      \ |      \    \ | $$    \  /      \  /      \  /       \
      | $$    $$|  $$$$$$$|  $$$$$$$      | $$$$\  $$$$|  $$$$$$\| $$$$$$\$$$$\| $$$$$$$\|  $$$$$$\|  $$$$$$\|  $$$$$$$
      | $$$$$$$$| $$  | $$| $$  | $$      | $$\$$ $$ $$| $$    $$| $$ | $$ | $$| $$  | $$| $$    $$| $$   \$$ \$$    \ 
      | $$  | $$| $$__| $$| $$__| $$      | $$ \$$$| $$| $$$$$$$$| $$ | $$ | $$| $$__/ $$| $$$$$$$$| $$       _\$$$$$$\
      | $$  | $$ \$$    $$ \$$    $$      | $$  \$ | $$ \$$     \| $$ | $$ | $$| $$    $$ \$$     \| $$      |       $$
       \$$   \$$  \$$$$$$$  \$$$$$$$       \$$      \$$  \$$$$$$$ \$$  \$$  \$$ \$$$$$$$   \$$$$$$$ \$$       \$$$$$$$ 
                                                                                                                       
                                                                                                                       
Description: Creates a new AD group, places it in your desired OU and adds a list of users as the group members.
==============================================================================================================================
Note: Account credentials must have Active Directory Object permissions. Must have a list of users located at 
C:\scripts\users.txt. The text file and any variables used are purged at script completion to avoid any conflicts or 
unnecessary data retention. Backup your user list as needed, before executing. This will take seconds up to several minutes to
run depending on the user count. Please wait for script completion messages. Use at your own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/30/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
10/30/2024
Created original script.
12/27/2024
Added changelog.
Added ASCII art.
Added notes to the code.
Added special characters and edited completion message.
1/6/2025
Added code execution timer. Formatted output message.
1/30/2025
Removed special characters to increase compatibility.
Moved user input to run first, so not to count towards total run time.
==============================================================================================================================

#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Prompt the user to enter the new group name
$group = Read-Host "Enter the new group name"

# Prompt the user to enter a group description
$description = Read-Host "Enter the group description"

# Specify the Organizational Unit (OU) where the group will be created
$ou = Read-Host "Enter the distinguished name for your target OU Ex. OU=<YourOU>,DC=<YourDomain>"

# Measure the time taken to run the script
$runtime = Measure-Command {

# Set the error action preference to stop on errors
$ErrorActionPreference = "Stop"

# Display a message indicating the group creation process has started
Write-Output " Creating $group" | Out-Host

# Create a new Active Directory group with the specified name, description, and path
New-ADGroup -Name $group -Description $description -Path $ou -GroupCategory Security -DisplayName $group -GroupScope Global

# Pause the script for 15 seconds to allow for group creations
Start-Sleep 15

# Retrieve and display the details of the newly created group
Get-ADGroup -Identity $group | Out-Host

# Display a message indicating the group has been created
Write-Output " Created $group" | Out-Host

# Read the list of users from a file
$userlist = Get-Content C:\scripts\users.txt

# Display a message indicating the process of adding group members has started
Write-Output "Adding group members to $group" | Out-Host

# Loop through each user in the list and add them to the specified group
foreach ($user in $userlist) {
    Add-ADGroupMember $group -Members $user -ErrorAction SilentlyContinue
}

# Count the total number of users added to the group
$total = $userlist.count

#Display the user list to the terminal
$userlist | Format-Table

# Display a message indicating the number of users added to the group
Write-Output "Added $total users to $group successfully" | Out-Host

# Display a message indicating the group creation operation is complete
Write-Output "Create $group operation complete" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the users.txt file
Clear-Content C:\scripts\users.txt