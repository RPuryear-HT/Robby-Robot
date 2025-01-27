<#


 /$$$$$$$            /$$             /$$                      /$$$$$$                     
| $$__  $$          | $$            | $$                     /$$__  $$                    
| $$  \ $$  /$$$$$$ | $$  /$$$$$$  /$$$$$$    /$$$$$$       | $$  \ $$  /$$$$$$   /$$$$$$ 
| $$  | $$ /$$__  $$| $$ /$$__  $$|_  $$_/   /$$__  $$      | $$  | $$ /$$__  $$ /$$__  $$
| $$  | $$| $$$$$$$$| $$| $$$$$$$$  | $$    | $$$$$$$$      | $$  | $$| $$  \__/| $$  \ $$
| $$  | $$| $$_____/| $$| $$_____/  | $$ /$$| $$_____/      | $$  | $$| $$      | $$  | $$
| $$$$$$$/|  $$$$$$$| $$|  $$$$$$$  |  $$$$/|  $$$$$$$      |  $$$$$$/| $$      |  $$$$$$$
|_______/  \_______/|__/ \_______/   \___/   \_______/       \______/ |__/       \____  $$
                               /$$$$$$            /$$$$$$                        /$$  \ $$
                              |_  $$_/           /$$__  $$                      |  $$$$$$/
                                | $$   /$$$$$$$ | $$  \__//$$$$$$                \______/ 
                                | $$  | $$__  $$| $$$$   /$$__  $$                        
                                | $$  | $$  \ $$| $$_/  | $$  \ $$                        
                                | $$  | $$  | $$| $$    | $$  | $$                        
                               /$$$$$$| $$  | $$| $$    |  $$$$$$/                        
                              |______/|__/  |__/|__/     \______/                         
                                                                                          
                                                                                          
Description: Clear the manager for a list of AD users.
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

Import-Module ActiveDirectory
$csv = "C:\scripts\deleteorg.csv"
$userlist = Import-Csv -Path $csv
foreach ($user in $userlist) {
    $username = $user.Username
    Set-ADUser -Identity $username -Clear Manager
    Write-Output "Cleared manager for user $username"
}
Write-Host "Manager clearing process completed." -ForegroundColor Red
<# 

Note: Below are 2 examples of formatting needing for the csv file. Either works, but separate columns is easier to manipulate. 

Make sure your CSV file has the Username header. For example:

|Manager|Username| <<<<<<<<<< Header
|boss1|user1 | 
|boss2|user2 | 

(2) Example of csv format:

Username,Manager       <<<<<<<<<< Header
user1,boss1    
user2,boss2    

Created by Robert Puryear # Updated 10/24/2024 

#>
