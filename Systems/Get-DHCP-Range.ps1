# Get DHCP range info from a DHCP server. Must run with SAP account. Requires manual editing.
$allscopes = Get-DhcpServerv4Scope -ComputerName "<ServerName>"
$filteredscopes = $allscopes | Where-Object {
    $_.StartRange.IPAddressToString -match "\.<RangeStartValue>$" -or
    $_.EndRange.IPAddressToString -match "\.<RangeEndValue>$"
}
$filteredscopes | Format-Table -Property Name, StartRange, EndRange
# Created by Robert Puryear # Updated 3/1/2024