###############to put suppress credential prompt, remove pound # on 3 lines below and enter credentials
#$User = "username@domain.com"
#$PWord = ConvertTo-SecureString -String "password" -AsPlainText -Force
#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord


###############connect to msol

#if you use above credentials, add pound# in front of $cred line below.
$cred = get-credential

#Note When you're prompted, enter your admin credentials.
Connect-MSOLService -Credential $cred