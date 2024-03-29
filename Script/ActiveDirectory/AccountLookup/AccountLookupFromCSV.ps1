# Imports the NewAccount.csv file and Displays the info
Write-Host "Each Active user account is shown in " -NoNewline -ForegroundColor Cyan
Write-Host	"Yellow." -ForegroundColor Yellow
Write-Host "Accounts that do not exist will show in " -NoNewline -ForegroundColor Cyan
Write-Host "Red." -ForegroundColor Red
Write-Host "" 
$ErrorActionPreference = "Continue"

import-csv c:\Script\CSV-Files\Imported\NewAccounts.csv | % {

try{$ColItems = Get-ADUser $_.ADAccount -Properties Manager, Title, Emailaddress, samAccountName, whenCreated, LastlogonDate, Department, Enabled | `
Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department, Enabled, @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}

Foreach ($objItem in $ColItems){
Write-Host "***************************************"
Write-Host "Name:    " $objItem.Name -ForegroundColor Yellow
Write-Host "Depart:  " $objItem.Department -ForegroundColor Cyan
Write-Host "Title:   " $objItem.title -ForegroundColor Cyan
Write-Host "Email:   " $objItem.emailaddress -ForegroundColor Cyan
Write-Host "UserId:  " $objItem.samaccountname -ForegroundColor Cyan
Write-Host "Manager: " $objItem.Manager -ForegroundColor Cyan
Write-Host "SOX Related Data..." -ForegroundColor Magenta
Write-Host "WhenCreated:  " $objItem.whenCreated -ForegroundColor Magenta
Write-Host "LastLogOn:    " $objItem.LastlogonDate -ForegroundColor Magenta
Write-Host "Enabled:      " $objItem.Enabled -ForegroundColor Magenta
}}
Catch{
Write-Host ""
Write-Host "***************************************"
Write-Host "$_.ADAccount Account doesn't exist."  -ForegroundColor Red
Write-Host ""
}}