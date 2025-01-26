# Add on-prem "Send As" rights to an O365 mailbox. Method 3 of 3.

# Prompt the user to enter the mailbox logon name to delegate rights
$delegatedbox = Read-Host "Enter the mailbox logon name to delegate rights."

# Prompt the user to enter the target user's O365 email address
$delegateduser = Read-Host "Enter the target user's O365 email address."

# Grant "Send on Behalf" permission to the specified mailbox for the target user
Set-Mailbox "$delegatedbox" -GrantSendOnBehalfTo @{add="$delegateduser"}

# Reference article: https://answers.microsoft.com/en-us/msoffice/forum/all/add-send-on-behalf-permission-from-an-onprem/289a95ad-8178-4fb9-acd5-a376825151c9
# Created by Robert Puryear # Updated 8/6/2024