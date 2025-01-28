# Search AD groups based on name. Requires editing.

# Import the Active Directory module
Import-Module ActiveDirectory

# Retrieve all user objects from Active Directory where the name matches the specified search pattern, select only the Name property, sort by Name, format the output as a table, and display it in the console
Get-ADGroup -Filter {name -like "<YourSearch>*"} -Properties Description,info | Select-Object Name,samaccountname,Description,info | Sort-Object Name

# Created by Robert Puryear # Updated 1/28/2025
