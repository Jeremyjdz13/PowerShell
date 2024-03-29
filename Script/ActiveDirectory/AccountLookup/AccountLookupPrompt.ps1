
Write-Host "What is the user's First Name?"  -NoNewline -ForegroundColor Cyan
$GName = Read-host

Write-Host "What is the user's Last Name?"  -NoNewline -ForegroundColor Cyan
$Surname = Read-host

$accountName = (Get-AdUser -Filter {GivenName -like $GName -and Surname -like $Surname}).SamAccountName

if($accountName){
    Write-Host " "
    Write-Host "Found these SamAccountNames" -NoNewline 
    Write-Host " $accountName" -ForegroundColor Green

    foreach($SAN in $accountName){
        $DN = (Get-ADUser -Server "Corp.zulily.com" -Identity $SAN).name
        Try{
            
            $Groups = (Get-ADPrincipalGroupMembership -Server "Corp.zulily.com" -Identity $SAN | Select-Object -ExpandProperty name) -join ', '
            Write-Host "***" -ForegroundColor Green
            Get-ADUser -Server "Corp.zulily.com" -Identity $SAN -Properties * | `
            Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, `
            @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
            @{label='AD Group Membership';expression={$Groups}}, l, `
            @{Name="AccountExpirationDate";Expression={([datetime]::FromFileTime($_.AccountExpirationDate))}}
        
        }
        Catch{
            
        Break
        }
        Try{
            Write-Host "Collecting $DN Exchange Data" -ForegroundColor Green
            Get-Mailbox $SAN -erroraction stop| `
            Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
            Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }}
            Write-Host "***" -ForegroundColor Green
        }
        catch{
            Write-Host " "
            Write-Host "No Exchange data:" -NoNewline
            Write-Host " ** $SAN **" -ForegroundColor Green
            Write-Host " "
            Write-Host "***" -ForegroundColor Green
        }
     
    }

} else {
    Write-Host "$GName $Surname doesn't have an Active Directory Object or the name is misspelled." -ForegroundColor Red
}



    




