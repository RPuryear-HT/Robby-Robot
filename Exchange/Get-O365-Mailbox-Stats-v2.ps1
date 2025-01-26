# Pull mailbox stats for a specified email account, based on the email prefix.

# Import the Exchange Online Management module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online without showing the banner
Connect-ExchangeOnline -ShowBanner:$false

# Prompt the user to enter the email prefix
$user = Read-Host "Enter the email prefix"

# Retrieve and display mailbox statistics for the specified user
Get-MailboxStatistics "$user@<YourDomain>.com" | Format-List TotalItemSize,TotalDeletedItemSize,ItemCount,DeletedItemCount

# Reference article: https://answers.microsoft.com/en-us/outlook_com/forum/all/remote-server-returned-554-520/1ab850a3-339f-4504-a02e-a5de2bbe3a6f
# Created by Robert Puryear # Updated 12/16/2024