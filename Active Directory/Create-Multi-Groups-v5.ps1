<#

  ______                                  __                      __       __            __    __      __         ______                                                   
 /      \                                /  |                    /  \     /  |          /  |  /  |    /  |       /      \                                                  
/$$$$$$  |  ______   ______    ______   _$$ |_     ______        $$  \   /$$ | __    __ $$ | _$$ |_   $$/       /$$$$$$  |  ______   ______   __    __   ______    _______ 
$$ |  $$/  /      \ /      \  /      \ / $$   |   /      \       $$$  \ /$$$ |/  |  /  |$$ |/ $$   |  /  |      $$ | _$$/  /      \ /      \ /  |  /  | /      \  /       |
$$ |      /$$$$$$  /$$$$$$  | $$$$$$  |$$$$$$/   /$$$$$$  |      $$$$  /$$$$ |$$ |  $$ |$$ |$$$$$$/   $$ |      $$ |/    |/$$$$$$  /$$$$$$  |$$ |  $$ |/$$$$$$  |/$$$$$$$/ 
$$ |   __ $$ |  $$/$$    $$ | /    $$ |  $$ | __ $$    $$ |      $$ $$ $$/$$ |$$ |  $$ |$$ |  $$ | __ $$ |      $$ |$$$$ |$$ |  $$/$$ |  $$ |$$ |  $$ |$$ |  $$ |$$      \ 
$$ \__/  |$$ |     $$$$$$$$/ /$$$$$$$ |  $$ |/  |$$$$$$$$/       $$ |$$$/ $$ |$$ \__$$ |$$ |  $$ |/  |$$ |      $$ \__$$ |$$ |     $$ \__$$ |$$ \__$$ |$$ |__$$ | $$$$$$  |
$$    $$/ $$ |     $$       |$$    $$ |  $$  $$/ $$       |      $$ | $/  $$ |$$    $$/ $$ |  $$  $$/ $$ |      $$    $$/ $$ |     $$    $$/ $$    $$/ $$    $$/ /     $$/ 
 $$$$$$/  $$/       $$$$$$$/  $$$$$$$/    $$$$/   $$$$$$$/       $$/      $$/  $$$$$$/  $$/    $$$$/  $$/        $$$$$$/  $$/       $$$$$$/   $$$$$$/  $$$$$$$/  $$$$$$$/  
                                                                                                                                                       $$ |                
                                                                                                                                                       $$ |                
                                                                                                                                                       $$/                 

Description: Creates multiple AD groups and places them in the desired OU.
==============================================================================================================================
Note: Account credentials must have Active Directory Object permissions. Must have a list of groups located at 
C:\scripts\newgroups.txt. The text file and any variables used are purged at script completion to avoid any conflicts or 
unnecessary data retention. Backup your user list as needed, before executing. This will take seconds up to several minutes to
run depending on the group count. Please wait for script completion messages. Use at your own risk.
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
9/5/2024
Created original script.
12/24/2024
Added changelog.
Added ASCII art.
12/31/2024
Added notes to the code.
Added special characters and edited completion message.
1/6/2025
Added code execution timer. Formatted run time output message.
1/30/2025
Removed special characters to increase compatibility.
Moved some user input code to run first, so not to count towards total run time.
==============================================================================================================================

#>

# Specify the Organizational Unit (OU) where the groups will be created
$ou = Read-Host "Enter the distinguished name for your target OU Ex. OU=<YourOU>,DC=<YourDomain>"

# Import the Active Directory module
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

# Read the list of new groups from a file
$groups = Get-Content C:\scripts\newgroups.txt

# Loop through each group in the list
foreach ($group in $groups) {
    # Prompt the user to enter a description for the current group
    $description = Read-Host "Enter a description for $group"
    
    # Display a message indicating the group creation process has started
    Write-Output "Creating $group" | Out-Host
    
    # Create a new Active Directory group with the specified name, description, and path
    New-ADGroup -Name $group -Description $description -Path $ou -GroupCategory Security -DisplayName $group -GroupScope Global
    
    # Display a message indicating the group has been created
    Write-Output "Created $group" | Out-Host
}

# Count the total number of groups created
$total = $groups.count

#Display the group list to the terminal
$groups | Format-Table

# Display a message indicating the number of users added to the group
Write-Output "Created $total groups successfully" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the newgroups.txt file
Clear-Content C:\scripts\newgroups.txt