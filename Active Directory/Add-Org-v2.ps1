# Update the manager for a list of AD users. Must have a properly formatted csv file containing target usernames. Examples below.
Import-Module ActiveDirectory
$csv = "C:\scripts\addorg.csv"
$userlist = Import-Csv -Path $csv
foreach ($user in $userlist) {
    $username = $user.Username
    $manager = $user.Manager
    Set-ADUser -Identity $username -Manager $manager
    Write-Output "Updated manager for user $username to $manager" | Out-Host
}
Write-Host "Manager add process completed." -ForegroundColor Green
<# 

Note: Below are 2 examples of formatting needing for the csv file. Either works, but separate columns is easier to manipulate. 

Make sure your CSV file has the Username header. For example:

(1) Example of csv format:

|Manager|Username| <<<<<<<<<< Header
|boss1|user1 | 
|boss2|user2 | 

(2) Example of csv format:

Username,Manager       <<<<<<<<<< Header
user1,boss1    
user2,boss2    

Created by Robert Puryear # Updated 10/24/2024 

#>