New-ADUser `
-Name ("{0} {1}" -f $_.FirstName, $_.LastName) -SamAccountName $_.ADAccount -GivenName $_.FirstName`
-Description "Verify Contractor" `
-SurName $_.LastName `
-DisplayName ("{0} {1}" -f $_.FirstName, $_.LastName)`
-Department "Finance" `
-Path "OU=users,OU=Consultants,OU=Departments,DC=corp,DC=zulily,DC=com" `
-EmailAddress $_.ExternalEmail -Enabled $True `
-Company "Verify" `
-Title $_.Title `
-Office "" `
-HomePage "hide" `
-Manager "mdesmond" `
-UserPrincipalName ("{0}@{1}" -f $_.ADAccount,"zulily.com") `
-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -ChangePasswordAtLogon $False -PasswordNeverExpires $True -CannotChangePassword $True

$Target = $_.ADAccount
$Source = "t-vcontractor"
# Retrieve group memberships.
$SourceUser = Get-ADUser $Source -Properties memberOf
$TargetUser = Get-ADUser $Target -Properties memberOf

# Hash table of source user groups.
$List = @{}

#Enumerate direct group memberships of source user.
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
