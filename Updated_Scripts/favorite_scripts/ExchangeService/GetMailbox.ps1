#This Script retrieves basic Get-EXOMailbox, Get-EXOCasMailbox, Get-MSOLuser, and Get-EXOMailboxtstatistics/folder information

Write-Host "Username of the mailbox?  " -NoNewline -ForegroundColor Green
$SWC = Read-Host
Write-Host "Retrieving Information.." -ForegroundColor Green 

$lh = Get-EXOMailbox *$SWC* -erroraction SilentlyContinue


if ($lh -ne $null){
Get-EXOMailbox $lh.userprincipalname |`
Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, prohibitsendreceivequota, `
@{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }}

Get-Msoluser -userprincipalname $lh.userprincipalname | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime, BlockCredential

Get-EXOCASMailbox $lh.alias | Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, ImapEnabled, MapiEnabled

}  
Else{
Write-Host "$SWC doesn't have a valid Mailbox or you misspelled the User Principle Name."  -ForegroundColor Red
}

if ($lh.litigationholdenabled -eq $true){
Write-Host "User is currently on Litigation Hold. Processing Deleted/RecoverableItem's details." -ForegroundColor Green
Get-EXOMailboxstatistics $lh.Userprincipalname | Select-Object DisplayName, TotalItemSize, TotalDeletedItemSize, DeletedItemCount
Get-EXOMailboxFolderStatistics $lh.userprincipalname -folderscope RecoverableItems | Format-Table Name,FolderPath,ItemsInFolder,FolderAndSubfolderSize
}
Elseif ($lh.litigationholdenabled -eq $false){
Write-Host "$lh isn't on litigationhold. View DeletedItems details." -ForegroundColor Green
Get-EXOMailboxstatistics $lh.Userprincipalname | Select-Object DisplayName, TotalItemSize, TotalDeletedItemSize, DeletedItemCount
}

if ($lh.archivestatus -eq "Active"){
Write-Host "$lh has Archiving Activated. View details below." -ForegroundColor Green
Get-EXOMailbox $lh.userprincipalname | Select ArchiveGuid, ArchiveName, ArchiveQuota, ArchiveStatus
}

Elseif ($lh.archivestatus -eq "none"){
Write-Host "Archiving is not activated for $lh." -ForegroundColor Green
}



