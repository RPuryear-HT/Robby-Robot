<#

 __       __            __    __      __         ______                                         
/  \     /  |          /  |  /  |    /  |       /      \                                        
$$  \   /$$ | __    __ $$ | _$$ |_   $$/       /$$$$$$  |  ______   ______   __    __   ______  
$$$  \ /$$$ |/  |  /  |$$ |/ $$   |  /  |      $$ | _$$/  /      \ /      \ /  |  /  | /      \ 
$$$$  /$$$$ |$$ |  $$ |$$ |$$$$$$/   $$ |      $$ |/    |/$$$$$$  /$$$$$$  |$$ |  $$ |/$$$$$$  |
$$ $$ $$/$$ |$$ |  $$ |$$ |  $$ | __ $$ |      $$ |$$$$ |$$ |  $$/$$ |  $$ |$$ |  $$ |$$ |  $$ |
$$ |$$$/ $$ |$$ \__$$ |$$ |  $$ |/  |$$ |      $$ \__$$ |$$ |     $$ \__$$ |$$ \__$$ |$$ |__$$ |
$$ | $/  $$ |$$    $$/ $$ |  $$  $$/ $$ |      $$    $$/ $$ |     $$    $$/ $$    $$/ $$    $$/ 
$$/      $$/  $$$$$$/  $$/    $$$$/  $$/        $$$$$$/  $$/       $$$$$$/   $$$$$$/  $$$$$$$/  
                                                                                      $$ |      
                                                                                      $$ |      
                                                                                      $$/       
 __       __                          __                                  _______                                             __     
/  \     /  |                        /  |                                /       \                                           /  |    
$$  \   /$$ |  ______   _____  ____  $$ |____    ______    ______        $$$$$$$  |  ______    ______    ______    ______   _$$ |_   
$$$  \ /$$$ | /      \ /     \/    \ $$      \  /      \  /      \       $$ |__$$ | /      \  /      \  /      \  /      \ / $$   |  
$$$$  /$$$$ |/$$$$$$  |$$$$$$ $$$$  |$$$$$$$  |/$$$$$$  |/$$$$$$  |      $$    $$< /$$$$$$  |/$$$$$$  |/$$$$$$  |/$$$$$$  |$$$$$$/   
$$ $$ $$/$$ |$$    $$ |$$ | $$ | $$ |$$ |  $$ |$$    $$ |$$ |  $$/       $$$$$$$  |$$    $$ |$$ |  $$ |$$ |  $$ |$$ |  $$/   $$ | __ 
$$ |$$$/ $$ |$$$$$$$$/ $$ | $$ | $$ |$$ |__$$ |$$$$$$$$/ $$ |            $$ |  $$ |$$$$$$$$/ $$ |__$$ |$$ \__$$ |$$ |        $$ |/  |
$$ | $/  $$ |$$       |$$ | $$ | $$ |$$    $$/ $$       |$$ |            $$ |  $$ |$$       |$$    $$/ $$    $$/ $$ |        $$  $$/ 
$$/      $$/  $$$$$$$/ $$/  $$/  $$/ $$$$$$$/   $$$$$$$/ $$/             $$/   $$/  $$$$$$$/ $$$$$$$/   $$$$$$/  $$/          $$$$/  
                                                                                             $$ |                                    
                                                                                             $$ |                                    
                                                                                             $$/                                     

Description: Generate a report of multiple AD groups' memberships. 
==============================================================================================================================
Note: Must have a list of groups located at C:\scripts\groups.txt. This will take seconds up to minutes to run depending on 
the membership count. Please wait for script completion messages. Use at your own risk.
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
9/6/2023
Created original script.
8/14/2024
Added code to create a custom object and export a report to CSV.
12/24/2024
Added changelog.
Added ASCII art.
12/24/2024
Added code to remove the variables used.
12/31/2024
Added notes to the code.
Added special characters and edited status messages.
1/6/2025
Added code execution timer. Formatted run time output message.
Changed output path to C:\scriptsOutput.
Added code to test if the output path exists, creates if needed.
1/25/2025
Removed special characters to increase compatibility.
1/28/2025
Updated description.
==============================================================================================================================

#>

# Test if output path exists, creates if needed
$path = "C:\scriptsOutput"
if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}

# Measure the time taken to run the script
$runtime = Measure-Command {

# Generate a timestamp label for the report file
$label = Get-Date -Format 'yyyyMMddTHHmmss'

# Read the list of group names from a file
$groupnames = Get-Content C:\scripts\groups.txt

# Display a message to inform the user that group member info is being gathered
Write-Output "Gathering group member info... This may take some time..." | Out-Host

# Loop through each group name in the list
foreach ($groupname in $groupnames) {
    # Retrieve the members of the group recursively and sort them by name
    $members = Get-ADGroupMember -Identity $groupname -Recursive | Select-Object -ExpandProperty Name | Sort-Object
    
    # Loop through each member in the group
    foreach ($member in $members) {
        # Retrieve the user object from Active Directory with additional properties
        $user = Get-ADUser -Identity $member -Properties SamAccountName, DisplayName
        
        # Create a custom object with the group and user details and export it to a CSV file
        [PSCustomObject]@{
            GroupName      = $groupname
            SamAccountName = $user.SamAccountName
            DisplayName    = $user.DisplayName
        } | Export-Csv -Path C:\scriptsOutput\Group_Members_$label.csv -NoTypeInformation -Append
    }
}

# Output a message indicating the report has been exported
Write-Output "Report exported to C:\scriptsOutput\Group_Members_$label.csv" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
