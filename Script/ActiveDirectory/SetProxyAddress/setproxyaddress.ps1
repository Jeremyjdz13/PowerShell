Write-Host "Type user account that needs Proxy Address.  " -NoNewline -ForegroundColor Cyan
$SAN = Read-Host

Write-Host "Enter the Proxy Address for said user.  " -NoNewline -ForegroundColor Cyan
$PAddress = Read-Host

$user = Get-ADUser $SAN  -Properties mail,department,ProxyAddresses
$user.ProxyAddresses = "smtp:$PAddress@zulily.com"  
Set-ADUser -instance $user 
Write-Host "Proxy Address set as " -NoNewline -ForegroundColor Cyan
write-host "smpt:$PAddress@zulily.com" -ForegroundColor Green
