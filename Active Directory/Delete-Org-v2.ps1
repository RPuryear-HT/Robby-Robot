# Clear the manager for a list of AD users. Must have a properly formatted csv file containing the target usernames. Examples below.
Import-Module ActiveDirectory
$csv = "C:\scripts\deleteorg.csv"
$userlist = Import-Csv -Path $csv
foreach ($user in $userlist) {
    $username = $user.Username
    Set-ADUser -Identity $username -Clear Manager
    Write-Output "Cleared manager for user $username"
}
Write-Host "Manager clearing process completed." -ForegroundColor Red
<# 

Note: Below are 2 examples of formatting needing for the csv file. Either works, but separate columns is easier to manipulate. 

Make sure your CSV file has the Username header. For example:

|Manager|Username| <<<<<<<<<< Header
|boss1|user1 | 
|boss2|user2 | 

(2) Example of csv format:

Username,Manager       <<<<<<<<<< Header
user1,boss1    
user2,boss2    

Created by Robert Puryear # Updated 10/24/2024 

#>