<#

  ______               __            __    __              __             ______     __                  __               
 /      \             |  \          |  \  |  \            |  \           /      \   |  \                |  \              
|  $$$$$$\  ______   _| $$_         | $$\ | $$  ______   _| $$_         |  $$$$$$\ _| $$_     ______   _| $$_     _______ 
| $$ __\$$ /      \ |   $$ \        | $$$\| $$ /      \ |   $$ \        | $$___\$$|   $$ \   |      \ |   $$ \   /       \
| $$|    \|  $$$$$$\ \$$$$$$        | $$$$\ $$|  $$$$$$\ \$$$$$$         \$$    \  \$$$$$$    \$$$$$$\ \$$$$$$  |  $$$$$$$
| $$ \$$$$| $$    $$  | $$ __       | $$\$$ $$| $$    $$  | $$ __        _\$$$$$$\  | $$ __  /      $$  | $$ __  \$$    \ 
| $$__| $$| $$$$$$$$  | $$|  \      | $$ \$$$$| $$$$$$$$  | $$|  \      |  \__| $$  | $$|  \|  $$$$$$$  | $$|  \ _\$$$$$$\
 \$$    $$ \$$     \   \$$  $$      | $$  \$$$ \$$     \   \$$  $$       \$$    $$   \$$  $$ \$$    $$   \$$  $$|       $$
  \$$$$$$   \$$$$$$$    \$$$$        \$$   \$$  \$$$$$$$    \$$$$         \$$$$$$     \$$$$   \$$$$$$$    \$$$$  \$$$$$$$ 
                                                                                                                          
                                                                                                                          
Description: Get network diagnostic information on a target Windows machine.
==============================================================================================================================
Note: Account credentials must have local admin rights.
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
2/25/2023
Created original script
12/30/2024
Added changelog.
Added ASCII art.
Added code to remove the variables used.
12/31/2024
Added notes to the code.
Added special characters and edited completion message.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Prompt the user to enter the computer name
$computername = Read-Host "Enter the computername"

# Execute the following commands on the specified remote computer
Invoke-Command -ComputerName $computername {
    # Retrieve and display the network IP addresses in a table format
    Get-NetIPAddress | Format-Table -AutoSize
    
    # Retrieve and display the network adapters in a table format
    Get-NetAdapter | Format-Table -AutoSize
    
    # Retrieve and display the network adapter statistics in a table format
    Get-NetAdapterStatistics | Format-Table -AutoSize
    
    # Retrieve and display the network routes in a table format
    Get-NetRoute | Format-Table -AutoSize
}

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue