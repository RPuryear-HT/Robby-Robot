# Get a list of usernames based on the user's email address. Must have a list of email addresses located at C:\scripts\userlist.txt. Exports list to C:\scripts\users_**.csv.
$userlist = Get-Content C:\scripts\$userlist.txt
$label = Get-Date -Format 'yyyyMMddTHHmmss'
    if ($user = $null) {break}
                    foreach ($user in $userlist){
        $user = Get-ADUser -Filter "emailaddress -like '$user'" | Select-Object SamAccountName, UserPrincipalName -ErrorAction SilentlyContinue
        [PSCustomObject]@{
            SamAccountName = $user.SamAccountName
            UserName      = $user.UserPrincipalName
        } | Export-Csv -Path C:\scripts\users_$label.csv -NoTypeInformation -Append
}
Get-variable | Where-Object { $_.Options -ne "ReadOnly" -and $_.Options -ne "Constant" } | Remove-Variable -ErrorAction SilentlyContinue
# Created by Robert Puryear # Updated 8/29/2024