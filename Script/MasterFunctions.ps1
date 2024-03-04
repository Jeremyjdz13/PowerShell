Function ES
{
$credential = Get-Credential "jtiadmin@zulily.com" 
 
#Azure Active Directory
Connect-AzureAD -Credential $Credential 
 
#Microsoft Teams
#Connect-MicrosoftTeams -Credential $Credential 
 
#Microsoft online
Connect-MsolService -Credential $Credential 
 
#Exchange Online
Connect-ExchangeOnline -Credential $Credential 
 
#SharePoint online
Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
 
Connect-SPOService -Url https://zulily365-admin.sharepoint.com -credential $credential
 
Connect-PnPOnline -Url https://zulily365-admin.sharepoint.com -credential $credential
 
#Skype/Teams
#Import-Module SkypeOnlineConnector
#$sfboSession = New-CsOnlineSession -Credential $credential
#Import-PSSession $sfboSession -DisableNameChecking
 
#Exchange Online
# $exchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
# Import-PSSession $exchangeSession -DisableNameChecking
 
#Security and Compliance
$SccSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.compliance.protection.outlook.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection
Import-PSSession $SccSession -DisableNameChecking
}# End of ExchangeService

Function DisableADUser
{
c:\script\ADAccountDisable.ps1
}
Function NewADUser
{
c:\script\ActiveDirectory\AccountCreation\AccountCreation.ps1
}
Function GetAduser
{
c:\script\ActiveDirectory\AccountLookup\AccountLookupPrompt.ps1
}
Function GetADUserCsv
{
c:\script\ActiveDirectory\AccountLookup\AccountLookupFromCSV.ps1
}

Function adde1license
{
c:\script\365LicenseScripts\adde1license.ps1
}

Function adde3license
{
c:\script\365LicenseScripts\adde3license.ps1
}

Function removee1license
{
c:\script\365LicenseScripts\removee1license.ps1
}

Function removee3license
{
c:\script\365LicenseScripts\removee3license.ps1
}

Function BulkDelete
{
c:\script\ActiveDirectory\AccountTermDelete\Mass-Delete-Termination.ps1
}

Function GetMB
{
c:\script\GetMailbox.ps1
}