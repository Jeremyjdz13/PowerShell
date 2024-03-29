$Date = Get-Date -format M-d-yyyy-hhmm

#Report file path
$OutFilePath =  "C:\Users\jdadmin\Desktop\$Date-AllDelegateAccess.csv" 

#Prepare Report File Headers
Out-File -FilePath $OutFilePath -InputObject "Elevated Account, Accounts Accessed, Level of Access, Deny" -Encoding UTF8

#Export all "User Mailboxes" by PrimarySmtpAddress
Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox"} | Select-Object PrimarySmtpAddress | Export-Csv C:\Users\jdadmin\Desktop\mailbox-upn.csv -NoClobber -NoTypeInformation -Encoding UTF8

#Import PrimarySmtpAddress for -User operator
$Users = Import-Csv C:\Users\jdadmin\Desktop\mailbox-upn.csv

#Import PrimarySmtpAddress for -Identity operator from mailbox-upn.txt in reverse order
$Identities = Import-Csv C:\Users\jdadmin\Desktop\mailbox-upn.csv | Sort-Object -Descending

Write-Host "Processing; takes hours to complete. " -ForegroundColor Green

Foreach ($User in $Users){

    $Use = $User.PrimarySmtpAddress

    Write-Host "Processing: $Use"

    ForEach ($Identity in $Identities){

        $Id = $Identity.PrimarySmtpAddress
        Write-Host "Looking for access rights for $Use of $Id"
        $Results = Get-MailboxPermission -ResultSize Unlimited -Identity $Id -User $Use 

        Out-File -FilePath $OutFilePath -InputObject "$($Results.User),$($Results.Identity),$($Results.AccessRights),$($Results.Deny)" -Encoding UTF8 -append 
       
    }
    
}
