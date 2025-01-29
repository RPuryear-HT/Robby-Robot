# Stops the BITS service on a target machine
$computername = Read-Host "Enter the computer name"
$service = Invoke-Command -ComputerName $computername -ScriptBlock {
    Get-Service -Name "CCMEXEC" 
}
if ($service.Status -eq "Running") {
    Restart-Service $service -Force
    Write-Host "CCMEXEC service restarted successfully on $computername" -ForegroundColor Blue
} else {
    Write-Host "CCMEXEC service was not running on $computername" -ForegroundColor Cnotyan
}
# Created by Robert Puryear # Updated 2/24/2023