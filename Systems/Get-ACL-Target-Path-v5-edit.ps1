<#


 $$$$$$\            $$\            $$$$$$\   $$$$$$\  $$\             $$$$$$$$\                                      $$\     
$$  __$$\           $$ |          $$  __$$\ $$  __$$\ $$ |            \__$$  __|                                     $$ |    
$$ /  \__| $$$$$$\$$$$$$\         $$ /  $$ |$$ /  \__|$$ |               $$ | $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\$$$$$$\   
$$ |$$$$\ $$  __$$\_$$  _|        $$$$$$$$ |$$ |      $$ |               $$ | \____$$\ $$  __$$\ $$  __$$\ $$  __$$\_$$  _|  
$$ |\_$$ |$$$$$$$$ |$$ |          $$  __$$ |$$ |      $$ |               $$ | $$$$$$$ |$$ |  \__|$$ /  $$ |$$$$$$$$ |$$ |    
$$ |  $$ |$$   ____|$$ |$$\       $$ |  $$ |$$ |  $$\ $$ |               $$ |$$  __$$ |$$ |      $$ |  $$ |$$   ____|$$ |$$\ 
\$$$$$$  |\$$$$$$$\ \$$$$  |      $$ |  $$ |\$$$$$$  |$$$$$$$$\          $$ |\$$$$$$$ |$$ |      \$$$$$$$ |\$$$$$$$\ \$$$$  |
 \______/  \_______| \____/       \__|  \__| \______/ \________|         \__| \_______|\__|       \____$$ | \_______| \____/ 
                                                                                                 $$\   $$ |                  
                                                                                                 \$$$$$$  |                  
                                                                                                  \______/                                                                  
                                                                      

Description: Pull folder permissions for a target network folder.
==============================================================================================================================
Note: Account credentials must have server admin permissions.
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
10/15/2024
Created original script
1/8/2025
Added changelog.
Added ASCII art.
Modified messages. Added special characters.
Added notes to the code.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Prompt the user to enter the full path as the search term
$search = Read-Host "
Enter the full path to scan`r

"

# Measure the time taken to run the script
$runtime = Measure-Command {

   # Retrieve the Access Control List (ACL) for the specified object
   $acl = Get-ACL $search
   # Format the ACL entries to display specific properties and output the result to the host
   $acl.Access | Format-Table -Property IdentityReference, ActiveDirectoryRights, AccessControlType | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue