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
Note: Must have a text file containing target usernames located at 'C:\scripts\deleteorg.txt'.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 2/12/2025
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
2/12/2025
Edited code to import from a text fle, instead of CSV.
Edited code notes.
==============================================================================================================================

#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Import the file containing the usernames
$userlist = Get-Content "C:\scripts\deleteorg.txt"

# Loop through each user in the text file
foreach ($user in $userlist) {

    # Clear the manager attribute in Active Directory
    Set-ADUser -Identity $user -Clear Manager

    # Output the result for each user
    Write-Output "Cleared manager for user $user" | Out-Host
}

# Output a message indicating the manager clearing process is complete
Write-Output "Manager clearing process completed." | Out-Host
