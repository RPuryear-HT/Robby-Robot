# Clear the manager for a list of AD users. Must have a properly formatted csv file containing the target usernames.

# Import the Active Directory module
Import-Module ActiveDirectory

# Define the path to the CSV file containing the usernames
$csv = "C:\scripts\deleteorgchartlist.csv"

# Import the CSV file
$userlist = Import-Csv -Path $csv

# Loop through each user in the CSV file
foreach ($user in $userlist) {
    # Get the username from the CSV
    $username = $user.Username

    # Clear the manager attribute in Active Directory
    Set-ADUser -Identity $username -Clear Manager

    # Output the result
    Write-Output "Cleared manager for user $username" | Out-Host
}

Write-Output "Manager clearing process completed." | Out-Host
