# Add an Office 365 group to the allowed sender list for an on-premises distribution group. Requires manual editing.

# Create a new PowerShell session to connect to the on-premises Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServerAddress>/PowerShell -Authentication Kerberos

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppress warning banner
Import-PSSession $session -AllowClobber 3>$null

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Prompt user to check for the Exchange Online logon window
Write-Host "Waiting for user to authenticate.. Please check the Exchange Online logon window to continue.."

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Add a group to the list of groups allowed to send messages to the target distribution group
Set-DistributionGroup "<YourTargetGroup>" -AcceptMessagesOnlyFrom @{add="<GroupToAllow>"}

# Retrieve and display the list of groups allowed to send messages to the target distribution group
Get-DistributionGroup -Identity "<YourTargetGroup>" | Format-List AcceptMessagesOnlyFrom

# Created by Robert Puryear # Updated 12/11/2024
