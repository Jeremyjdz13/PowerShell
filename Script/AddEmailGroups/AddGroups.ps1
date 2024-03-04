$User = Read-host "What is the username for the user?"
import-csv .\GroupsToAdd.csv | % {
Add-DistributionGroupMember -Identity $_.Groups -Member $User -Confirm:$False
}