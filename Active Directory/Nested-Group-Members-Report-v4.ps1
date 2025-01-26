<#

       __    __                     __                    __         ______                                               
      |  \  |  \                   |  \                  |  \       /      \                                              
      | $$\ | $$ ______   _______ _| $$_    ______   ____| $$      |  $$$$$$\ ______   ______  __    __  ______           
      | $$$\| $$/      \ /       |   $$ \  /      \ /      $$      | $$ __\$$/      \ /      \|  \  |  \/      \          
      | $$$$\ $|  $$$$$$|  $$$$$$$\$$$$$$ |  $$$$$$|  $$$$$$$      | $$|    |  $$$$$$|  $$$$$$| $$  | $|  $$$$$$\         
      | $$\$$ $| $$    $$\$$    \  | $$ __| $$    $| $$  | $$      | $$ \$$$| $$   \$| $$  | $| $$  | $| $$  | $$         
      | $$ \$$$| $$$$$$$$_\$$$$$$\ | $$|  | $$$$$$$| $$__| $$      | $$__| $| $$     | $$__/ $| $$__/ $| $$__/ $$         
      | $$  \$$$\$$     |       $$  \$$  $$\$$     \\$$    $$       \$$    $| $$      \$$    $$\$$    $| $$    $$         
       \$$   \$$ \$$$$$$$\$$$$$$$    \$$$$  \$$$$$$$ \$$$$$$$        \$$$$$$ \$$       \$$$$$$  \$$$$$$| $$$$$$$          
 __       __                       __                                _______                           | $$        __     
|  \     /  \                     |  \                              |       \                          | $$       |  \    
| $$\   /  $$ ______  ______ ____ | $$____   ______   ______        | $$$$$$$\ ______   ______   ______ \$______ _| $$_   
| $$$\ /  $$$/      \|      \    \| $$    \ /      \ /      \       | $$__| $$/      \ /      \ /      \ /      |   $$ \  
| $$$$\  $$$|  $$$$$$| $$$$$$\$$$$| $$$$$$$|  $$$$$$|  $$$$$$\      | $$    $|  $$$$$$|  $$$$$$|  $$$$$$|  $$$$$$\$$$$$$  
| $$\$$ $$ $| $$    $| $$ | $$ | $| $$  | $| $$    $| $$   \$$      | $$$$$$$| $$    $| $$  | $| $$  | $| $$   \$$| $$ __ 
| $$ \$$$| $| $$$$$$$| $$ | $$ | $| $$__/ $| $$$$$$$| $$            | $$  | $| $$$$$$$| $$__/ $| $$__/ $| $$      | $$|  \
| $$  \$ | $$\$$     | $$ | $$ | $| $$    $$\$$     | $$            | $$  | $$\$$     | $$    $$\$$    $| $$       \$$  $$
 \$$      \$$ \$$$$$$$\$$  \$$  \$$\$$$$$$$  \$$$$$$$\$$             \$$   \$$ \$$$$$$| $$$$$$$  \$$$$$$ \$$        \$$$$ 
                                                                                      | $$                                
                                                                                      | $$                                
                                                                                       \$$                                


Description: Generate a report of the target AD group's members along with nested groups and their members.
==============================================================================================================================
Note: Exports to "C:\scripts\<Group Name>_nested_members_report_...csv"
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
12/27/2024
Added code to export the report.
Added changelog.
Added ASCII art.
1/6/2025
Added code to remove the variables used.
Added notes to the code.
Added special characters and edited status messages.
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

# Measure the time taken to run the script
$runtime = Measure-Command {

    # Prompt the user to enter the group name
    $group = Read-Host "Enter the group name"

    # Display a message to inform the user that nested group membership info is being gathered
    Write-Output "Gathering nested group membership info... This may take some time..." | Out-Host

    # Retrieve the members of the specified group
    $groupmembers = Get-ADGroupMember -Identity $group

    # Initialize an empty array to store the report data
    $report = @()

    # Loop through each member in the group
    foreach ($member in $groupmembers) {
        if ($member.objectClass -eq "group") {
            # If the member is a nested group, retrieve the nested group object
            $nestedgroup = Get-ADGroup -Identity $member.Name
            Write-Output "Nested group: $($nestedgroup.Name)" | Out-Host
        
            # Retrieve the members of the nested group
            $nestedgroupmembers = Get-ADGroupMember -Identity $nestedgroup.Name
            foreach ($nestedgroupmember in $nestedgroupmembers) {
                # Retrieve the user object from the nested group
                $user = Get-ADUser -Identity $nestedgroupmember.Name
                Write-Output "  User: $($user.Name)" | Out-Host
            
                # Add the user details to the report array
                $report += [PSCustomObject]@{
                    MainGroupName   = $group
                    NestedGroupName = $nestedgroup.Name
                    UserName        = $user.Name
                }
            }
        }
        else {
            # If the member is a user, retrieve the user object
            $user = Get-ADUser -Identity $member.Name
            Write-Output "User: $($user.Name)" | Out-Host
        
            # Add the user details to the report array
            $report += [PSCustomObject]@{
                MainGroupName   = $group
                NestedGroupName = ""
                UserName        = $user.Name
            }
        }
    }

    # Generate a timestamp label for the report file
    $label = Get-Date -Format 'yyyyMMddTHHmmss'

    # Define the path for the CSV report file
    $csvpath = "C:\scriptsOutput\$($group)_Nested_Members_Report_$label.csv"

    # Output nested member list to the terminal
    $report | Format-Table

    # Export the report array to a CSV file without type information
    $report | Export-Csv -Path $csvpath -NoTypeInformation

    # Output a message indicating the report has been exported
    Write-Output "Report exported to $csvpath" | Out-Host
}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue