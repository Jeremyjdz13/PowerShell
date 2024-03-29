Import-csv c:\Script\AccountTermDelete\AccountstoDelete.csv | % {
$accountName = $_.AdAccount
# run the WriteDisplayName script which will output account details to a text file 
# file will be located at \\Seafile02\ITHD\TermedUsers
# file will be named after AD User Account
c:\Script\AccountTermDelete\WriteDisplayName.ps1

# Append the current time to the file
get-date >> \\Seafile02\ITHD\TermedUsers\$accountName.txt

# Run the AccountTerm Script
c:\Script\AccountTermDelete\Delete-AccountTerm.ps1
Write-Host "Termination is complete" -foregroundcolor "Green"

}
