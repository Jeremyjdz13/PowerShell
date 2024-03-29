Write-Host "Please enter a username for mailbox statistics.  " -NoNewline -ForegroundColor Green
$SANWildcard = Read-Host 

$Results = Get-MailboxStatistics -identity *$SANWildcard* 

Foreach ($ColItem in $Results)
{
Write-Host "************************************" -ForegroundColor Green
Write-Host "User:                " $ColItem.DisplayName -ForegroundColor Yellow
Write-Host "Total Mailbox Size:  " $ColItem.TotalItemSize -foregroundcolor Green
Write-Host "Total Deleted Size:  " $ColItem.TotalDeletedItemSize -ForegroundColor Green
Write-Host "Total Deleted Items: " $ColItem.DeletedItemCount -ForegroundColor Green
Write-Host "Mailbox Size Limit:  " $ColItem.DatabaseProhibitSendQuota -ForegroundColor Green
Write-Host "Last Log-Off time:   " $ColItem.LastlogoffTime -ForegroundColor Green
Write-Host "Last Log-On time:    " $ColItem.LastLogonTime -ForegroundColor Green
}


$Results2 = Get-Mailbox -Identity *$SANWildcard* | Get-MailboxPermission | where {$_.user.tostring() -ne "NT AUTHORITY\SELF" -and $_.IsInherited -eq $false}

Foreach ($ColItem2 in $Results2){
Write-Host "*************************************" -ForegroundColor yellow
Write-Host "Mailbox Delegates for " $ColItem2.Identity -ForegroundColor Green
Write-Host "User:                 " $ColItem2.user -ForegroundColor Yellow
Write-Host "AccessRights:         " $ColItem2.AccessRights -ForegroundColor Yellow
}
