<########### EDIT THIS FIRST ############# EDIT THIS FIRST ############# EDIT THIS FIRST ############# EDIT THIS FIRST #############
# Requires PowerShell 7. Add all AD accounts to target AD group. This will take seconds up to minutes to run depending on the user count. 
Please wait for end message. 
#>
Import-Module ActiveDirectory
$ErrorActionPreference = 'Stop'
Get-ADUser -Filter 'SamAccountName -like "<TargetAccount>"' | ForEach-Object -ThrottleLimit 5 -Parallel {
    Add-ADGroupMember -Identity "<TargetGroup>" -Members $_.SamAccountName
}
Write-Host "All users were added to group successfully" -foregroundcolor Magenta
# Created by Robert Puryear # Updated 3/2/2023
