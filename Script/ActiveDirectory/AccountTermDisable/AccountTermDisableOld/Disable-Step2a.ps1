# Prompt for Email forwarding
Write-Host "Do you require E-Mail forwarding (y or n)? " -NoNewline -ForegroundColor Cyan
$Continue2 = Read-host 

# Run if / else statement 
# if y continue with term

If ($Continue2 -eq "y") {
# run the AddMailboxPerm script.
Write-Host "What is the Username of the 'Forwardee'? " -NoNewline -ForegroundColor Cyan
$FADaccount = Read-Host 

Add-MailboxPermission $accountName -User $FADaccount -AccessRights FullAccess  
Write-Host "Email fowarded to $FADaccount." -ForegroundColor Green

Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "Email forwarded to $FADaccount."
# Write output to disabled file.
Get-Mailbox -Identity $accountname| Get-MailboxPermission | where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
}

Else {
Write-Host "No E-Mail forwarding & online access disabled." -ForegroundColor Red
}

#Removes user from all DLs 

$MB = Get-Mailbox $AccountName
$DN = $MB.DistinguishedName
$ID = $MB.Identity
$Filter = "Members -like ""$DN"""

#Exports the Group names to be added to the removal section
Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress | `
Export-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv -NoTypeInformation

$DLs = Import-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv
$DLP = $DLs.PrimarySmtpAddress

#Removal of all groups for specified user.
write-host "Processing $ID removal from Distribution List and/or Groups.." -ForegroundColor Green

If ($DLP -eq $null){
write-host "$ID isn't associated with any DLs or Groups..." -ForegroundColor Red
}
Else {
Foreach($Object in $DLP)
{
Write-Host $Object" "
Remove-DistributionGroupMember -identity $Object -Member $accountName -confirm:$false
}}


