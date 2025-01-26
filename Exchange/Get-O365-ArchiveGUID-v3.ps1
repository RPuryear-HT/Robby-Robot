<#


                 $$$$$$\            $$\            $$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$\                    
                $$  __$$\           $$ |          $$  __$$\ $$ ___$$\ $$  __$$\ $$  ____|                   
                $$ /  \__| $$$$$$\$$$$$$\         $$ /  $$ |\_/   $$ |$$ /  \__|$$ |                        
                $$ |$$$$\ $$  __$$\_$$  _|        $$ |  $$ |  $$$$$ / $$$$$$$\  $$$$$$$\                    
                $$ |\_$$ |$$$$$$$$ |$$ |          $$ |  $$ |  \___$$\ $$  __$$\ \_____$$\                   
                $$ |  $$ |$$   ____|$$ |$$\       $$ |  $$ |$$\   $$ |$$ /  $$ |$$\   $$ |                  
                \$$$$$$  |\$$$$$$$\ \$$$$  |       $$$$$$  |\$$$$$$  | $$$$$$  |\$$$$$$  |                  
                 \______/  \_______| \____/        \______/  \______/  \______/  \______/                   
 $$$$$$\                      $$\       $$\                            $$$$$$\  $$\   $$\ $$$$$$\ $$$$$$$\  
$$  __$$\                     $$ |      \__|                          $$  __$$\ $$ |  $$ |\_$$  _|$$  __$$\ 
$$ /  $$ | $$$$$$\   $$$$$$$\ $$$$$$$\  $$\$$\    $$\  $$$$$$\        $$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |
$$$$$$$$ |$$  __$$\ $$  _____|$$  __$$\ $$ \$$\  $$  |$$  __$$\       $$ |$$$$\ $$ |  $$ |  $$ |  $$ |  $$ |
$$  __$$ |$$ |  \__|$$ /      $$ |  $$ |$$ |\$$\$$  / $$$$$$$$ |      $$ |\_$$ |$$ |  $$ |  $$ |  $$ |  $$ |
$$ |  $$ |$$ |      $$ |      $$ |  $$ |$$ | \$$$  /  $$   ____|      $$ |  $$ |$$ |  $$ |  $$ |  $$ |  $$ |
$$ |  $$ |$$ |      \$$$$$$$\ $$ |  $$ |$$ |  \$  /   \$$$$$$$\       \$$$$$$  |\$$$$$$  |$$$$$$\ $$$$$$$  |
\__|  \__|\__|       \_______|\__|  \__|\__|   \_/     \_______|       \______/  \______/ \______|\_______/ 
                                                                                                            
                                                                                                            
Description: Checks whether the ArchiveGuid property of the O365 mailbox is set and outputs the value on-screen and to log file.
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
6/15/2023
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

# Retrieve the ArchiveGUID of the specified mailbox and format it as a list
$archiveguid = Get-Mailbox -Identity $user | Format-List *archive*

# Display the retrieved GUID
$archiveguid

# Output the the GUID to the file
$archiveguid | Out-File -FilePath $file -Append

# Display a message indicating that the output has been saved to the file
Write-Output "Output saved to $file" | Out-Host