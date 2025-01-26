# Delegate "send as" rights from one distribution group to another distribution group.

# Create a new PowerShell session to connect to the on-premises Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServerAddress>/PowerShell -Authentication Kerberos

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppress warning banner
Import-PSSession $session -AllowClobber 3>$null

# Prompt the user to enter the target group that the user wants to access
$targetgroup = Read-Host "Enter the group the user wants to access"

# Prompt the user to enter the delegated group that needs the rights
$delegatedgroup = Read-Host "Enter the group needing the rights"

# Add the delegated group to the list of groups allowed to send messages to the target distribution group
Set-DistributionGroup $targetgroup  -AcceptMessagesOnlyFrom((Get-DistributionGroup  $targetgroup).AcceptMessagesOnlyFrom + $delegatedgroup)

# Created by Robert Puryear # Updated 12/11/2024
# Reference article: https://learn.microsoft.com/en-us/exchange/troubleshoot/administration/cannot-eac-add-remote-shared-mailbox-distribution-group