# Set target O365 user's mailbox archive to auto-expanding (up to 1.5TB) and verify settings. Archiving and litigation hold must be enabled.

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Prompt user to check for the Exchange Online logon window
Write-Host "Waiting for user to authenticate.. Please check the Exchange Online logon window to continue.."

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Prompt the user to enter the username
$user = Read-Host "Enter the Username"

# Set mailbox archive to auto-expanding
Enable-Mailbox $user -AutoExpandingArchive 

# Verify auto-expanding arhive is enabled
Get-Mailbox $user | Format-List AutoExpandingArchiveEnabled 

# Reference article: https://learn.microsoft.com/en-us/microsoft-365/compliance/enable-autoexpanding-archiving?view=o365-worldwide
# Created by Robert Puryear # Created 3/6/2023 # Updated 1/31/2025