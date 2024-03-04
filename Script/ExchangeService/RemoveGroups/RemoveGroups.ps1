$User = Read-host "What is the username for the user?"

import-csv c:\Script\ExchangeFunctions\RemoveGroups\GroupsToRemove.csv | % {
Remove-DistributionGroupMember -Identity $_.Groups -Member $User -Confirm:$False 
}

