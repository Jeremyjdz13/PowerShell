# Initialize Variables
$accountName = "" # Stores the AD User Name you want to term
$Continue = "" # Stores the value for if you want to continue

# Prompt for account name and store input into the $accountName Variable
Write-Host "What is the User's Logon to Delete?" -NoNewline -ForegroundColor Cyan
Write-Host "  " -NoNewline
$accountName = Read-host
$ErrorActionPreference = "Stop"


# Run the AccountLookupPrompt script and Display results on screen or end script
Try {
$ColItems = Get-ADUser $accountName -Properties Manager, Title, Emailaddress, samAccountName, whenCreated, LastlogonDate, Department, Enabled | `
Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}
Foreach ($objItem in $ColItems){
Write-Host ""
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
Write-Host ""
}
}
Catch {
Write-Host "AD Account does not exist" -foregroundcolor "Red"
Break
}

# Display the account name specified
Write-Host 
Write-Host "Account to Delete-Termination is " -NoNewline -ForegroundColor Cyan
Write-Host $accountName -ForegroundColor Yellow


# Prompt for confirmation for the termination
Write-Host "WARNING you are about to DELETE AD Account (y or n)?" -NoNewline -ForegroundColor Cyan
$Continue = Read-host  

# Run if / else statement 
# if y continue with term
# if anything else end the script

If ($Continue -eq "y") {
# run the WriteDisplayName script which will output account details to a text file 
# file will be located at \\Seafile02\ITHD\TermedUsers
# file will be named after AD User Account
C:\Script\ActiveDirectory\AccountTermDelete\WriteDisplayName.ps1

# Append the current time to the file
get-date >> \\Seafile02\ITHD\TermedUsers\$accountName-Deleted.txt

# Run the AccountTerm Script
C:\Script\ActiveDirectory\AccountTermDelete\Delete-AccountTerm.ps1
Write-Host "Delete-Termination complete" -foregroundcolor "Green"
}

Else {
Write-Host End of Script
}

