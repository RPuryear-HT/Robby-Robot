#View stopped services on a system

$computername= Read-Host "Enter the target Computername"

# Measure the time taken to run the script
$runtime = Measure-Command {

Invoke-Command -ComputerName $computername {$stoppedservice = (Get-Service).where({$_.Status -EQ 'Stopped'})

Write-Output $stoppedservice | Out-Host
}

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Created by Robert Puryear # Updated 1/8/2025