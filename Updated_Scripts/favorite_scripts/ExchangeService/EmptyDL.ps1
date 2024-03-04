$emptyGroups = foreach ($grp in Get-DistributionGroup -ResultSize Unlimited) {
    if (@(Get-DistributionGroupMember –Identity $grp.DistinguishedName -ResultSize Unlimited).Count –eq 0 ) {
        [PsCustomObject]@{
            DisplayName        = $grp.DisplayName
            PrimarySMTPAddress = $grp.PrimarySMTPAddress
            DistinguishedName  = $grp.DistinguishedName
        }
    }
}
$emptyGroups | Export-Csv 'C:\Script\CSV-Files\Exported\DLsToRemove.csv' -NoTypeInformation