<#

  ______                                  __                       ______                                         
 /      \                                /  |                     /      \                                        
/$$$$$$  |  ______   ______    ______   _$$ |_     ______        /$$$$$$  |  ______   ______   __    __   ______  
$$ |  $$/  /      \ /      \  /      \ / $$   |   /      \       $$ | _$$/  /      \ /      \ /  |  /  | /      \ 
$$ |      /$$$$$$  /$$$$$$  | $$$$$$  |$$$$$$/   /$$$$$$  |      $$ |/    |/$$$$$$  /$$$$$$  |$$ |  $$ |/$$$$$$  |
$$ |   __ $$ |  $$/$$    $$ | /    $$ |  $$ | __ $$    $$ |      $$ |$$$$ |$$ |  $$/$$ |  $$ |$$ |  $$ |$$ |  $$ |
$$ \__/  |$$ |     $$$$$$$$/ /$$$$$$$ |  $$ |/  |$$$$$$$$/       $$ \__$$ |$$ |     $$ \__$$ |$$ \__$$ |$$ |__$$ |
$$    $$/ $$ |     $$       |$$    $$ |  $$  $$/ $$       |      $$    $$/ $$ |     $$    $$/ $$    $$/ $$    $$/ 
 $$$$$$/  $$/       $$$$$$$/  $$$$$$$/    $$$$/   $$$$$$$/        $$$$$$/  $$/       $$$$$$/   $$$$$$/  $$$$$$$/  
                                                                                                        $$ |      
                                                                                                        $$ |      
                                                                                                        $$/       


Description: Create a new AD group and place it in the desired OU.
==============================================================================================================================
Note: Account credentials must have Active Directory Object permissions. Any variables used are purged at script completion
to avoid any conflicts or unnecessary data retention. Use at your own risk.
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
2/2/2023
Created original script.
4/29/2024
Added code to wait 10 seconds before pulling new group info.
12/24/2024
Added changelog.
Added ASCII art.
Added notes to the code.
Added special characters and edited completion message.
1/6/2025
Added code execution timer. Formatted run time output message.
1/30/2025
Removed special characters to increase compatibility.
Moved user input to run first, so not to count towards total run time.
==============================================================================================================================

#>

# Prompt the user to enter the new group name
$group = Read-Host "Enter the new group name"

# Prompt the user to enter a group description
$description = Read-Host "Enter a group description"

# Specify the Organizational Unit (OU) where the group will be created
$ou = Read-Host "Enter the distinguished name for your target OU Ex. OU=<YourOU>,DC=<YourDomain>"

# Measure the time taken to run the script
$runtime = Measure-Command {

# Import the Active Directory module
Import-Module ActiveDirectory

# Display a message indicating the group creation process has started
Write-Output "Creating $group" | Out-Host

# Create a new Active Directory group with the specified name, description, and path
New-ADGroup -Name $group -Description $description -Path $ou -GroupCategory Security -DisplayName $group -GroupScope Global

# Set the error action preference to stop on errors
$ErrorActionPreference = "Stop"

# Pause the script for 10 seconds to allow for group creation
Start-Sleep 10

# Retrieve and display the details of the newly created group
Get-ADGroup -Identity $group

# Display a message indicating the group has been created
Write-Output "Created $group" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue