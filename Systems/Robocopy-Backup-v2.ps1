<#  


 /$$$$$$$            /$$                                                        
| $$__  $$          | $$                                                        
| $$  \ $$  /$$$$$$ | $$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$  /$$   /$$
| $$$$$$$/ /$$__  $$| $$__  $$ /$$__  $$ /$$_____/ /$$__  $$ /$$__  $$| $$  | $$
| $$__  $$| $$  \ $$| $$  \ $$| $$  \ $$| $$      | $$  \ $$| $$  \ $$| $$  | $$
| $$  \ $$| $$  | $$| $$  | $$| $$  | $$| $$      | $$  | $$| $$  | $$| $$  | $$
| $$  | $$|  $$$$$$/| $$$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$/| $$$$$$$/|  $$$$$$$
|__/  |__/ \______/ |_______/  \______/  \_______/ \______/ | $$____/  \____  $$
                                                            | $$       /$$  | $$
             /$$$$$$$                      /$$              | $$      |  $$$$$$/
            | $$__  $$                    | $$              |__/       \______/ 
            | $$  \ $$  /$$$$$$   /$$$$$$$| $$   /$$ /$$   /$$  /$$$$$$         
            | $$$$$$$  |____  $$ /$$_____/| $$  /$$/| $$  | $$ /$$__  $$        
            | $$__  $$  /$$$$$$$| $$      | $$$$$$/ | $$  | $$| $$  \ $$        
            | $$  \ $$ /$$__  $$| $$      | $$_  $$ | $$  | $$| $$  | $$        
            | $$$$$$$/|  $$$$$$$|  $$$$$$$| $$ \  $$|  $$$$$$/| $$$$$$$/        
            |_______/  \_______/ \_______/|__/  \__/ \______/ | $$____/         
                                                              | $$              
                                                              | $$              
                                                              |__/              


Description: Copy/backup files from source to destination.
==============================================================================================================================
Note: User must have proper rights to the source/destination. This will take seconds up to several hours to run depending on 
the data, network speed, etc. Please wait for script completion message. Use at your own risk.
=============================================================================================================================
Author:  Robert Puryear
==============================================================================================================================
Last Revision: 1/29/2025
============================================================================================================================== 
   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/                                 
==============================================================================================================================
1/14/2025
Created original script, based on previous work.
Added code to display status messages.
Disabled file copy status messages to improve performance.
Formatted script.
Added code execution timer.
1/29/2025
Edited code to use robocopy instead of copy-item.
Removed /copyall option as it is widely unsupported by most domains.
Added notes to code.
==============================================================================================================================

#>

# Set the source for the file copy
$source = Read-Host "Enter the full path to your source directory"

# Set the destination for the file copy
$destination = Read-Host "Enter the full path to your destination directory"

# Measure the time taken to run the script
$runtime = Measure-Command {
    
    # Check if the path exists, if not, create the directory
    if (-not (Test-Path -Path $destination)) {
        New-Item -ItemType Directory -Path $destination | Out-Null
    }

    # Display a message that the file copy started
    Write-Output "Backing up files/folders. This will take some time..." | Out-Host

    # Start robocopy from the source to the destination. Include subfolders and files in restartable mode. Retry 3 times on failed copies and wait 5 seconds between retries.
    robocopy "$source" "$destination" /E /Z /R:3 /W:5

    # Create the label to show date/time in completion message
    $timecompleted = Get-Date

    # Display a message that the file copy completed
    Write-Output "Backup Process Completed $timecompleted" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host