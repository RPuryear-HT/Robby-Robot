# Add on-prem "Send As" rights to an O365 mailbox

# Prompt the user to enter the group name to delegate rights
$delegatedbox = Read-Host "Enter the group name to delegate rights"

# Prompt the user to enter the user's reply address
$delegateduser = Read-Host "Enter the user's reply address"

# Add "Send As" permission to the specified mailbox for the target user
Get-Mailbox "$delegatedbox@<YourDomain>.com" | Add-ADPermission -User "$delegateduser@<YourDomain>.com" -ExtendedRights "Send As"

# Reference article: https://woshub.com/sendas-send-onbehalf-permissions-exchange/

# Created by Robert Puryear # Updated 8/6/2024