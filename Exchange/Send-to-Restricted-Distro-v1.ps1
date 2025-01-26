# Add permissions to a shared mailbox to be able to send emails to a restricted sender distribution group. Requires manual editing.

$groupname = "<YourGroupName>"

Set-DistributionGroup $groupname  -AcceptMessagesOnlyFrom((Get-DistributionGroup  $groupname).AcceptMessagesOnlyFrom + "<YourSharedMailbox>.onmicrosoft.com")

# Reference article: https://learn.microsoft.com/en-us/exchange/troubleshoot/administration/cannot-eac-add-remote-shared-mailbox-distribution-group
# Created by Robert Puryear # Updated 8/9/2024