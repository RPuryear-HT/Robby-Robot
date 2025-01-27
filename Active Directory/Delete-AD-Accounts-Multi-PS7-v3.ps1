<#


                                           /$$$$$$$            /$$             /$$                           
                                          | $$__  $$          | $$            | $$                           
                                          | $$  \ $$  /$$$$$$ | $$  /$$$$$$  /$$$$$$    /$$$$$$              
                                          | $$  | $$ /$$__  $$| $$ /$$__  $$|_  $$_/   /$$__  $$             
                                          | $$  | $$| $$$$$$$$| $$| $$$$$$$$  | $$    | $$$$$$$$             
                                          | $$  | $$| $$_____/| $$| $$_____/  | $$ /$$| $$_____/             
                                          | $$$$$$$/|  $$$$$$$| $$|  $$$$$$$  |  $$$$/|  $$$$$$$             
                                          |_______/  \_______/|__/ \_______/   \___/   \_______/             
                                /$$$$$$                                                      /$$             
                               /$$__  $$                                                    | $$             
                              | $$  \ $$  /$$$$$$$  /$$$$$$$  /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$   /$$$$$$$
                              | $$$$$$$$ /$$_____/ /$$_____/ /$$__  $$| $$  | $$| $$__  $$|_  $$_/  /$$_____/
                              | $$__  $$| $$      | $$      | $$  \ $$| $$  | $$| $$  \ $$  | $$   |  $$$$$$ 
                              | $$  | $$| $$      | $$      | $$  | $$| $$  | $$| $$  | $$  | $$ /$$\____  $$
                              | $$  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$/|  $$$$$$/| $$  | $$  |  $$$$//$$$$$$$/
                              |__/  |__/ \_______/ \_______/ \______/  \______/ |__/  |__/   \___/ |_______/ 
                                                                                                             
                                                                                                             
Description: Delete multiple AD accounts. 
==============================================================================================================================
Note: Requires PowerShell 7. Must have a user list located at C:\scripts\deletes.txt. Will NOT prompt to confirm before 
performing deletions. The text file and any variables used are purged at script completion to avoid any conflicts or 
unnecessary data retention. Backup your user list as needed, before executing. Use at your own risk.
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
2/8/2024
Created original script.
6/18/2024
Rewrote code to use PowerShell 7 parallelism to improve performance.
1/27/2025
Added changelog.
Added ASCII art.
Added notes to the code.
Added code execution timer. Formatted run time output message.
Added code to trim any empty space from the username.
Edited final output message.
Updated the description.
==============================================================================================================================

#>

# Measure the time taken to run the script
$runtime = Measure-Command {

# Read the list of usernames from the specified file
$usernames = Get-Content C:\scripts\deletes.txt

# Set the error action preference to continue on errors
$ErrorActionPreference = "continue"

# Loop through each username and remove the corresponding AD user
$usernames | ForEach-Object -Parallel {
    #Trim any empty space from the username
    $username = $username.Trim()
    # Remove the user from Active Directory without confirmation
    $username | Remove-ADUser -Identity $username -Confirm:$False
}

# Convert all usernames to uppercase
$usernames = $usernames.ToUpper()

# Count the total number of users deleted
$total = $usernames.count

# Output a message indicating the number of users deleted
Write-Host "Deleted $total users successfully" -ForegroundColor DarkRed

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the deletes.txt file
Clear-Content C:\scripts\deletes.txt
