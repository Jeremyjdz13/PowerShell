New-ADUser `
-Name ("{0} {1}" -f $_.FirstName, $_.LastName) -SamAccountName $_.ADAccount -GivenName $_.FirstName`
-Description "Center Partners" `
-SurName $_.LastName `
-DisplayName ("{0} {1}" -f $_.FirstName, $_.LastName)`
-Department "Customer Service" `
-Path "OU=ZuCare Contractors,OU=users,OU=Customer Service,OU=Departments,DC=corp,DC=zulily,DC=com" `
-EmailAddress $_.ExternalEmail -Enabled $True `
-Company $_.Company`
-Title $_.Title `
-Manager "c-dwallace" `
-UserPrincipalName ("{0}@{1}" -f $_.ADAccount,"zulily.com") `
-AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -ChangePasswordAtLogon $False -PasswordNeverExpires $True -CannotChangePassword $True

$Target = $_.ADAccount
$Source = "t-cpsupervisor"
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
