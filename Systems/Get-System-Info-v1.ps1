# View a full list of system properties on target computer.
$computer = Read-Host "Enter the Computername"
Invoke-Command -ComputerName $computer {Get-CimInstance -Class Win32_OperatingSystem | Get-ComputerInfo}
# Created by Robert Puryear # Updated 2/23/2023