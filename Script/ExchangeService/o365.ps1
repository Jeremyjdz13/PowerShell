###############to put suppress credential prompt, remove pound # on 3 lines below and enter credentials


#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
###############connect to Exchange Online

#if you use above credentials, add pound# in front of $cred line below.

 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -Authentication Basic -AllowRedirection
 
Import-pssession -session $session


