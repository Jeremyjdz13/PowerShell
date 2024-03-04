## Connections to Exchange OnLine

Import-Module MSOnline
$SecPass = ConvertTo-SecureString "Nurag2Ya!234" -AsPlainText -Force
$O365Cred = New-Object System.Management.Automation.PSCredential ("maadmin@zulily.com", $SecPass)
$O365Session = New-PSSession –ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $O365Cred -Authentication Basic -AllowRedirection
Import-PSSession $O365Session
Connect-MsolService –Credential $O365Cred

