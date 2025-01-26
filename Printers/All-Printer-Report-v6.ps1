<#

 _______           __              __                                _______                                             __     
/       \         /  |            /  |                              /       \                                           /  |    
$$$$$$$  |______  $$/  _______   _$$ |_     ______    ______        $$$$$$$  |  ______    ______    ______    ______   _$$ |_   
$$ |__$$ /      \ /  |/       \ / $$   |   /      \  /      \       $$ |__$$ | /      \  /      \  /      \  /      \ / $$   |  
$$    $$/$$$$$$  |$$ |$$$$$$$  |$$$$$$/   /$$$$$$  |/$$$$$$  |      $$    $$< /$$$$$$  |/$$$$$$  |/$$$$$$  |/$$$$$$  |$$$$$$/   
$$$$$$$/$$ |  $$/ $$ |$$ |  $$ |  $$ | __ $$    $$ |$$ |  $$/       $$$$$$$  |$$    $$ |$$ |  $$ |$$ |  $$ |$$ |  $$/   $$ | __ 
$$ |    $$ |      $$ |$$ |  $$ |  $$ |/  |$$$$$$$$/ $$ |            $$ |  $$ |$$$$$$$$/ $$ |__$$ |$$ \__$$ |$$ |        $$ |/  |
$$ |    $$ |      $$ |$$ |  $$ |  $$  $$/ $$       |$$ |            $$ |  $$ |$$       |$$    $$/ $$    $$/ $$ |        $$  $$/ 
$$/     $$/       $$/ $$/   $$/    $$$$/   $$$$$$$/ $$/             $$/   $$/  $$$$$$$/ $$$$$$$/   $$$$$$/  $$/          $$$$/  
                                                                                        $$ |                                    
                                                                                        $$ |                                    
                                                                                        $$/                                                                                                                                                                                                                                                                                                                 
                                                                                                                
Description: Find all printers in Active Directory.
==============================================================================================================================
Note: Exports to CSV located in C:\scripts\all_printers_....csv.
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
12/18/2024
Created original script.
12/24/2024
Added changelog.
Added ASCII art.
12/31/2024
Modified completion message. Added special characters.
Added code to output to the terminal.
Added code to remove the server name from the output.
1/6/2025
Changed output path to C:\scriptsOutput.
1/7/2025
Edited CSV output.
1/20/2025
Added code execution timer.
1/25/2025
Removed special characters to increase compatibility.
==============================================================================================================================

#>

# Import the Active Directory module to use AD cmdlets
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

    Write-Output "Gathering printer info.." | Out-Host

    # Retrieve all printer objects from Active Directory with their Name and Location properties
    $allprinters = Get-ADObject -Filter 'objectClass -eq "printQueue"' -Property Name, Location | Select-Object Name, Location

    # Initialize an empty array to store the output
    $output = @()

    # Define the path where the script will save the CSV file
    $path = "C:\scriptsOutput"

    # Check if the path exists, if not, create the directory
    if (-not (Test-Path -Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }

    # Loop through each printer object
    foreach ($printer in $allprinters) {
        # Set the printer name variable
        $name = $printer.Name
    
        # Add the printer name and location to the output array as a custom object
        $output += [PSCustomObject]@{
            Name     = $name
            Location = $printer.Location
        }
    }

    # Generate a timestamp label for the CSV file
    $label = Get-Date -Format 'yyyyMMddTHHmmss'

    # Define the full path for the CSV file
    $csvpath = "C:\scriptsOutput\All_Printers_$label.csv"

    # Display the output in a table format
    $output | Format-Table

    # Export the output to a CSV file
    $output | Export-Csv -Path "$csvpath" -NoTypeInformation

    # Output a success message with the CSV file path
    Write-Output "Report exported to $csvpath" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue
