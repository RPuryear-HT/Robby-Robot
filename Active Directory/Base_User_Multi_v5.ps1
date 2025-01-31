<#


 /$$$$$$$                                      /$$   /$$                              
| $$__  $$                                    | $$  | $$                              
| $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$       | $$  | $$  /$$$$$$$  /$$$$$$   /$$$$$$ 
| $$$$$$$  |____  $$ /$$_____/ /$$__  $$      | $$  | $$ /$$_____/ /$$__  $$ /$$__  $$
| $$__  $$  /$$$$$$$|  $$$$$$ | $$$$$$$$      | $$  | $$|  $$$$$$ | $$$$$$$$| $$  \__/
| $$  \ $$ /$$__  $$ \____  $$| $$_____/      | $$  | $$ \____  $$| $$_____/| $$      
| $$$$$$$/|  $$$$$$$ /$$$$$$$/|  $$$$$$$      |  $$$$$$/ /$$$$$$$/|  $$$$$$$| $$      
|_______/  \_______/|_______/  \_______/       \______/ |_______/  \_______/|__/      
                   /$$      /$$           /$$   /$$     /$$                           
                  | $$$    /$$$          | $$  | $$    |__/                           
                  | $$$$  /$$$$ /$$   /$$| $$ /$$$$$$   /$$                           
                  | $$ $$/$$ $$| $$  | $$| $$|_  $$_/  | $$                           
                  | $$  $$$| $$| $$  | $$| $$  | $$    | $$                           
                  | $$\  $ | $$| $$  | $$| $$  | $$ /$$| $$                           
                  | $$ \/  | $$|  $$$$$$/| $$  |  $$$$/| $$                           
                  |__/     |__/ \______/ |__/   \___/  |__/                           
                                                                                      
                                                                                      
Description: Create multiple base users, set OU, network folder, on-prem mailbox & add to the desired groups.
==============================================================================================================================
Note: Requires manual editing. You can add an 'if' or 'match' statement to any step in order to apply to your specific user 
types. No one script can fulfill everyone's needs, so customize this for your environment. Account credentials must have 
Active Directory Object, file server and Exchange Online admin permissions. Requires a list of users located at 
C:\scripts\baseusers.txt and passwords at C:\scripts\passwords.txt. Place as many passwords as you like and one will be chosen 
at random. This will take seconds up to several minutes to run depending on the user/group count. Please wait for script 
completion messages. Use at your own risk.
==============================================================================================================================
Author: Robert Puryear
==============================================================================================================================
Last Revision: 1/30/2025
==============================================================================================================================
                                                                        
   ____ _                            _             
  / ___| |__   __ _ _ __   __ _  ___| | ___   __ _ 
 | |   | '_ \ / _` | '_ \ / _` |/ _ \ |/ _ \ / _` |
 | |___| | | | (_| | | | | (_| |  __/ | (_) | (_| |
  \____|_| |_|\__,_|_| |_|\__, |\___|_|\___/ \__, |
                          |___/              |___/ 
                            
==============================================================================================================================
12/24/2024
Created original script.
1/30/2025
Recreated script for public use.
Edited description.
==============================================================================================================================

#>

# Import the Active Directory module to use its cmdlets
Import-Module ActiveDirectory

# Create a new PowerShell session for Exchange with the specified configuration and connection URI
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServer>/PowerShell -Authentication Kerberos

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppress warning banner
Import-PSSession $session -AllowClobber 3>$null
        
# Specify the Organizational Unit (OU) where the groups will be created
$ou = Read-Host "Enter the distinguished name for your target OU Ex. OU=<YourOU>,DC=<YourDomain>"

# Measure the time taken to run the script
$runtime = Measure-Command {

    # Retrieve the list of usernames from the specified file
    $usernames = Get-Content C:\scripts\baseusers.txt

    # Retrieve a random password from the specified file
    $password = Get-Content C:\scripts\passwords.txt | Get-Random

    # Set the error action preference to stop on errors
    $ErrorActionPreference = "stop"

    # Loop through each username in the list of usernames
    foreach ($username in $usernames) {
    
        # Output a message indicating the creation tasks for the username are running
        Write-Output "Create $username tasks running" | Out-Host
    
        # Specify the user description for all users
        $description = Read-Host "Enter $username description"

        # Specify the user display name
        $displayname = Read-Host "Enter $username display name"

        # Define the folder path for the new user
        $folderpath = Read-Host "Enter $username network folder path Ex. \\<YourFileServer>\<YourUserFolder>"  

        # Specify the user job title
        $jobtitle = Read-Host "Enter $username job title"

        # Create a new Active Directory user with the specified properties
        New-ADUser -Description $description -DisplayName $displayname -Name "$username" -SamAccountName $username -UserPrincipalName "$username@<YourDomain>.com" -AccountPassword (ConvertTo-SecureString "$password" -AsPlainText -Force) -Enabled $true -ChangePasswordAtLogon $true -Title $jobtitle -Company "<YourCompany>"-Path $ou

        # Output a message indicating the user has been created
        Write-Output "Created $username" | Out-Host

        # Output a message indicating that group membership tasks for the user are running
        Write-Output "$username group membership tasks running" | Out-Host

        # Add user to groups
        $groups = @("<YourGroup1>", "<YourGroup2>l", "<YourGroup3>")
        foreach ($group in $groups) {
            Add-ADGroupMember -Identity $group -Members $username
        }

        # Output a message indicating that group membership tasks for the user have been completed
        Write-Output "$username group membership tasks completed" | Out-Host

        # Display a message the script is pausing for 10 seconds
        Write-Output "Pausing for 10 seconds..." | Out-Host

        # Pause 10 seconds to allow user to replicate
        $seconds = 10
        for ($i = 0; $i -le $seconds; $i++) {
            $bar = ('#' * $i) + ('-' * ($seconds - $i))
            Write-Host -NoNewline "[$bar] $i/$seconds seconds`r" -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
        
        # Display a message the task is resuming after pause
        Write-Output "Resuming after the pause." | Out-Host 
       
        # Output a message indicating that email creation tasks for the user are running
        Write-Output "$username email tasks running" | Out-Host

        # Create an on-prem mailbox for user with the output and errors suppressed.
        Enable-Mailbox -Identity $username -PrimarySmtpAddress $username"@<YourDomain>.com" -Alias $username -AddressBookPolicy "<YourAddressBookPolicy>" –RetentionPolicy "<YourRetentionPolicy>" -Database "<YourMailboxDatabase>" | Out-Null
        
        # Set mailbox email address aliases
        Set-Mailbox -Identity $username -EmailAddresses @{add = "$username@<YourDomain>.com", "$username@<YourDomainAlias>.com" }
        
        # Output a message indicating that email creation tasks for the user have been completed
        Write-Output "$username email tasks completed" | Out-Host
        
    }

    # Output a message indicating that personal network folder tasks are running
    Write-Output "$username network folder tasks running" | Out-Host 
  
    # Check if the folder path exists, if not, create the directory
    if (-Not (Test-Path -Path $folderpath)) {
        New-Item $folderpath -itemtype Directory | Out-Null

        # Get the current access control list (ACL) for the folder
        $acl = Get-Acl $folderpath

        # Create a new access rule to grant the user modify permissions
        $accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule("<YourDomain>\$user", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
        
        # Set the new access rule in the ACL
        $acl.SetAccessRule($accessrule)
        
        # Apply the updated ACL to the folder
        Set-Acl $folderpath $acl
        
        # Output a message indicating the completion of the task for the current username
        Write-Output "$username network folder tasks completed" | Out-Host

    }

    # Create a list of custom objects for each username
    $userlist = foreach ($username in $usernames) {
        [PSCustomObject]@{
            Username    = $username
            DisplayName = $displayname
            Title       = $jobtitle
        }
    }

    # Format the user list as a table and output it
    $userlist | Format-Table

    # Count the total number of usernames
    $total = $usernames.count

    # Output a message indicating the successful creation of users and the temporary password
    Write-Output "Created $total users successfully. Please use temporary password of $password" | Out-Host

}

# Format the total time with labels
$timeformat = "{0:00} Day(s) {1:00} Hour(s) {2:00} Minute(s) {3:00} Second(s) {4:000} Millisecond(s)" -f $runtime.Days, $runtime.Hours, $runtime.Minutes, $runtime.Seconds, $runtime.Milliseconds

# Display the formatted time
Write-Output "Total run time: $timeformat" | Out-Host

# Close the Exchange PowerShell session
Remove-PSSession $session

# Remove all variables that are not read-only or constant
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue

# Clear the content of the specified file
Clear-Content C:\scripts\baseusers.txt