Import-Module ActiveDirectory

Get-ADComputer -Filter "Name -like '*<SearchTerm>*'" -Properties *