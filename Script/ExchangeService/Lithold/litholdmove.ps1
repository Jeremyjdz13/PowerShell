Write-Host "Type the User Account to place on Lit Hold.  " -NoNewline -ForegroundColor Cyan

$user = Read-Host

Set-Mailbox $user -LitigationHoldEnabled $True -LitigationHoldDuration 365

$userm = Get-ADUser -Identity $user -properties distinguishedName

Move-ADObject -Identity $Userm.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"