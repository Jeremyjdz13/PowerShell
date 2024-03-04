###############to put suppress credential prompt, remove pound # on 3 lines below and enter credentials
#$User = "maadmin@zulily.com"
#$PWord = ConvertTo-SecureString -String "M9BerettaPistol" -AsPlainText -Force
#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord

###############connect to Exchange Online

#if you use above credentials, add pound# in front of $cred line below.
$cred=get-credential
 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
 
Import-pssession -session $session
