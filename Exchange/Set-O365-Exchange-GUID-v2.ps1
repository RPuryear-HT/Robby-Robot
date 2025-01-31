<#


 $$$$$$\            $$\            $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\         $$$$$$\  $$\   $$\ $$$$$$\ $$$$$$$\  
$$  __$$\           $$ |          $$  __$$\ $$ ___$$\ $$  __$$\ $$  ____|       $$  __$$\ $$ |  $$ |\_$$  _|$$  __$$\ 
$$ /  \__| $$$$$$\$$$$$$\         $$ /  $$ |\_/   $$ |$$ /  \__|$$ |            $$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |
\$$$$$$\  $$  __$$\_$$  _|        $$ |  $$ |  $$$$$ / $$$$$$$\  $$$$$$$\        $$ |$$$$\ $$ |  $$ |  $$ |  $$ |  $$ |
 \____$$\ $$$$$$$$ |$$ |          $$ |  $$ |  \___$$\ $$  __$$\ \_____$$\       $$ |\_$$ |$$ |  $$ |  $$ |  $$ |  $$ |
$$\   $$ |$$   ____|$$ |$$\       $$ |  $$ |$$\   $$ |$$ /  $$ |$$\   $$ |      $$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |
\$$$$$$  |\$$$$$$$\ \$$$$  |       $$$$$$  |\$$$$$$  | $$$$$$  |\$$$$$$  |      \$$$$$$  |\$$$$$$  |$$$$$$\ $$$$$$$  |
 \______/  \_______| \____/        \______/  \______/  \______/  \______/        \______/  \______/ \______|\_______/ 
                                                                                                                      
                                                                                                                      
Description: Set the ExchangeGUID property of a remote mailbox.
==============================================================================================================================
Note: Look for a popup window prompting for your O365 credentials. Account credentials must have the proper rights in O365.
Accounts with invalid GUIDs cannot be converted to on-prem, without first setting a valid GUID.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/10/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
3/1/2023
Created original script.
1/10/2025
Added code to connect to O365 without displaying the banner.
Added changelog.
Added ASCII art.
Added code to remove the variables used.
Added notes to the code.
Added code to validate the length of the GUID is 36 characters.
==============================================================================================================================

#>

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Prompt user to check for the Exchange Online logon window
Write-Host "Waiting for user to authenticate.. Please check the Exchange Online logon window to continue.."

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Prompt the user to enter the username
$user = Read-Host "Enter the Username"

do {
    # Prompt the user to enter the username
    $guid = Read-Host "Enter the new GUID, including dashes. Ex. 00000000-0000-0000-0000-000000000000"
    # Check if the input length is 36 characters
    if ($userInput.Length -eq 36) {
        $user = $user.ToUpper() # Convert the username to uppercase
        $valid = $true # Set the valid flag to true if the username is valid
    }
    else {
        # Output a message indicating the GUID is invalid and define the criteria
        Write-Output "GUID is invalid. It must be at least 36 characters, including dashes." | Out-Host
        $valid = $false # Set the valid flag to false if the username is invalid
    }
} while (-not $valid) # Repeat the loop until a valid username is entered

# Set the ExchangeGUID for the specified remote mailbox
Set-RemoteMailbox $user -ExchangeGUID $guid

# Retrieve and display the ExchangeGUID of the specified mailbox
Get-Mailbox $user | Format-List ExchangeGUID 

# Output a message indicating that the GUID has been updated successfully
Write-Output "$user GUID updated successfully" | Out-Host
