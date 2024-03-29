# Initialize Variables
$accountName = "" # Stores the AD User Name you want to term
$Continue = "" # Stores the value for if you want to continue

Write-Warning "You are about to disable an Active Directory User Object.  Be absolutely sure you have the correct Separation!"

# Prompt for account name and store input into the $accountName Variable
Write-Host "What is the User's Logon to Disable?" -NoNewline -ForegroundColor Cyan
Write-Host "  " -NoNewline
$accountName = Read-host
$ErrorActionPreference = "Stop"

# Run the AccountLookupPrompt script and Display results on screen or end script
Try {
Get-ADUser $accountName -Properties * | Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}},@{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$','*'}} 

$ADUser = Get-ADUser $accountName -Properties *
$DN = $ADUser.Displayname
}
Catch {
Write-Host "AD Account does not exist" -foregroundcolor "Red"
Break
}

# Display the account name specified and Prompt to continue
Write-Host "Account to be DISABLED is $DN.  Do you want to continue (y or n)?" -nonewline -ForegroundColor Cyan
$Continue = Read-host 

If ($Continue -eq "y") {

# Records and Exports AD Account & Exchange properties 
C:\Script\ActiveDirectory\AccountTermDisable\Disable-Step1a.ps1

}

Else {
Write-Host "End of Script."  -ForegroundColor Red
}


