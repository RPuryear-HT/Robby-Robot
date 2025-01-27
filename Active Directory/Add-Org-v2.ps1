<#


  /$$$$$$        /$$       /$$        /$$$$$$                     
 /$$__  $$      | $$      | $$       /$$__  $$                    
| $$  \ $$  /$$$$$$$  /$$$$$$$      | $$  \ $$  /$$$$$$   /$$$$$$ 
| $$$$$$$$ /$$__  $$ /$$__  $$      | $$  | $$ /$$__  $$ /$$__  $$
| $$__  $$| $$  | $$| $$  | $$      | $$  | $$| $$  \__/| $$  \ $$
| $$  | $$| $$  | $$| $$  | $$      | $$  | $$| $$      | $$  | $$
| $$  | $$|  $$$$$$$|  $$$$$$$      |  $$$$$$/| $$      |  $$$$$$$
|__/  |__/ \_______/ \_______/       \______/ |__/       \____  $$
             /$$$$$$            /$$$$$$                  /$$  \ $$
            |_  $$_/           /$$__  $$                |  $$$$$$/
              | $$   /$$$$$$$ | $$  \__//$$$$$$          \______/ 
              | $$  | $$__  $$| $$$$   /$$__  $$                  
              | $$  | $$  \ $$| $$_/  | $$  \ $$                  
              | $$  | $$  | $$| $$    | $$  | $$                  
             /$$$$$$| $$  | $$| $$    |  $$$$$$/                  
            |______/|__/  |__/|__/     \______/                   
                                                                  
                                                                
Description: Update the manager for a list of AD users. 
==============================================================================================================================
Note: Must have a properly formatted csv file containing target usernames. Below are 2 examples of formatting needing for the 
csv file. Either works, but separate columns is easier to manipulate. 

Make sure your CSV file has the Username header. For example:

(1) Example of csv format:

|Manager|Username| <<<<<<<<<< Header
|boss1|user1 | 
|boss2|user2 | 

(2) Example of csv format:

Username,Manager       <<<<<<<<<< Header
user1,boss1    
user2,boss2 
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
10/24/2024 
Created original script.
1/27/2025
Added changelog.
Added ASCII art.
Added code to remove the variables used.
Added notes to the code.
Added code execution timer. Formatted run time output message.
==============================================================================================================================

#>

# Import the Active Directory module to use AD cmdlets
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

# Define the path to the CSV file containing user and manager information
$csv = "C:\scripts\addorg.csv"

# Import the CSV file into a variable
$userlist = Import-Csv -Path $csv

# Loop through each user in the CSV file
foreach ($user in $userlist) {
    # Extract the username and manager from the current row
    $username = $user.Username
    $manager = $user.Manager
    
    # Update the manager attribute for the user in Active Directory
    Set-ADUser -Identity $username -Manager $manager
    
    # Output a message indicating the update was successful
    Write-Output "Updated manager for user $username to $manager" | Out-Host
}

# Output a final message indicating the process is complete
Write-Host "Manager add process completed." -ForegroundColor Green

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
