# Search AD groups based on name. Requires editing.
Import-Module ActiveDirectory
Get-ADGroup -Filter {name -like "<YourSearch>*"} -Properties Description,info | Select-Object Name,samaccountname,Description,info | Sort-Object Name
# Created by Robert Puryear # Updated 10/5/2023