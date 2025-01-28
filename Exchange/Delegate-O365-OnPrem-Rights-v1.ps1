# Add on-prem "Send As" rights to an O365 mailbox. Method 1 of 3.

# Set the error action preference to stop on errors
$ErrorActionPreference = 'Stop'

# Prompt the user to enter the mailbox logon name to delegate rights
$delegatedbox = Read-Host "Enter the mailbox logon name to delegate rights"

# Prompt the user to enter the target username
$delegateduser = Read-Host "Enter the target username"

# Create a new PowerShell session to connect to the on-premises Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServerAddress>/PowerShell -Authentication Kerberos

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppress warning banner
Import-PSSession $session -AllowClobber 3>$null

# Add "Send As" permission to the on-premises mailbox for the target user
Add-ADPermission -Identity $delegatedbox -User $delegateduser -AccessRights ExtendedRight -ExtendedRights "Send As"

# Add "Send As" permission to the O365 mailbox for the target user
Add-RecipientPermission -Identity $delegatedbox -Trustee $delegateduser -AccessRights SendAs

# Inform the user that the permissions have been granted successfully
Write-Host "$delegateduser has been granted Send As permissions to $delegatedbox successfully" -ForegroundColor Magenta
Write-Host "~ PLEASE ALLOW UP TO 30 MINUTES TO SYNC ~" -ForegroundColor Green

# Exit the PowerShell session
Remove-PSSession $session
  
# Remove all variables that are not read-only or constant
(Get-Variable).where({ $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" }) | Remove-Variable -ErrorAction SilentlyContinue

# Reference article: https://learn.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps
# Created by Robert Puryear 12/11/2024 # Updated 1/28/2025
