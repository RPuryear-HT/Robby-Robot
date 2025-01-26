# This script scans for files over a defined size and produces the file count.
$path = Read-Host -Prompt 'Please enter the file path to scan'
$size = Read-Host 'Enter the minimum file size. ie. 100MB'
$rawfiledata = Get-ChildItem -Path $path -Recurse
$largefiles = $rawfiledata | Where-Object {$_.Length -gt $size}
$largefilescount = $largefiles | Measure-Object | Select-Object -ExpandProperty Count
Write-Host "You have $largefilescount large file(s) in $path" -foregroundcolor Magenta
# Created by Robert Puryear 1/27/2023