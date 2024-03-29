$date = Get-Date -format M-d-yyyy-hhmm
import-csv c:\Script\CSV-Files\Imported\GivenNameSurName.csv | % {
$Lastname = $_.Lastname
$Firstname = $_.Firstname
    If($Lastname -and $Firstname)
    {
        Get-ADUser -Filter {(SurName -eq $Lastname) -and (GivenName -eq $Firstname)} -Properties * | `
        Select-Object -Property Name, SurName, GivenName, SamAccountName, UserPrincipalName, Department, Title, `
        @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, whenCreated, PasswordLastSet, LastlogonDate, Enabled, AccountExpirationDate, @{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$','*'}} | `
        Export-csv -Path c:\Script\CSV-Files\Exported\GivenNameSurName\SoxReport-$Date.csv -Append -NoTypeInformation
    } 

}