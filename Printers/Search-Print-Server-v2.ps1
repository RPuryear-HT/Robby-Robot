#Search a remote server for a printer by keyword.

$server = Read-Host "Enter the server name"
$searchterm = Read-Host "Enter a search term"

# Measure the time taken to run the script
$runtime = Measure-Command {

$query = (Get-Printer -ComputerName $server).where({$_.Name -like "*$searchterm*"})
$query  | Sort-Object Name | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue