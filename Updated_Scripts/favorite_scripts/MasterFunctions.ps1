#Exchange Master Functions

Function AdminShell
{
runas /u:corp\jtiadmin /netonly mmc
}

Function ES
{
$credential = Get-Credential 

#Microsoft online
Connect-MsolService -Credential $creds

#Azure-AD
Connect-AzureAD -Credential $creds

#SharePoint Online
Connect-SPOService -Url https://zulily365-admin.sharepoint.com -credential $cred

#Exchange Online
Connect-ExchangeOnline -Credential $creds

#Active Directory
Import-Module ActiveDirectory

}# End of ExchangeService


Function ADUC
{
Start-Process “C:\Windows\System32\cmd.exe” -workingdirectory $PSHOME -Credential corp\jtiadmin -ArgumentList “/c dsa.msc”
}

Function SetUserPassword
{
c:\Script\ExchangeService\ChangePassword\Changepassword.ps1
}# End of ForceCP

Function GetMB
{
 c:\Script\ExchangeService\getmailbox.ps1
  }#End of GetMailbox
 
 Function GetMBStats 
 {
 c:\Script\ExchangeService\MailboxInfo\getmailboxstats.ps1
 }#End of Get-MailboxStatistics
 
 Function GetMBRights
 {
 c:\Script\ExchangeService\MailboxInfo\getmailboxperm.ps1
} #End of Get-MailboxPermission 

Function GetUserAccessRights
 {
 c:\Script\ExchangeService\MailboxInfo\Getmailboxaccessrights.ps1
 }

 Function SearchGroup
 {
 c:\Script\ExchangeService\groups\FindGroup\findgroup.ps1
 }#End of FindGroup
 
 Function GetUserDls
 {
 c:\Script\ExchangeService\GetUserDLs.ps1
 }

 Function GetDLMembers
 {
 c:\Script\ExchangeService\GetDLMembers.ps1
 }
 
 Function RemoveUserDLs
 {
 c:\Script\ExchangeService\RemoveUserDLs.ps1
 }

 Function AddGroup ($DGN,$SAN)
 {
 Add-DistributionGroupMember -Identity $DGN -Member $SAN
 } #End of AddGroup

 Function DisableADUser
 {
 c:\Script\ActiveDirectory\AccountTermDisable\Disable-Step1.ps1
 }
 
 Function GetAduser
 {
 c:\Script\ActiveDirectory\AccountLookup\AccountLookupPrompt.ps1
 }
 
 
 