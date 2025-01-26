<#


 /$$      /$$           /$$   /$$     /$$       /$$   /$$                                                          
| $$$    /$$$          | $$  | $$    |__/      | $$  | $$                                                          
| $$$$  /$$$$ /$$   /$$| $$ /$$$$$$   /$$      | $$  | $$  /$$$$$$$  /$$$$$$   /$$$$$$                             
| $$ $$/$$ $$| $$  | $$| $$|_  $$_/  | $$      | $$  | $$ /$$_____/ /$$__  $$ /$$__  $$                            
| $$  $$$| $$| $$  | $$| $$  | $$    | $$      | $$  | $$|  $$$$$$ | $$$$$$$$| $$  \__/                            
| $$\  $ | $$| $$  | $$| $$  | $$ /$$| $$      | $$  | $$ \____  $$| $$_____/| $$                                  
| $$ \/  | $$|  $$$$$$/| $$  |  $$$$/| $$      |  $$$$$$/ /$$$$$$$/|  $$$$$$$| $$                                  
|_/$$$$$$|__/ \______/ |__/   \___/  |__/       \______//$$$$$$$_/  \_______/|__/                           /$$    
 /$$__  $$                                             | $$__  $$                                          | $$    
| $$  \__/  /$$$$$$  /$$$$$$  /$$   /$$  /$$$$$$       | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$  
| $$ /$$$$ /$$__  $$/$$__  $$| $$  | $$ /$$__  $$      | $$$$$$$/ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/  
| $$|_  $$| $$  \__/ $$  \ $$| $$  | $$| $$  \ $$      | $$__  $$| $$$$$$$$| $$  \ $$| $$  \ $$| $$  \__/  | $$    
| $$  \ $$| $$     | $$  | $$| $$  | $$| $$  | $$      | $$  \ $$| $$_____/| $$  | $$| $$  | $$| $$        | $$ /$$
|  $$$$$$/| $$     |  $$$$$$/|  $$$$$$/| $$$$$$$/      | $$  | $$|  $$$$$$$| $$$$$$$/|  $$$$$$/| $$        |  $$$$/
 \______/ |__/      \______/  \______/ | $$____/       |__/  |__/ \_______/| $$____/  \______/ |__/         \___/  
                                       | $$                                | $$                                    
                                       | $$                                | $$                                    
                                       |__/                                |__/                                    


Description: Generate a report of user's AD group memberships from a list of users. 
==============================================================================================================================
Note: Must have a list of users located in C:\scripts\userlist.txt.
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
10/16/2024
Created original script.
11/4/2024
Added code to export the report.
12/27/2024
Added changelog.
Added ASCII art.
Added code to remove the variables used.
1/6/2025
Added notes to the code.
Added special characters and edited status messages.
Added code execution timer. Formatted run time output message.
Changed output path to C:\scriptsOutput.
1/17/2025
Added code to trim empty space from the username.
Added code to test if the output path exists, creates if needed.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Test if output path exists, creates if needed
$path = "C:\scriptsOutput"
if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}

# Measure the time taken to run the script
$runtime = Measure-Command {

    # Import the Active Directory module
    Import-Module ActiveDirectory

    # Read the list of users from a file
    $users = Get-Content C:\scripts\$userlist.txt

    # Display a message to inform the user that group membership info is being gathered
    Write-Output "Gathering user(s) group membership info... This may take some time..." | Out-Host

    # Initialize an empty array to store the user-group associations
    $usergroups = @()

    # Loop through each user in the list
    foreach ($user in $users) {

        # Trim empty space from each username
        $user = $user.Trim()

        # Retrieve the user object from Active Directory with additional properties
        $userobject = Get-ADUser -Identity $user -Properties DisplayName, MemberOf
    
        # Retrieve the groups the user is a member of
        $groups = $userobject.MemberOf

        # Loop through each group the user is a member of
        foreach ($group in $groups) {
            # Retrieve the group object from Active Directory with additional properties
            $groupobject = Get-ADGroup -Identity $group -Properties Description
        
            # Add the user and group details to the userGroups array as a custom object
            $usergroups += [PSCustomObject]@{
                User        = $user
                Name        = $userobject.DisplayName
                Group       = $groupobject.Name
                Description = $groupobject.Description
            }
        }
    }

    # Generate a timestamp label for the report file
    $label = Get-Date -Format 'yyyyMMddTHHmmss'

    # Define the path for the CSV report file
    $csvpath = "C:\scriptsOutput\Multi_User_Groups_$label.csv"

    # Export the userGroups array to a CSV file without type information
    $usergroups | Export-Csv -Path $csvpath -NoTypeInformation

    # Output a message indicating the report has been exported
    Write-Output "Report exported to $csvpath" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue