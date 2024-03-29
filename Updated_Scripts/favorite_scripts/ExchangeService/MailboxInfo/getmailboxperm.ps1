$date = Get-Date -format M-d-yyyy-hhmm
Write-Host "Username of the mailbox. " -NoNewline	-ForegroundColor Green

$UPN = Read-Host

$results = $results = Get-EXOMailbox -Identity *$UPN* | Get-EXOMailboxPermission | where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false} 
$results = $results | where {$_.user.tostring() -replace "[A-Z][-][0-9][-][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][-][0-9][0-9][0-9][0-9][0-9][0-9][0-9]",""}

Write-Host "Do you want an Exported copy of the results (y,n)?" -NoNewline -ForegroundColor Green

$export = Read-Host

if ($export -eq "y"){
$results | Select-Object User,AccessRights,Identity | Export-CSV c:\Script\ExchangeService\MailboxInfo\$UPN-$date.csv -notype	
}

 if ($results){
foreach ($object in $results)
{
Write-Host "*********************" -ForegroundColor DarkGreen
Write-Host "" $object.identity -ForegroundColor Green
Write-Host "" $object.User -ForegroundColor Yellow
Write-Host "" $object.AccessRights -ForegroundColor Green
Write-Host "*********************" -ForegroundColor DarkGreen
}}

Else{
Write-Host	"No Mailbox Folder permissions set for " -NoNewline -ForegroundColor Green
write-host "$UPN." -ForegroundColor yellow
}

$results2 = $results2 = Get-EXOMailboxFolderPermission -identity *$UPN*:\Calendar | where {$_.User.tostring()-ne "Anonymous"} 
$results2 = $results2 | where {$_.User.tostring()-ne "Default"} 

If ($results2){

foreach ($object2 in $results2) {
Write-Host "*****************************" -ForegroundColor DarkGreen
Write-Host "" $object2.Foldername -ForegroundColor Green
Write-Host "" $object2.User -ForegroundColor Yellow
Write-Host "" $object2.AccessRights -ForegroundColor Magenta
Write-Host "*****************************" -ForegroundColor DarkGreen
}}

Else{
Write-Host "No Calendar Folder Permissions set for " -NoNewline -ForegroundColor Green
Write-Host "$UPN." -ForegroundColor Yellow
}
