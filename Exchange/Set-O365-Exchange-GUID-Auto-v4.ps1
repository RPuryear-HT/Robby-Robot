<#


 $$$$$$\            $$\            $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\         $$$$$$\  $$\   $$\ $$$$$$\ $$$$$$$\  
$$  __$$\           $$ |          $$  __$$\ $$ ___$$\ $$  __$$\ $$  ____|       $$  __$$\ $$ |  $$ |\_$$  _|$$  __$$\ 
$$ /  \__| $$$$$$\$$$$$$\         $$ /  $$ |\_/   $$ |$$ /  \__|$$ |            $$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |
\$$$$$$\  $$  __$$\_$$  _|        $$ |  $$ |  $$$$$ / $$$$$$$\  $$$$$$$\        $$ |$$$$\ $$ |  $$ |  $$ |  $$ |  $$ |
 \____$$\ $$$$$$$$ |$$ |          $$ |  $$ |  \___$$\ $$  __$$\ \_____$$\       $$ |\_$$ |$$ |  $$ |  $$ |  $$ |  $$ |
$$\   $$ |$$   ____|$$ |$$\       $$ |  $$ |$$\   $$ |$$ /  $$ |$$\   $$ |      $$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |
\$$$$$$  |\$$$$$$$\ \$$$$  |       $$$$$$  |\$$$$$$  | $$$$$$  |\$$$$$$  |      \$$$$$$  |\$$$$$$  |$$$$$$\ $$$$$$$  |
 \______/  \_______| \____/        \______/  \______/  \______/  \______/        \______/  \______/ \______|\_______/ 
                                                                                                                      
                                                                                                                      
Description: Sets O365 GUID if the value is zero. If not, displays the current GUID value.
==============================================================================================================================
Note: Look for a popup window prompting for your O365 credentials. Account credentials must have the proper rights in O365.
Accounts with invalid GUIDs cannot be converted to on-prem, without first setting a valid GUID.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/10/2025
==============================================================================================================================
Reference Article: https://learn.microsoft.com/en-us/exchange/troubleshoot/move-mailboxes/migrationpermanentexception-when-moving-mailboxes
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
3/6/2023
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

# Retrieve the ExchangeGUID of the specified mailbox and format it as a list
$guid = Get-Mailbox $user | Format-List ExchangeGUID

# Check if the GUID matches the pattern "00000000*"
if ($guid -eq "00000000*") {
    # If the GUID matches the pattern, retrieve a new GUID for the mailbox
    $newguid = Get-Mailbox $user | Format-List ExchangeGUID
    # Set the new ExchangeGUID for the specified remote mailbox
    Set-RemoteMailbox $user -ExchangeGUID $newguid
}
else {
    # If the GUID does not match the pattern, display the current GUID
    $guid
}

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue
