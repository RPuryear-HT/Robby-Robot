<#


  $$$$$$\            $$\            $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\         $$$$$$\  $$\   $$\ $$$$$$\ $$$$$$$\  
$$  __$$\           $$ |          $$  __$$\ $$ ___$$\ $$  __$$\ $$  ____|       $$  __$$\ $$ |  $$ |\_$$  _|$$  __$$\ 
$$ /  \__| $$$$$$\$$$$$$\         $$ /  $$ |\_/   $$ |$$ /  \__|$$ |            $$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |
$$ |$$$$\ $$  __$$\_$$  _|        $$ |  $$ |  $$$$$ / $$$$$$$\  $$$$$$$\        $$ |$$$$\ $$ |  $$ |  $$ |  $$ |  $$ |
$$ |\_$$ |$$$$$$$$ |$$ |          $$ |  $$ |  \___$$\ $$  __$$\ \_____$$\       $$ |\_$$ |$$ |  $$ |  $$ |  $$ |  $$ |
$$ |  $$ |$$   ____|$$ |$$\       $$ |  $$ |$$\   $$ |$$ /  $$ |$$\   $$ |      $$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |
\$$$$$$  |\$$$$$$$\ \$$$$  |       $$$$$$  |\$$$$$$  | $$$$$$  |\$$$$$$  |      \$$$$$$  |\$$$$$$  |$$$$$$\ $$$$$$$  |
 \______/  \_______| \____/        \______/  \______/  \______/  \______/        \______/  \______/ \______|\_______/ 
                                                                                                                      
                                                                                                                      
Description: Checks whether the ExchangeGUID property of the remote mailbox is set and outputs the value on-screen and to log file.
==============================================================================================================================
Note: Look for a popup window prompting for your O365 credentials. Account credentials must have the proper rights in O365.
Script is useful for determining if the user has a valid GUID. Accounts with invalid GUID cannot be converted to O365, without
first setting a valid GUID.
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
Added code to validate if the output path exists, creates if needed.
Modified file output.
==============================================================================================================================

#>

# Test if output path exists, creates if needed
$path = "C:\scriptsOutput"
if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Prompt the user to enter the username
$user = Read-Host "Enter the Username"

# Convert the username to uppercase
$user = $user.ToUpper()

# Define output file path
$label = Get-Date -Format 'yyyyMMddTHHmmss'
$file = "C:\scriptsOutput\$($user)_GUID_$($label).txt"
    
# Retrieve the ExchangeGUID of the specified mailbox and format it as a list
$guid = Get-Mailbox $user | Format-List ExchangeGUID 

# Display the retrieved GUID
$guid

# Output the the GUID to the file
$guid | Out-File -FilePath $file -Append

# Display a message indicating that the output has been saved to the file
Write-Output "Output saved to $file" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue