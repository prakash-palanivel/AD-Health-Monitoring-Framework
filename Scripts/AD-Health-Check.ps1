# ============================================
# Active Directory Health Monitoring Script
# Author: Prakash Palanivel
# ============================================

Write-Host "====================================="
Write-Host " Active Directory Health Check"
Write-Host "====================================="

# Check Domain Controller Connectivity
Write-Host "`nChecking Domain Controller Connectivity..."

$DomainControllers = Get-ADDomainController -Filter *

foreach ($DC in $DomainControllers) {

    $Ping = Test-Connection $DC.HostName -Count 2 -Quiet

    if ($Ping) {

        Write-Host "$($DC.HostName) : ONLINE" -ForegroundColor Green

    }
    else {

        Write-Host "$($DC.HostName) : OFFLINE" -ForegroundColor Red

    }
}

# Check Replication Status
Write-Host "`nChecking Replication Status..."

repadmin /replsummary

# Check FSMO Roles
Write-Host "`nChecking FSMO Roles..."

netdom query fsmo

# Check Critical Services
Write-Host "`nChecking AD Services..."

$Services = @(
    "NTDS",
    "DNS",
    "Netlogon",
    "KDC"
)

foreach ($Service in $Services) {

    $Status = Get-Service $Service

    Write-Host "$($Status.Name) : $($Status.Status)"
}

Write-Host "`nHealth Check Completed."
