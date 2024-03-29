Write-Host "Enter the SamAcocuntName of the account. " -NoNewline -ForegroundColor Green
$User = Read-Host

Write-Host "Is this an E3 or E1 account? " -NoNewline -ForegroundColor Green

$AccountType = Read-Host

If ($AccountType -eq "E3") 
{
Get-MSolUser -UserPrincipalName $user@zulily.com | Set-MSolUser -Usagelocation "US" 
Get-MSolUser -UserPrincipalName $user@zulily.com | Set-MsolUserLicense -AddLicenses "zulily365:Enterprisepack"

Write-Host "Adding " -NoNewline -ForegroundColor Green
Write-Host "$User " -NoNewline -ForegroundColor Yellow
Write-Host "to US/E3 EnterprisePack License. " -ForegroundColor Green
}

Elseif ($AccountType -eq "E1")
{
Get-MSolUser -UserPrincipalName $user@zulily.com | Set-MSolUser -Usagelocation "US"  
Get-MSolUser -UserPrincipalName $user@zulily.com | Set-MsolUserLicense -AddLicenses "zulily365:StandardPack"

Write-Host "Adding " -NoNewline -ForegroundColor Green
Write-Host "$User " -NoNewline -ForegroundColor Yellow
Write-Host "to US/E1 StandardPack License. " -ForegroundColor Green
}