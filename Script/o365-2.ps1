$livecred=get-credential
 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $livecred -Authentication Basic -AllowRedirection
 
Import-pssession -session $session
