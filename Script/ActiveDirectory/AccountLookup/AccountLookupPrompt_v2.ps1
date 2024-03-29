
Write-Host "What is the user's First Name?"  -NoNewline -ForegroundColor Cyan
$GName = Read-host

Write-Host "What is the user's Last Name?"  -NoNewline -ForegroundColor Cyan
$Surname = Read-host

Try{
Get-ADUser -Filter {GivenName -eq $GName -and Surname -eq $Surname} -Properties * | `
Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}},@{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$','*'}}
}
Catch{
Write-Host "$GName $Surname doesn't have an Active Directory Object or the name is misspelled." -ForegroundColor Red
Break
}
