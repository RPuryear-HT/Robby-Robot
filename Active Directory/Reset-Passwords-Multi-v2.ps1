<#

 _______                              __            _______                                                                 __          
|       \                            |  \          |       \                                                               |  \         
| $$$$$$$\ ______   _______  ______ _| $$_         | $$$$$$$\______   _______  _______ __   __   __  ______   ______   ____| $$ _______ 
| $$__| $$/      \ /       \/      |   $$ \        | $$__/ $|      \ /       \/       |  \ |  \ |  \/      \ /      \ /      $$/       \
| $$    $|  $$$$$$|  $$$$$$|  $$$$$$\$$$$$$        | $$    $$\$$$$$$|  $$$$$$|  $$$$$$| $$ | $$ | $|  $$$$$$|  $$$$$$|  $$$$$$|  $$$$$$$
| $$$$$$$| $$    $$\$$    \| $$    $$| $$ __       | $$$$$$$/      $$\$$    \ \$$    \| $$ | $$ | $| $$  | $| $$   \$| $$  | $$\$$    \ 
| $$  | $| $$$$$$$$_\$$$$$$| $$$$$$$$| $$|  \      | $$    |  $$$$$$$_\$$$$$$\_\$$$$$$| $$_/ $$_/ $| $$__/ $| $$     | $$__| $$_\$$$$$$\
| $$  | $$\$$     |       $$\$$     \ \$$  $$      | $$     \$$    $|       $|       $$\$$   $$   $$\$$    $| $$      \$$    $|       $$
 \$$   \$$ \$$$$$$$\$$$$$$$  \$$$$$$$  \$$$$        \$$      \$$$$$$$\$$$$$$$ \$$$$$$$  \$$$$$\$$$$  \$$$$$$ \$$       \$$$$$$$\$$$$$$$ 
                                                                                                                                        
                                                                                                                                        
                                                                                                                                        
Description: Resets multiple AD account's passwords. 
==============================================================================================================================
Note: Must have a user list located at C:\scripts\resets.txt. Must have a password file here: C:\scripts\passfile.txt
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
4/15/2024
Created original script.
12/24/2024
Added changelog.
Added ASCII art.
12/31/2024
Added notes to the code.
Added special characters and edited completion message.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Read the list of usernames from a file
$usernames = Get-Content C:\scripts\resets.txt

# Convert the usernames to uppercase
$usernames = $usernames.ToUpper()

# Read the password from a file
$password = Get-Content C:\scripts\passfile.txt

# Set the error action preference to continue on errors
$ErrorActionPreference = "continue"

# Loop through each username in the list and reset their password
foreach ($username in $usernames) {
    Set-ADAccountPassword -Identity $username -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force)
}

# Count the total number of usernames processed
$total = $usernames.count

# Display the list of usernames in a table format
$usernames | Format-Table

# Output a message indicating the number of passwords reset successfully
Write-Output "Passwords reset for $total users successfully" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the resets.txt file
Clear-Content C:\scripts\resets.txt
