# Get a clean list of installed programs on a target machine.
$computername = Read-Host "Enter the Computername"
Invoke-Command -ComputerName $computername {
  Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName | Sort-Object DisplayName | Format-Table
}
# Created by Robert Puryear # Updated 2/25/2023