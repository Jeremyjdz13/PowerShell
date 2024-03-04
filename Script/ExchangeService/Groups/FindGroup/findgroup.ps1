Write-Host "Type the Distribution Group name or some of the letters.. " -NoNewline -ForegroundColor Green

$GN = Read-Host

$Results = Get-DistributionGroup -identity *$GN* 

Foreach ($ColItems in $Results)
{
Write-Host "*************************" -ForegroundColor Green
Write-Host "Name of Group:      " $ColItems.name -ForegroundColor Yellow
Write-Host "Manage by:          " $ColItems.managedby -ForegroundColor Green
Write-Host "PrimarySMTPAddress: " $ColItems.PrimarySmtpAddress -ForegroundColor Green
Write-Host "*************************" -ForegroundColor Green
}

