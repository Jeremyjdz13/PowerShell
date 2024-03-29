# Run the New Ad User function to create the account and add all the Basic info
New-ADUser `
-Name ("{0} {1}" -f $_.FirstName, $_.LastName) -SamAccountName $_.ADAccount -GivenName $_.FirstName`
-Description $_.Title `
-SurName $_.LastName `
-DisplayName ("{0} {1}" -f $_.FirstName, $_.LastName)`
-Department "Creative" `
-Path "OU=Copy,OU=Users,OU=Creative,OU=Departments,DC=corp,DC=zulily,DC=com" `
-EmailAddress ("{0}@{1}" -f $_.ADAccount,"zulily.com") -Enabled $True `
-Company "Zulily" `
-Title $_.Title `
-Office "Seattle" `
-UserPrincipalName ("{0}@{1}" -f $_.ADAccount,"corp.zulily.com") `
-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -ChangePasswordAtLogon $False

# Saves the user name as $target sets $Source to the copy Template account
$Target = $_.ADAccount
$Source = "t-studio"
# Retrieve group memberships.
$SourceUser = Get-ADUser $Source -Properties memberOf
$TargetUser = Get-ADUser $Target -Properties memberOf

# Hash table of source user groups.
$List = @{}

# Adds all groups the $List Hash Table
# Looks at each group the $SourceUser is a member of
# Looks to see if the Target User is a member of that group
# If the Target User isn't a member add the group

ForEach ($SourceDN In $SourceUser.memberOf)
{
    # Add this group to hash table.
    $List.Add($SourceDN, $True)
    # Bind to group object.
    $SourceGroup = [ADSI]"LDAP://$SourceDN"
    # Check if target user is already a member of this group.
    If ($SourceGroup.IsMember("LDAP://" + $TargetUser.distinguishedName) -eq $False)
    {
        # Add the target user to this group.
        Add-ADGroupMember -Identity $SourceDN -Members $Target
    }
}

Try{
Set-AdUser $Target -Manager $_.Manager
}
Catch {
Write-Host "Manager Does not exist" -foregroundcolor "Red"
Write-Host "Fix manager in AD Profile for "$Target -foregroundcolor "Yellow"
}

Set-AdUser $Target -Replace @{otherMailbox="1"}