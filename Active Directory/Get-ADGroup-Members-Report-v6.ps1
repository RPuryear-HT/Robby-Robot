<#

                                      ______                                                                                         
                                     /      \                                                                                        
                                    /$$$$$$  |  ______   ______   __    __   ______                                                  
                                    $$ | _$$/  /      \ /      \ /  |  /  | /      \                                                 
                                    $$ |/    |/$$$$$$  /$$$$$$  |$$ |  $$ |/$$$$$$  |                                                
                                    $$ |$$$$ |$$ |  $$/$$ |  $$ |$$ |  $$ |$$ |  $$ |                                                
                                    $$ \__$$ |$$ |     $$ \__$$ |$$ \__$$ |$$ |__$$ |                                                
                                    $$    $$/ $$ |     $$    $$/ $$    $$/ $$    $$/                                                 
                                     $$$$$$/  $$/       $$$$$$/   $$$$$$/  $$$$$$$/                                                  
                                                                           $$ |                                                      
                                                                           $$ |                                                      
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

Description: Generate a report of an AD group's memberships. 
==============================================================================================================================
Note: Outputs to C:\scriptsOutput\Group_Members_**.csv.
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
2/24/2023
Created original script.
12/24/2024
Added changelog.
Added ASCII art.
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
==============================================================================================================================

#>

# Test if output path exists, creates if needed
$path = "C:\scriptsOutput"
if (-not (Test-Path -Path $path)) {
    New-Item -ItemType Directory -Path $path | Out-Null
}


# Prompt the user to enter the group name
$groupname = Read-Host "Enter the group name"

# Measure the time taken to run the script
$runtime = Measure-Command {

# Generate a timestamp label for the report file
$label = Get-Date -Format 'yyyyMMddTHHmmss'

Write-Output "Gathering $groupname group member info... This may take some time..." | Out-Host

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

# Output a message indicating the report has been exported
Write-Output "Report exported to C:\scriptsOutput\Group_Members_$label.csv" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue