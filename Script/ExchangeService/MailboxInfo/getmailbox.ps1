
 Write-Host "Username of the mailbox?  " -NoNewline -ForegroundColor Green
 $SamWildcard = Read-Host
 
$Results = Get-Mailbox *$SamWildcard*
 
 Foreach ($ColItem in $Results)
 
 {
 Write-Host "********************************************************************************" -ForegroundColor Green
 Write-Host "User's Name           " $ColItem.Name -ForegroundColor Yellow
 Write-Host "User's Alias          " $ColItem.Alias -ForegroundColor Green
 Write-Host "Window's Email:       " $ColItem.WindowsEmailAddress -ForegroundColor Green
 Write-Host "Exhcange addresses:   " $ColItem.Emailaddresses -ForegroundColor Green
 Write-Host "When Mailbox Created: " $ColItem.WhenMailboxCreated -ForegroundColor Green
 Write-Host ""
 }
 