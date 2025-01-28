<#


              /$$$$$$  /$$$$$$$        /$$   /$$                              
             /$$__  $$| $$__  $$      | $$  | $$                              
            | $$  \ $$| $$  \ $$      | $$  | $$  /$$$$$$$  /$$$$$$   /$$$$$$ 
            | $$$$$$$$| $$  | $$      | $$  | $$ /$$_____/ /$$__  $$ /$$__  $$
            | $$__  $$| $$  | $$      | $$  | $$|  $$$$$$ | $$$$$$$$| $$  \__/
            | $$  | $$| $$  | $$      | $$  | $$ \____  $$| $$_____/| $$      
            | $$  | $$| $$$$$$$/      |  $$$$$$/ /$$$$$$$/|  $$$$$$$| $$      
            |__/  |__/|_______/        \______/ |_______/  \_______/|__/      
              /$$$$$$                                          /$$            
             /$$__  $$                                        | $$            
            | $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$| $$$$$$$       
            |  $$$$$$  /$$__  $$ |____  $$ /$$__  $$ /$$_____/| $$__  $$      
             \____  $$| $$$$$$$$  /$$$$$$$| $$  \__/| $$      | $$  \ $$      
             /$$  \ $$| $$_____/ /$$__  $$| $$      | $$      | $$  | $$      
            |  $$$$$$/|  $$$$$$$|  $$$$$$$| $$      |  $$$$$$$| $$  | $$      
             \______/  \_______/ \_______/|__/       \_______/|__/  |__/      
                                                                              
                                                                        
Description: Search AD users based on you search term.  
==============================================================================================================================
Note: Requires manual editing. Replace <YourSearchTerm> with your search criteria. This will take seconds up to several 
minutes to run depending on the user count. Please wait for script completion messages. Use at your own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/28/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
12/20/2023
Created original script
11/4/2024
Edited code to sort the output.
1/6/2025
Added code execution timer. Formatted run time output message.
1/28/2025
Added notes to code.
Added changelog.
Added ASCII art.
Added status messages.
Optimized code to reduce run time.
==============================================================================================================================

#>

# Import the Active Directory module to use AD cmdlets
Import-Module ActiveDirectory

# Display a message that searching has begun 
Write-Output "Searching for the specified criteria. This will take some time..." | Out-Host

# Measure the time taken to run the script
$runtime = Measure-Command {

# Retrieve and display a list of Active Directory users whose names match the specific search pattern
Get-ADUser -Filter {name -like "*<YourSearchTerm>*"} -Properties SamAccountName | Select-Object Name | Sort-Object Name | Out-Host

}

# Display a message that searching has finished
Write-Output "Search completed" | Out-Host
    
# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds
    
# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host
    
# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
