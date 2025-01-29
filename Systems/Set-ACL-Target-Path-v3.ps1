<#

  /$$$$$$              /$$            /$$$$$$   /$$$$$$  /$$             /$$$$$$$$                                       /$$    
 /$$__  $$            | $$           /$$__  $$ /$$__  $$| $$            |__  $$__/                                      | $$    
| $$  \__/  /$$$$$$  /$$$$$$        | $$  \ $$| $$  \__/| $$               | $$  /$$$$$$   /$$$$$$  /$$$$$$   /$$$$$$  /$$$$$$  
|  $$$$$$  /$$__  $$|_  $$_/        | $$$$$$$$| $$      | $$               | $$ |____  $$ /$$__  $$/$$__  $$ /$$__  $$|_  $$_/  
 \____  $$| $$$$$$$$  | $$          | $$__  $$| $$      | $$               | $$  /$$$$$$$| $$  \__/ $$  \ $$| $$$$$$$$  | $$    
 /$$  \ $$| $$_____/  | $$ /$$      | $$  | $$| $$    $$| $$               | $$ /$$__  $$| $$     | $$  | $$| $$_____/  | $$ /$$
|  $$$$$$/|  $$$$$$$  |  $$$$/      | $$  | $$|  $$$$$$/| $$$$$$$$         | $$|  $$$$$$$| $$     |  $$$$$$$|  $$$$$$$  |  $$$$/
 \______/  \_______/   \___/        |__/  |__/ \______/ |________/         |__/ \_______/|__/      \____  $$ \_______/   \___/  
                                                                                                   /$$  \ $$                    
                                                                                                  |  $$$$$$/                    
                                                                                                   \______/                                                                                                                              

Description: Set ACL permissions for a group or user to the specified target path.
==============================================================================================================================
Note: Account credentials must have file server admin permissions. Most users are either Modify or Read & Execute. Use at your
own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Updated: 1/28/2025
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
1/17/2025
Added code to set permissions as 'Modify' or 'ReadAndExecute' access levels.
Added code to validate input.
1/28/2025
Added selection of any permissions level, rather than 'Modify' or 'ReadAndExecute' only.
Added code to prompt the user for a permissions level, with color-coding for easier identification. 
==============================================================================================================================

#>

do {
  # Prompt the user to choose the level of permissions
  Write-Host "Permissions Level Selection - Please Enter the Menu Selection Number, then Press Enter. Most users are either Modify or Read & Execute.
  "`n -ForegroundColor DarkYellow
  Write-Host "1. Full Control: Grants all permissions, including the ability to change permissions and take ownership of the file or directory." -ForegroundColor Red
  Write-Host "2. Modify: Combines read, write, and execute permissions, allowing the user to read, modify, and execute the contents." -ForegroundColor Red
  Write-Host "3. Read & Execute: Combines read and execute permissions, allowing the user to read and execute the contents." -ForegroundColor Yellow
  Write-Host "4. List Folder Contents: Allows the user to view the names of files and subdirectories within a directory." -ForegroundColor Green
  Write-Host "5. Read: Allows the user to read the contents of a file or directory." -ForegroundColor Green
  Write-Host "6. Write: Allows the user to modify the contents of a file or directory." -ForegroundColor Yellow
  $type = Read-Host
  # Check if the choice matches the required pattern
  if ($type -match "^(1|2|3|4|5|6)$") {
    switch ($type) {
      "1" { $type = "FullControl" }
      "2" { $type = "Modify" }    
      "3" { $type = "ReadAndExecute" }
      "4" { $type = "ListDirectory" }    
      "5" { $type = "Read" }
      "6" { $type = "Write" }
    }
    $valid = $true  # Set the valid flag to true if the choice is valid
  }
  else { # Display an error message and define the allowed characters
    Write-Host "Selection is invalid. It must be a number range of 1-6." -ForegroundColor Red
    $valid = $false  # Set the valid flag to false if the choice is invalid
  }
} while (-not $valid)  # Repeat the loop until a valid choice is entered

# Prompt the user to enter the group or user name
$object = Read-Host "Enter the group or user name"

# Convert the entered name to uppercase
$object = $object.ToUpper()

# Prompt the user to enter the full path of the folder
$folderpath = Read-Host "Enter the full path"

# Construct the full group or user name with the domain
$group = "<YourDomain>\$object"

# Retrieve the current ACL (Access Control List) for the specified folder
$acl = Get-Acl $folderpath

# Create a new access rule for the group or user with specified permissions
$accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule($group, "$type", "ContainerInherit,ObjectInherit", "None", "Allow")

# Add the new access rule to the ACL
$acl.SetAccessRule($accessrule)

# Apply the updated ACL to the folder
Set-Acl $folderpath $acl
