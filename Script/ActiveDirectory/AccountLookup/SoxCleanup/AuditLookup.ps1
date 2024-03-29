$date = Get-Date -format M-d-yyyy-hhmm
import-csv .\AccountsToLookup.csv | % {
$Lastname = $_.Lastname
$Firstname = $_.Firstname
If($Lastname -and $Firstname)
{
Get-ADUser -Filter {(SurName -eq $Lastname) -and (GivenName -eq $Firstname)} -Properties Samaccountname,givenname,surname,enabled,whenChanged,wWWHomePage,distinguishedName | `
Select-object Samaccountname,givenname,surname,enabled,whenChanged,wWWHomePage,distinguishedName | export-csv -Path .\DisabledUsers-$date.csv -Append
}}



