<########### EDIT THIS FIRST ############# EDIT THIS FIRST ############# EDIT THIS FIRST ############# EDIT THIS FIRST #############
# Requires PowerShell 7. Add all AD accounts to target AD group. This will take seconds up to minutes to run depending on the user count. 
Please wait for end message. 
#>

# Import the Active Directory module
Import-Module ActiveDirectory

# Set the error action preference to 'Stop', which will halt script execution if any error occurs
$ErrorActionPreference = 'Stop'

# Retrieve the Active Directory user(s) whose SamAccountName matches the specified target
Get-ADUser -Filter 'SamAccountName -like "<TargetAccount>"' | ForEach-Object -ThrottleLimit 5 -Parallel {
    # For each retrieved user, add them to the specified Active Directory group
    Add-ADGroupMember -Identity "<TargetGroup>" -Members $_.SamAccountName
}

# Output a message to the console indicating that all users were successfully added to the group, with the text in magenta
Write-Host "All users were added to group successfully" -foregroundcolor Magenta

# Created by Robert Puryear # Updated 3/2/2023
