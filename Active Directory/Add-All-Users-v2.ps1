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

                                                                                               
Description: Add all like-named user names to the target AD group name.
==============================================================================================================================
Note: Requires PowerShell 7. Account credentials must have Active Directory Object permissions. This will take seconds up to 
several minutes to run depending on the user count. Please wait for end message. Please replace <TargetAccount> and 
<TargetGroup> with your user and group name. Be sure all target users have the same characters in common. Run at your own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/26/2025
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
==============================================================================================================================

#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Set the error action preference to 'Stop', which will halt script execution if any error occurs
$ErrorActionPreference = 'Stop'

# Retrieve the Active Directory user(s) whose SamAccountName matches the specified target
Get-ADUser -Filter 'SamAccountName -like "<TargetAccount>"' | ForEach-Object -ThrottleLimit 5 -Parallel {
    # For each retrieved user, add them to the specified Active Directory group
    Add-ADGroupMember -Identity "<TargetGroup>" -Members $_.SamAccountName
}

# Output a message to the console indicating that all users were successfully added to the group, with the text in magenta
Write-Host "All users were added to group successfully" -foregroundcolor Magenta
