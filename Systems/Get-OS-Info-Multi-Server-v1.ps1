# List the name, description and operating system of the target machines. Must have a list located C:\scripts\computers.txt.
$computers = Get-Content C:\scripts\computers.txt
foreach ($computer in $computers) {
Get-ADComputer $computer -properties * | Format-Table Name, Description, OperatingSystem
}
# Created by Robert Puryear # Updated 3/27/2024