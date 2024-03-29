Write-Host "Enter the username to check for Mailbox Access Rights. " -NoNewline -ForegroundColor Green
$user = Read-Host 

Write-Host "Processing; takes an average of 5 minutes to complete. " -ForegroundColor Green

$mailboxes = Get-EXOMailbox -ResultSize Unlimited | Get-EXOMailboxPermission -User $user | Select-Object Identity, AccessRights, Deny 

Foreach ($object in $mailboxes)

{
Write-Host "****************************" -ForegroundColor Green
Write-Host "Mailbox:      " $object.Identity  -ForegroundColor Yellow
Write-Host "AccessRights: " $object.AccessRights -ForegroundColor Green
Write-Host "Deny:         " $object.Deny -ForegroundColor Magenta
Write-Host "****************************" -ForegroundColor Green
}

