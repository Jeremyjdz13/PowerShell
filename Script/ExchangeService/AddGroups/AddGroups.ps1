Write-Host "What is the username for the user?  " -NoNewline -ForegroundColor Green
$User = Read-host 
import-csv c:\Script\ExchangeService\AddGroups\GroupsToAdd.csv | % {
Add-DistributionGroupMember -Identity $_.Groups -Member $User -Confirm:$False
}

