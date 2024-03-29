# Display the account that was termed in the Console
write-host Deleting $accountName -foregroundcolor "yellow"

# Declare a new variable which will include AD User name and retrieves group memberships
$SourceUser = Get-ADUser $accountName -Properties memberOf

# Append "Groups removed" to the Termination log file
"Groups" >> \\Seafile02\ITHD\TermedUsers\$accountName-Deleted.txt

# Look Through each group contained in the Source user properties
ForEach ($SourceDN In $SourceUser.memberOf)
{
	# IF the name of the group is not Domain Users:
	# Remove the account from the group
	# Log the group name
    If ($SourceDN -ne "DomainUsers")
	{
	$SourceDN >> \\Seafile02\ITHD\TermedUsers\$accountName-Deleted.txt
	}
    
	
}


# Delete the user account
Remove-ADUser -Identity $accountName -Confirm:$false