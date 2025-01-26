<#

  ______   ______   ______  _______         __       __   __     __                    __     __                                
 /      \ /      \ /      \|       \       |  \     |  \ |  \   |  \                  |  \   |  \                               
|  $$$$$$|  $$$$$$|  $$$$$$| $$$$$$$       | $$      \$$_| $$_   \$$ ______   ______ _| $$_   \$$ ______  _______               
| $$  | $$\$$__| $| $$___\$| $$____        | $$     |  |   $$ \ |  \/      \ |      |   $$ \ |  \/      \|       \              
| $$  | $$ |     $| $$    \| $$    \       | $$     | $$\$$$$$$ | $|  $$$$$$\ \$$$$$$\$$$$$$ | $|  $$$$$$| $$$$$$$\             
| $$  | $$__\$$$$$| $$$$$$$\\$$$$$$$\      | $$     | $$ | $$ __| $| $$  | $$/      $$| $$ __| $| $$  | $| $$  | $$             
| $$__/ $|  \__| $| $$__/ $|  \__| $$      | $$_____| $$ | $$|  | $| $$__| $|  $$$$$$$| $$|  | $| $$__/ $| $$  | $$             
 \$$    $$\$$    $$\$$    $$\$$    $$      | $$     | $$  \$$  $| $$\$$    $$\$$    $$ \$$  $| $$\$$    $| $$  | $$             
  \$$$$$$  \$$$$$$  \$$$$$$  \$$$$$$        \$$$$$$$$\$$   \$$$$ \$$_\$$$$$$$ \$$$$$$$  \$$$$ \$$ \$$$$$$ \$$   \$$             
                                                                   |  \__| $$                                                   
                                                                    \$$    $$                                                   
 __    __          __       __         ______  __                    \$$$$$_______                                       __     
|  \  |  \        |  \     |  \       /      \|  \                        |       \                                     |  \    
| $$  | $$ ______ | $$ ____| $$      |  $$$$$$\\$$________  ______        | $$$$$$$\ ______   ______   ______   ______ _| $$_   
| $$__| $$/      \| $$/      $$      | $$___\$|  |        \/      \       | $$__| $$/      \ /      \ /      \ /      |   $$ \  
| $$    $|  $$$$$$| $|  $$$$$$$       \$$    \| $$\$$$$$$$|  $$$$$$\      | $$    $|  $$$$$$|  $$$$$$|  $$$$$$|  $$$$$$\$$$$$$  
| $$$$$$$| $$  | $| $| $$  | $$       _\$$$$$$| $$ /    $$| $$    $$      | $$$$$$$| $$    $| $$  | $| $$  | $| $$   \$$| $$ __ 
| $$  | $| $$__/ $| $| $$__| $$      |  \__| $| $$/  $$$$_| $$$$$$$$      | $$  | $| $$$$$$$| $$__/ $| $$__/ $| $$      | $$|  \
| $$  | $$\$$    $| $$\$$    $$       \$$    $| $|  $$    \\$$     \      | $$  | $$\$$     | $$    $$\$$    $| $$       \$$  $$
 \$$   \$$ \$$$$$$ \$$ \$$$$$$$        \$$$$$$ \$$\$$$$$$$$ \$$$$$$$       \$$   \$$ \$$$$$$| $$$$$$$  \$$$$$$ \$$        \$$$$ 
                                                                                            | $$                                
                                                                                            | $$                                
                                                                                             \$$                                

                                                                                             
Description: Generate a report of folder size data for all O365 litigation hold users.
==============================================================================================================================
Note: Look for a popup window prompting for your O365 credentials. Account credentials must have the proper rights in O365.
Script is useful for determining if the lit hold user is close to or at the 100 GB limit for deleted items.
==============================================================================================================================
Reference article(s): 
https://answers.microsoft.com/en-us/outlook_com/forum/all/remote-server-returned-554-520/1ab850a3-339f-4504-a02e-a5de2bbe3a6f
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/6/2025
==============================================================================================================================

   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
12/13/2023
Created original script.
7/8/2024
Added reference articles.
1/6/2025
Added changelog.
Added ASCII art.
Added code to remove the variables used.
Added notes to the code.
Added special characters and edited status messages.
Added code execution timer. Formatted output message.
Added code to check if the target path for CSV output exists and creates the path, if needed. 
1/8/2025
Modified code to use .where instead of Where-Object to improve performance.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Test if output path exists, creates if needed
$path = "C:\scriptsOutput"
if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}

Write-Output "Waiting for authentication... Please see browser popup..." | Out-Host

# Import Exchange Online Management modules
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline -ShowBanner:$false

# Measure the time taken to run the script
$runtime = Measure-Command {

    # Output message that the script started
    Write-Output "Gathering folder stats from O365 litigation hold mailboxes... This will take some time.." | Out-Host
    
    # Generate a timestamp label for the report file
    $label = Get-Date -Format 'yyyyMMddTHHmmss'

    # Define the path for the CSV report file
    $csvpath = "C:\scriptsOutput\O365_Litigation_Stats_Report_$label.csv"

    # Get all mailboxes O365 litigation hold mailboxes
    $mailboxes = (Get-Mailbox -ResultSize Unlimited).where({ $_.LitigationHoldEnabled -eq $true })

    # Initialize an array to hold the results
    $results = @()

    # Loop through each mailbox and get the stats 
    foreach ($mailbox in $mailboxes) { 
        $mailboxstats = Get-MailboxStatistics $mailbox
        $results += [PSCustomObject]@{
            DisplayName          = $mailboxstats.DisplayName
            TotalItemSize        = $mailboxstats.TotalItemSize
            TotalDeletedItemSize = $mailboxstats.TotalDeletedItemSize
        }
    } 

    # Export the results to CSV
    $results | Export-Csv -Path $csvpath -NoTypeInformation

    # Output a message indicating the report has been exported
    Write-Output "Report exported to $csvpath" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
Get-Variable | Where-Object { $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" } | Remove-Variable -ErrorAction SilentlyContinue