# Append Date Separation processed
"***Date Separation Processed***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""
$Date = Get-Date -Format g | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""

# Export Active AD Account Information
"***Active Directory Account Information***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt

$AP = Get-ADUser -Server "corp.zulily.com" $accountName -Properties * | Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}},@{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$','*'}}
$AP | out-file -append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt

$Name = $AP.Name
$UPN = $AP.UserPrincipalName

Try{

"***Exchange Account Information***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
Get-Mailbox $accountName -erroraction:silentlycontinue | `
Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }} | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt

$Data = Get-Mailbox $accountName -erroraction:silentlycontinue
$UPN = $Data.UserPrincipalName

$Msol = Get-Msoluser -UserPrincipalName $UPN | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime
$Msol | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt

# Run the AccountTerm Script
C:\Script\ActiveDirectory\AccountTermDisable\Disable-Step2.ps1
}
catch{
"***No Exchange Account for $Name***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
Write-Host "No Exchange account found for $Name" -ForegroundColor Red

# Run the AccountTerm Script
C:\Script\ActiveDirectory\AccountTermDisable\Disable-Step2.ps1
}

