# Add on-prem "Send As" rights to an O365 mailbox. Method 2 of 3.

# Prompt the user to enter the group name to delegate rights
$delegatedbox = Read-Host "Enter the group name to delegate rights"

# Prompt the user to enter the user's reply address
$delegateduser = Read-Host "Enter the user's reply address"

# Create a new PowerShell session to connect to the on-premises Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServerAddress>/PowerShell -Authentication Kerberos

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppress warning banner
Import-PSSession $session -AllowClobber 3>$null

# Add "Send As" permission to the specified mailbox for the target user
Get-Mailbox "$delegatedbox@<YourDomain>.com" | Add-ADPermission -User "$delegateduser@<YourDomain>.com" -ExtendedRights "Send As"

<# Reference article(s): 
https://learn.microsoft.com/en-us/answers/questions/160424/exchange-2013-permission-for-granting-send-as-perm
https://woshub.com/sendas-send-onbehalf-permissions-exchange/
#>

# Created by Robert Puryear 8/6/2024 # Updated 1/28/2025
