# Display the account that was termed in the Console
write-host Terming $accountName -foregroundcolor "yellow"

# Write Date in Description
$Date = Get-Date -Format g

# Hide the user account and clear the manager field
Set-ADUser -Server "corp.zulily.com" $accountName -HomePage 'hide' `
-Description $Date -Add @{msExchHideFromAddressLists="TRUE"} -AccountExpirationDate "07/30/2019"

Set-ADUser -Server "corp.zulily.com" $accountName -Add @{ExtensionAttribute10="NoGalsync"}

"***Disabled Actions Information***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "$AccountName descripton set to $Date."
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "AD Account set to hide for $AccountName."
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "AD Account set to hide from GAL for $AccountName."
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""

# Disable the user account
Disable-ADAccount -Server "corp.zulily.com" -Identity $accountName

Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt "AD Account Disabled for $AccountName."

# Declare a new variable which will include AD User name and retrieves group memberships
$SourceUser = Get-ADUser -Server "corp.zulily.com" $accountName -Properties memberof | Select-Object @{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$'}} 

# Append "Groups removed" to the Termination log file
Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  ""
"***AD Groups Removed***" | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt

# Look Through each group contained in the Source user properties
ForEach ($SourceDN In $SourceUser.memberOf)
{
	# IF the name of the group is not Domain Users:
	# Remove the account from the group
	If ($SourceDN -ne "DomainUsers")
	{
	Remove-ADPrincipalGroupMembership -Server "corp.zulily.com" -Identity $accountName -MemberOf $SourceDN  -Confirm:$false
	
	$SourceDN | Out-File -Append \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt
	}  
}

# Exchange Disable account
C:\Script\ActiveDirectory\AccountTermDisable\Disable-Step2a.ps1

# Run the moveToDisabled script which will:
C:\Script\ActiveDirectory\AccountTermDisable\Disable-Step2b.ps1

