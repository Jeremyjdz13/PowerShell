

Write-Host "Enter the Primary SMTP/Alias Name of the new Distribution Group.  " -NoNewline -ForegroundColor Green

$dbsmtp = Read-Host

Write-Host "Enter the Display Name for the Distribution Group.  " -NoNewline -ForegroundColor Green

$dbname = Read-Host

Write-Host	"Enter the User Account who will Own this Distribution Group.  " -NoNewline -ForegroundColor Green

$dbowner = Read-Host

New-DistributionGroup `
-DisplayName "$dbname" `
-Name "$dbname" `
-Alias $dbsmtp `
-PrimarySmtpAddress $dbsmtp@zulily.com `
-Managedby $dbowner -CopyOwnerToMember `



$Results1 = Get-DistributionGroup -identity $dbsmtp 

Foreach ($ColItems in $Results1)
{
Write-Host "*************************" -ForegroundColor Green
Write-Host "Name of Group:      " $ColItems.name -ForegroundColor Yellow
Write-Host "Manage by:          " $ColItems.managedby -ForegroundColor Green
Write-Host "PrimarySMTPAddress: " $ColItems.PrimarySmtpAddress -ForegroundColor Green
Write-Host "*************************" -ForegroundColor Green
}

$Result2 = Get-DistributionGroupMember -Identity $dbsmtp

Foreach ($colItems in $Result2)
{
Write-Host "*****************************" -ForegroundColor DarkGreen
Write-Host "" $colItems.name -ForegroundColor Green
Write-Host "*****************************" -ForegroundColor DarkGreen
}




