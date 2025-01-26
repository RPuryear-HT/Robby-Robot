# Find an AD group based on keyword and view the notes and description of the group. Outputs to csv file. Requires manual editing.
$label = Get-Date -Format 'yyyyMMddTHHmmss'
Get-ADGroup -Filter {(name -like '*<SearchTerm>*')} -Property Description, Notes | Select-Object Name, Description, Notes | Export-Csv -Path "C:\scriptsOutput\group_info_$label.csv" -NoTypeInformation -Append
# Created by Robert Puryear # Updated 8/28/2024