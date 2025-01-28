<#


              /$$$$$$  /$$$$$$$         /$$$$$$                                         
             /$$__  $$| $$__  $$       /$$__  $$                                        
            | $$  \ $$| $$  \ $$      | $$  \__/  /$$$$$$   /$$$$$$  /$$   /$$  /$$$$$$ 
            | $$$$$$$$| $$  | $$      | $$ /$$$$ /$$__  $$ /$$__  $$| $$  | $$ /$$__  $$
            | $$__  $$| $$  | $$      | $$|_  $$| $$  \__/| $$  \ $$| $$  | $$| $$  \ $$
            | $$  | $$| $$  | $$      | $$  \ $$| $$      | $$  | $$| $$  | $$| $$  | $$
            | $$  | $$| $$$$$$$/      |  $$$$$$/| $$      |  $$$$$$/|  $$$$$$/| $$$$$$$/
            |__/  |__/|_______/        \______/ |__/       \______/  \______/ | $$____/ 
                    /$$$$$$                                          /$$      | $$      
                   /$$__  $$                                        | $$      | $$      
                  | $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$| $$$$$$$ |__/      
                  |  $$$$$$  /$$__  $$ |____  $$ /$$__  $$ /$$_____/| $$__  $$          
                   \____  $$| $$$$$$$$  /$$$$$$$| $$  \__/| $$      | $$  \ $$          
                   /$$  \ $$| $$_____/ /$$__  $$| $$      | $$      | $$  | $$          
                  |  $$$$$$/|  $$$$$$$|  $$$$$$$| $$      |  $$$$$$$| $$  | $$          
                   \______/  \_______/ \_______/|__/       \_______/|__/  |__/          
                                                                                        
                                                                                        
Description: Search AD groups based on you search term and export a report of the results.
==============================================================================================================================
Note: Requires manual editing. Replace <YourSearchTerm> with your search criteria. This will take milliseconds up to minutes 
to run depending on the group count. Please wait for script completion messages. Use at your own risk.
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
10/5/2023
Created original script
1/30/2024
Edited code to sort the output.
1/28/2025
Added code execution timer. Formatted run time output message.
Added notes to code.
Added changelog.
Added ASCII art.
Added status messages.
Added code to export to CSV.
==============================================================================================================================

#>

# Import the Active Directory module to use AD cmdlets
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

# Display message that search started
Write-Output "Searching for group. This will take some time..." | Out-Host    

# Generate a timestamp label for the report file
$label = Get-Date -Format 'yyyyMMddTHHmmss'

# Retrieve all user objects from Active Directory where the name matches the specified search pattern, sort by name and display out to the console
Get-ADGroup -Filter {name -like "*<YourSearchTerm>*"} -Properties Description,info | Select-Object Name,samaccountname,Description,info | Sort-Object Name | Export-Csv -Path "C:\scriptsOutput\AD_Group_Search_$label.csv" -NoTypeInformation -Append | Out-Host

# Display message that search ended
Write-Output "Search complete. Report exported to C:\scriptsOutput\AD_Group_Search_$label.csv" | Out-Host    

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
