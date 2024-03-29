Write-Host "Please enter a username for mailbox statistics.  " -NoNewline -ForegroundColor Green
$SAmWildcard = Read-Host 

Get-EXOMailboxStatistics -identity *$SAmWildcard* | `
Select-Object DisplayName, TotalItemSize, TotalDeletedItemSize, DeletedItemCount, LastLogoffTime, LastLogonTime

Get-EXOMailbox *$SamWildcard* | Get-EXOMailboxFolderStatistics -FolderScope RecoverableItems | Format-Table Name,FolderPath,ItemsInFolder,FolderAndSubfolderSize