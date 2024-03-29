$date = Get-Date -format M-d-yyyy-hhmm
$users = Import-Csv "c:\Script\CSV-Files\Imported\samAccountName.csv"

Write-Host "Please type the name of the file to save.." -NoNewline -ForegroundColor Cyan
$fileName = Read-Host  

$outFilePath =  "C:\Script\CSV-Files\Exported\SOX\$fileName-AD_Comparison-$Date.csv"
Out-File -FilePath $outFilePath -InputObject "Found in AD, First Name, Last Name, SamAccountName, Location, Department, Title, Manager, When Created, Password Last Set, Last Login Date, Enabled, Description, Jira Ticket, Action Taken, Notes" -Encoding UTF8

# Write-Host $users.name

foreach ($user in $users) {
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $samAccountName = $user.SamAccountName
    # Write-Host $name, $samAccountName

    try {

        $data = Get-ADUser -Identity $samAccountName -Properties * 

        try {
             $manager = (get-aduser (get-aduser $samAccountName -Properties manager).manager).name
             Out-File -FilePath $outFilePath -InputObject "True,$($data.GivenName),$($data.SurName),$($data.samaccountname),$($data.l),$($data.department),$($data.title),$($manager),$($data.whencreated),$($data.passwordlastset),$($data.lastlogondate),$($data.enabled),$($data.description)" -Append
        } catch {
            Out-File -FilePath $outFilePath -InputObject "True,$($data.GivenName),$($data.SurName),$($data.samaccountname),$($data.l),$($data.department),$($data.title),$("No Manager"),$($data.whencreated),$($data.passwordlastset),$($data.lastlogondate),$($data.enabled),$($data.description)" -Append
        }
    }
    catch {
        Write-Host  "${name}${samAccountName} not found in AD"
        Out-File -FilePath $outFilePath -InputObject "False, $($firstName),$($lastName), $($samAccountName)" -Append
    }
}