# View last boot time of a system.
$env:COMPUTERNAME = Read-Host "Enter the Computername"
Get-CimInstance -Class Win32_OperatingSystem -ComputerName $env:COMPUTERNAME |
Select-Object -Property CSName,LastBootUpTime
# Created by Robert Puryear 1/24/2023