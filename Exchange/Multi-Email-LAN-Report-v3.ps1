#  

<#

                   /$$      /$$           /$$   /$$     /$$       /$$$$$$$$                         /$$ /$$             
                  | $$$    /$$$          | $$  | $$    |__/      | $$_____/                        |__/| $$             
                  | $$$$  /$$$$ /$$   /$$| $$ /$$$$$$   /$$      | $$       /$$$$$$/$$$$   /$$$$$$  /$$| $$             
                  | $$ $$/$$ $$| $$  | $$| $$|_  $$_/  | $$      | $$$$$   | $$_  $$_  $$ |____  $$| $$| $$             
                  | $$  $$$| $$| $$  | $$| $$  | $$    | $$      | $$__/   | $$ \ $$ \ $$  /$$$$$$$| $$| $$             
                  | $$\  $ | $$| $$  | $$| $$  | $$ /$$| $$      | $$      | $$ | $$ | $$ /$$__  $$| $$| $$             
                  | $$ \/  | $$|  $$$$$$/| $$  |  $$$$/| $$      | $$$$$$$$| $$ | $$ | $$|  $$$$$$$| $$| $$             
                  |__/     |__/ \______/ |__/   \___/  |__/      |________/|__/ |__/ |__/ \_______/|__/|__/             
 /$$        /$$$$$$  /$$   /$$       /$$$$$$ /$$$$$$$        /$$$$$$$                                            /$$    
| $$       /$$__  $$| $$$ | $$      |_  $$_/| $$__  $$      | $$__  $$                                          | $$    
| $$      | $$  \ $$| $$$$| $$        | $$  | $$  \ $$      | $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$  
| $$      | $$$$$$$$| $$ $$ $$        | $$  | $$  | $$      | $$$$$$$/ /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/  
| $$      | $$__  $$| $$  $$$$        | $$  | $$  | $$      | $$__  $$| $$$$$$$$| $$  \ $$| $$  \ $$| $$  \__/  | $$    
| $$      | $$  | $$| $$\  $$$        | $$  | $$  | $$      | $$  \ $$| $$_____/| $$  | $$| $$  | $$| $$        | $$ /$$
| $$$$$$$$| $$  | $$| $$ \  $$       /$$$$$$| $$$$$$$/      | $$  | $$|  $$$$$$$| $$$$$$$/|  $$$$$$/| $$        |  $$$$/
|________/|__/  |__/|__/  \__/      |______/|_______/       |__/  |__/ \_______/| $$____/  \______/ |__/         \___/  
                                                                                | $$                                    
                                                                                | $$                                    
                                                                                |__/                                    


Description: Generate a report of names & LAN IDs based on user's email address. 
==============================================================================================================================
Note: Must have a list of email addresses located at C:\scripts\userlist.txt. Exports list to C:\scriptsOutput. Pulling this 
info from an email address rarely works 100%, so the report may be missing a few folks. Cross-reference your source list.
This will take seconds up to several minutes to run depending on the member count. Please wait for script completion messages. 
Use at your own risk.
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
2/15/2024
Created original script.
8/29/2024
Added code to create a custom object and export a report to CSV.
1/27/2025
Added changelog.
Added ASCII art.
Added notes to the code.
Added code execution timer. Formatted run time output message.
==============================================================================================================================

#>

# Measure the time taken to run the script
$runtime = Measure-Command {

    # Test if output path exists, creates if needed
    $path = "C:\scriptsOutput"
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }

    Write-Output "Gathering user data. This will take some time..." | Out-Host

    # Read the list of users from a text file
    $userlist = Get-Content C:\scripts\userlist.txt
    # Generate a timestamp label for the output file
    $label = Get-Date -Format 'yyyyMMddTHHmmss'
    
    # Loop through each user in the user list
    foreach ($user in $userlist) {
        # Trim empty space from the email address
        $user = $user.Trim()

        # Retrieve user details from Active Directory based on email address
        $user = Get-ADUser -Filter "emailaddress -like '$user'" -Properties GivenName, Surname, UserPrincipalName, SamAccountName | Select-Object GivenName, Surname, UserPrincipalName, SamAccountName -ErrorAction SilentlyContinue
   
        # Create a TextInfo object for first and last name formatting
        $textinfo = (Get-Culture).TextInfo

        # Join the first and last name, separated by a space
        $name = $user.GivenName, $user.Surname -join " "

        # Capitalize the first letter of first and last name
        $capitalizedname = $textinfo.ToTitleCase($name.ToLower())
    
        # Check if $user is null
        if ($null -ne $user) {
            # Create a custom object with the user's details
            [PSCustomObject]@{
                "Name"   = $capitalizedname
                "Email"  = $user.UserPrincipalName.ToLower()
                "LAN ID" = $user.SamAccountName.ToUpper()  # Convert SamAccountName to uppercase
            } | Export-Csv -Path C:\scriptsOutput\users_$label.csv -NoTypeInformation -Append  # Export to CSV
        }
        else {
            continue
        }
    }

    # Output a message indicating the report has been exported
    Write-Output "Report exported to C:\scriptsOutput\users_$label.csv" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Clean up variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue