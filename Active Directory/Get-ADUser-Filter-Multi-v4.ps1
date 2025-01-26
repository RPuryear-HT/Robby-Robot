# Generate a report of user account and display names from a list of email addresses. Must have a list located at C:\scripts\userlist.txt. Outputs to C:\scripts\users_**.csv.
$userlist = Get-Content C:\scripts\$userlist.txt
$label = Get-Date -Format 'yyyyMMddTHHmmss'
    if ($user = $null) {break}
                    foreach ($user in $userlist){
        $user = Get-ADUser -Filter "emailaddress -like '$user'" -Properties SamAccountName, UserPrincipalName, DisplayName | Select-Object SamAccountName, UserPrincipalName, DisplayName -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            UserName      = $user.UserPrincipalName
            DisplayName    = $user.DisplayName
        } | Export-Csv -Path C:\scripts\users_$label.csv -NoTypeInformation -Append
}
(Get-Variable).where({$_.Options -ne "ReadOnly" -and $_.Options -ne "Constant"}) | Remove-Variable -ErrorAction SilentlyContinue
# Created by Robert Puryear # Updated 8/29/2024