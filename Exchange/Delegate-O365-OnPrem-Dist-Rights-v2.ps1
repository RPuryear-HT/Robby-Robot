# Add on-prem "Send As" rights to an O365 mailbox

# Prompt the user to enter the distribution list's name to delegate rights
$distro = Read-Host "Enter the distribution list's name to delegate rights."

# Prompt the user to enter the target user's O365 email address
$365email = Read-Host "Enter the target user's O365 email address."

# Create a new PowerShell session to connect to the on-premises Exchange server
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<YourExchangeServerAddress>/PowerShell -Authentication Kerberos

# Import the PowerShell session created for Exchange, allowing clobbering of existing commands and suppressing warning messages
Import-PSSession $session -AllowClobber 3>$null

# Add "Send As" permission to the on-premises distribution list for the O365 user
Add-ADPermission -Identity $distro -User $365email -AccessRights ExtendedRight -ExtendedRights "Send As"

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Add "Send As" permission to the O365 distribution list for the O365 user
Add-RecipientPermission -Identity $distro-Trustee $365email -AccessRights SendAs

# Exit the PowerShell session
Remove-PSSession $session

# Clean up variables to avoid any conflicts or unnecessary data retention
Get-Variable | Where-Object { $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" } | Remove-Variable -ErrorAction SilentlyContinue