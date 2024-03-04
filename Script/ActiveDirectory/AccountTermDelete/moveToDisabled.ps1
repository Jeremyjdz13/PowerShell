# Store the Distinguished Name into a variable to be used later
# Run the Move-ADObject function which will move the object based on Distinguished name
# To the Disabled Users OU

$User = Get-ADUser -Identity $accountName -properties distinguishedName
Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
