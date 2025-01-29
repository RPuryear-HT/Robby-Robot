<#


  /$$$$$$                                  /$$                     /$$$$$$$$        /$$       /$$                    
 /$$__  $$                                | $$                    | $$_____/       | $$      | $$                    
| $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$       | $$     /$$$$$$ | $$  /$$$$$$$  /$$$$$$   /$$$$$$ 
| $$       /$$__  $$ /$$__  $$ |____  $$|_  $$_/   /$$__  $$      | $$$$$ /$$__  $$| $$ /$$__  $$ /$$__  $$ /$$__  $$
| $$      | $$  \__/| $$$$$$$$  /$$$$$$$  | $$    | $$$$$$$$      | $$__/| $$  \ $$| $$| $$  | $$| $$$$$$$$| $$  \__/
| $$    $$| $$      | $$_____/ /$$__  $$  | $$ /$$| $$_____/      | $$   | $$  | $$| $$| $$  | $$| $$_____/| $$      
|  $$$$$$/| $$      |  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$$      | $$   |  $$$$$$/| $$|  $$$$$$$|  $$$$$$$| $$      
 \______/ |__/       \_______/ \_______/   \___/   \_______/      |__/    \______/ |__/ \_______/ \_______/|__/      
                          /$$$$$$              /$$            /$$$$$$   /$$$$$$  /$$                                 
                         /$$__  $$            | $$           /$$__  $$ /$$__  $$| $$                                 
                        | $$  \__/  /$$$$$$  /$$$$$$        | $$  \ $$| $$  \__/| $$                                 
                        |  $$$$$$  /$$__  $$|_  $$_/        | $$$$$$$$| $$      | $$                                 
                         \____  $$| $$$$$$$$  | $$          | $$__  $$| $$      | $$                                 
                         /$$  \ $$| $$_____/  | $$ /$$      | $$  | $$| $$    $$| $$                                 
                        |  $$$$$$/|  $$$$$$$  |  $$$$/      | $$  | $$|  $$$$$$/| $$$$$$$$                           
                         \______/  \_______/   \___/        |__/  |__/ \______/ |________/                           
                                                                                                                     
                                                                                                                     
Description: Create a network folder for an existing user and set ACL with modify rights.
==============================================================================================================================
Note: Account credentials must have file server admin permissions.
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
12/24/2024
Added changelog.
Added ASCII art.
Added code to display a completion message.
Added code to remove the values of any variables used. 
12/31/2024
Modified status messages.
Added notes to the code.

==============================================================================================================================

#>

# Prompt the user to enter the username
$username = Read-Host "Enter the username as <YouDomain>\<YourUser>"

# Prompt the user to enter the full network folder path
$folderpath = "Enter the network folder path to create as \\<YouFileServer>\<YourPath>"

# Check if the folder path exists, if not, create the directory
    if (-Not (Test-Path -Path $folderpath)) {
        New-Item "$folderpath" -itemtype Directory | Out-Null      
    }

# Get the current access control list for the folder
$acl = Get-Acl $folderpath

# Create a new access rule to grant the user modify permissions
$accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule($username, "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")

# Set the new access rule in the ACL
$acl.SetAccessRule($accessrule)

# Apply the updated ACL to the folder
Set-Acl $folderpath $acl

# Output a message indicating the ACL has been set for the user at the specified path
Write-Output "Set ACL at network path $folderpath. Modify rights applied for user $username" | Out-Host

# Clean up variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue