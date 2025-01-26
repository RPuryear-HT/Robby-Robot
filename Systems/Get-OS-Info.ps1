# List the name, description and operating system of a target machine.
$computer = Read-Host "Enter the Computername"
Get-ADComputer $computer -properties * | Format-Table Name, Description, OperatingSystem
# Created by Robert Puryear # Updated 4/24/2023