# Search AD users based on name. Requires editing.

# Import the Active Directory module to use AD cmdlets
Import-Module ActiveDirectory

# Measure the time taken to run the script
$runtime = Measure-Command {

# Retrieve and display a list of Active Directory users whose names match the specific search pattern
Get-ADUser -Filter {name -like "*<YourSearch>*"} -Properties * | Select-Object Name | Sort-Object name | Format-Table -Wrap -Autosize | Out-Host

}
    
# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds
    
# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host
    
# Remove all variables that are not read-only or constant
Get-Variable | Where-Object { $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" } | Remove-Variable -ErrorAction SilentlyContinue

# Created by Robert Puryear # Updated 1/21/2025
