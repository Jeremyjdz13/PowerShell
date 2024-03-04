#Removes user from all DLs 

Write-Host "Enter the Username... " -NoNewline -ForegroundColor Green
$User = Read-Host
$MB = Get-EXOMailbox $User
$DN = $MB.DistinguishedName
$ID = $MB.Identity
$Filter = "Members -like ""$DN"""

#Exports the Group names to be added to the removal section
Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress | `
Export-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv -NoTypeInformation

$DLs = Import-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv
$DLP = $DLs.PrimarySmtpAddress

#Removal of all groups for specified user.
write-host "User $ID is apart of these Distribution List and/or Groups.." -ForegroundColor Green

If ($DLP -eq $null){
write-host "$ID isn't associated with any DLs or Groups..." -ForegroundColor Red
}
Else {
Foreach($Object in $DLP)
{
Write-Host $Object" "
}}
