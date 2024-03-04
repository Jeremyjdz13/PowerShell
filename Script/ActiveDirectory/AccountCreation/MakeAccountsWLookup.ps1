# Run the Account Lookup script 
.\AccountLookupFromCSV.ps1

# Prompt to continue if you don't see any accounts that are created
$Continue = ""
$Continue = Read-host "do you want to continue (y or n)?"

#if the user typed y then continue otherwise stop
If ($Continue -eq "y") {
.\AccountCreation.ps1
}
Else {
Write-Host End of Script
}
