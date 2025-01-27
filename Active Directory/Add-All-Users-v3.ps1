<#


 $$$$$$\        $$\       $$\        $$$$$$\  $$\ $$\       $$\   $$\                               $$\                                  
$$  __$$\       $$ |      $$ |      $$  __$$\ $$ |$$ |      $$ |  $$ |                              $$ |                                 
$$ /  $$ | $$$$$$$ | $$$$$$$ |      $$ /  $$ |$$ |$$ |      $$ |  $$ | $$$$$$$\  $$$$$$\   $$$$$$\$$$$$$\  $$\   $$\  $$$$$$\   $$$$$$\  
$$$$$$$$ |$$  __$$ |$$  __$$ |      $$$$$$$$ |$$ |$$ |      $$ |  $$ |$$  _____|$$  __$$\ $$  __$$\_$$  _| $$ |  $$ |$$  __$$\ $$  __$$\ 
$$  __$$ |$$ /  $$ |$$ /  $$ |      $$  __$$ |$$ |$$ |      $$ |  $$ |\$$$$$$\  $$$$$$$$ |$$ |  \__|$$ |   $$ |  $$ |$$ /  $$ |$$$$$$$$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |      $$ |  $$ |$$ |$$ |      $$ |  $$ | \____$$\ $$   ____|$$ |      $$ |$$\$$ |  $$ |$$ |  $$ |$$   ____|
$$ |  $$ |\$$$$$$$ |\$$$$$$$ |      $$ |  $$ |$$ |$$ |      \$$$$$$  |$$$$$$$  |\$$$$$$$\ $$ |      \$$$$  \$$$$$$$ |$$$$$$$  |\$$$$$$$\ 
\__|  \__| \_______| \_______|      \__|  \__|\__|\__|       \______/ \_______/  \_______|\__|       \____/ \____$$ |$$  ____/  \_______|
$$$$$$$$\                                      $$\            $$$$$$\                                      $$\   $$ |$$ |                
\__$$  __|                                     $$ |          $$  __$$\                                     \$$$$$$  |$$ |                
   $$ | $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\$$$$$$\         $$ /  \__| $$$$$$\   $$$$$$\  $$\   $$\  $$$$$$\______/ \__|                
   $$ | \____$$\ $$  __$$\ $$  __$$\ $$  __$$\_$$  _|        $$ |$$$$\ $$  __$$\ $$  __$$\ $$ |  $$ |$$  __$$\                           
   $$ | $$$$$$$ |$$ |  \__|$$ /  $$ |$$$$$$$$ |$$ |          $$ |\_$$ |$$ |  \__|$$ /  $$ |$$ |  $$ |$$ /  $$ |                          
   $$ |$$  __$$ |$$ |      $$ |  $$ |$$   ____|$$ |$$\       $$ |  $$ |$$ |      $$ |  $$ |$$ |  $$ |$$ |  $$ |                          
   $$ |\$$$$$$$ |$$ |      \$$$$$$$ |\$$$$$$$\ \$$$$  |      \$$$$$$  |$$ |      \$$$$$$  |\$$$$$$  |$$$$$$$  |                          
   \__| \_______|\__|       \____$$ | \_______| \____/        \______/ \__|       \______/  \______/ $$  ____/                           
                           $$\   $$ |                                                                $$ |                                
                           \$$$$$$  |                                                                $$ |                                
                            \______/                                                                 \__|                                                                                                             

                                                                                               
Description: Add all users to the target AD group based on the user nomenclature.
==============================================================================================================================
Note: Requires PowerShell 7. Please replace <TargetAccount> and <TargetGroup> with your user's naming scheme and your group 
name. Account credentials must have Active Directory Object permissions. This will take seconds up to several minutes to run 
depending on the user count. Please wait for script completion messages. Be sure all target users have the same characters in 
common. If unsure, please research or use another method. Use at your own risk.
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
3/2/2023
Created original script
1/26/2025
Added changelog.
Added ASCII art.
Added notes to the code.
Added code execution timer. Formatted output message.
Added code to remove any variables used.
1/27/2025
Updated the description.
==============================================================================================================================

#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

# Set the error action preference to 'Stop', which will halt script execution if any error occurs
$ErrorActionPreference = 'Stop'

# Retrieve the Active Directory user(s) whose SamAccountName matches the specified target
Get-ADUser -Filter 'SamAccountName -like "<TargetAccount>"' | ForEach-Object -ThrottleLimit 5 -Parallel {
    # For each retrieved user, add them to the specified Active Directory group
    Add-ADGroupMember -Identity "<TargetGroup>" -Members $_.SamAccountName
}

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Output a message to the console indicating that all users were successfully added to the group, with the text in magenta
Write-Host "All users were added to group successfully" -foregroundcolor Magenta

# Clean up variables to avoid any conflicts or unnecessary data retention
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
