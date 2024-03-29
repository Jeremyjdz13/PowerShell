
Write-Host "Enter Username." -nonewline	 -ForegroundColor Green

$User = read-host 
Write-host "User " -NoNewline -ForegroundColor Green
write-host "$User "  -nonewline -foregroundcolor yellow
write-host "is a member of the following groups:" -ForegroundColor Green


$group =  Import-Csv C:\Script2\ExchangeService\Groups\DistributionGroupMembers.csv
$value = $group | ?{$_."Member Email" -eq "$User@zulily.com"}


Foreach ($object in $value)
{
  Write-Host ""$object."Distribution Group DisplayName"  -ForegroundColor Green
}

Write-Host "Would you like remove " -NoNewline -ForegroundColor Green
Write-Host "$User " -NoNewline -ForegroundColor Yellow
Write-Host "from these groups (y or n)?" -NoNewline -ForegroundColor Green

$remove = Read-Host

If ($remove -eq "y")
{ Foreach ($object in $value){
Remove-Distributiongroupmember -identity $object."Distribution Group DisplayName" -Member $User -confirm:$false
}}
