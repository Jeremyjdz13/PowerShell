$Date = Get-Date -format M-d-yyyy-hhmm

# Initialize Variables
$accountName = "" # Stores the AD User Name you want to term

Write-Host "****" -ForegroundColor Yellow
Write-Warning "You are about to disable an Active Directory User Object.  Be absolutely sure you have the correct Separation!"
Write-Host "****" -ForegroundColor Yellow
Write-Host "  "
# Prompt for account name and store input into the $accountName Variable
Write-Host "What is the User's Logon to Disable?" -NoNewline -ForegroundColor Cyan
Write-Host "  " -NoNewline
$accountName = Read-host
$ErrorActionPreference = "Stop"
Write-Host "  "

# Run the AccountLookupPrompt script and Display results on screen or end script
Write-Host "Checking Active Directory for" -nonewline
Write-Host " **$accountName** " -nonewline -ForegroundColor Green 
Write-Host "in corp.zulily.com domain. Date" -NoNewline
Write-Host " **$Date**" -ForegroundColor Green 
Write-Host "  "
Try {
    $Groups = (Get-ADPrincipalGroupMembership -ResourceContextServer "corp.zulily.com" -Identity $accountName | Select-Object -ExpandProperty name) -join ', '
    Get-ADUser -Server corp.zulily.com $accountName -Properties * | `
    Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Description, `
    @{Name="AccountExpirationDate";Expression={([datetime]::FromFileTime($_.AccountExpirationDate))}},  Department,Enabled, `
    @{label='AD Group Membership';expression={$Groups}}, l 

    $ADUser = Get-ADUser -Server corp.zulily.com $accountName -Properties *
    $DN = $ADUser.GivenName + " " + $ADUser.SurName
}
Catch {
    Write-Host "AD Account $accountName does not exist" -foregroundcolor "Red"
Break
}

# Run Exchange Account Check
Write-Host " "
Write-Host "Checking Exchange Online for email associated with" -NoNewline
Write-Host "** $accountName **" -ForegroundColor Green
Write-Host " "

Try{
    $zulily = (Get-EXOMailbox -Identity $accountName@zulily.com -erroraction:silentlycontinue).primarysmtpaddress
    Get-EXOMailbox -identity "$zulily" -erroraction stop| `
    Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
    Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }}
}
catch{
    Try{
        $zulily365 = (Get-EXOMailbox -Identity $accountName@zulily365.onmicrosoft.com -erroraction:silentlycontinue ).primarysmtpaddress
        Get-EXOMailbox -identity "$zulily365" -erroraction stop| `
        Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
        Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }}
    }catch{

        Write-Host " "
        Write-Host "No email address exist for" -NoNewline
        Write-Host " ** $accountName **" -ForegroundColor Green
        Write-Host " "

    }
}


Write-Host $zulily
Write-Host $zulily365

# Display the account name specified and Prompt to continue
Write-Host "Account to be DISABLED is $DN.  Do you want to continue (y or n)?" -nonewline -ForegroundColor Cyan
$Continue = Read-host 

Write-Host " "
Write-Host " "

# Collect Information and export to \\seafile03\ITHD\Termed Users folder.
If ($Continue -eq "y") {
    Write-Host "Collecting Active Directory account information and exporting to $DN-$accountName-Disabled-$Date.txt "
    Write-Host " "
    Write-Host " "
    # Append Date Separation processed
    "***Date Separation Processed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    $Date | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""

    # Export Active AD Account Information
    "***Active Directory Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

    $Groups = (Get-ADPrincipalGroupMembership -ResourceContextServer corp.zulily.com -Identity $accountName | Select-Object -ExpandProperty name) -join ', '

    $AP = Get-ADUser -Server corp.zulily.com $accountName -Properties * | Select-Object -Property Name, Title,Emailaddress, SamAccountName,whenCreated, LastlogonDate, Department,Enabled, `
    @{name="AD Group Membership";expression={$Groups}}, `
    @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
    @{Name="AccountExpirationDate";Expression={([datetime]::FromFileTime($_.AccountExpirationDate))}}, l
    $AP | out-file -append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

    $Name = $AP.Name
    $UPN = $AP.UserPrincipalName

    # Exchange Check and Gather.
    if ($zulily){
        
        "***Exchange Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
        Get-EXOMailbox $zulily -erroraction:silentlycontinue | `
        Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
        Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }} | `
        Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        $Data = Get-EXOMailbox $zulily -erroraction:silentlycontinue
        $UPN = $Data.UserPrincipalName

        $Msol = Get-Msoluser -UserPrincipalName $UPN | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime
        $Msol | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Write-Host " "
        Write-Host "Wrote Exchange Account information to $DN-$accountName-Disabled-$Date.txt "
    }
    elseif($zulily365){
        "***Exchange Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
        Get-EXOMailbox $zulily365 -erroraction:silentlycontinue | `
        Select-Object name, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name=”EmailAddresses”;Expression={ ($_.EmailAddresses | `
        Where-Object {$_ -cmatch “smtp:*”}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }} | `
        Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        $Data = Get-EXOMailbox $zulily365 -erroraction:silentlycontinue
        $UPN = $Data.UserPrincipalName

        $Msol = Get-Msoluser -UserPrincipalName $UPN | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime
        $Msol | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Write-Host " "
        Write-Host "Wrote Exchange Account information to $DN-$accountName-Disabled-$Date.txt "
        
    }Else{
        "***No Exchange Account for $Name***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
    }

    # Collect Pre Term Data

    Write-Host "Collected pre termination data and exported to $DN-$accountName-Disabled-$Date.txt" -ForegroundColor Yellow
    Write-Host " "
    Write-Warning "Disabling $DN ($accountName)..." 
    Write-Host " "

    Write-Host "Setting " -NoNewline
    Write-Host "Web page: "  -foregroundcolor green -NoNewline
    Write-Host "to " -NoNewline
    Write-Host "hide " -ForegroundColor Green -NoNewline
    Write-Host "and " -NoNewline 
    Write-Host 'Expiration Date ' -ForegroundColor Green -NoNewline 
    Write-Host  "to " -NoNewline
    Write-Host $Date -ForegroundColor green -NoNewline
    Write-Host "."
    Write-Host " "

    Write-Host "Setting " -NoNewline
    Write-Host 'Description ' -ForegroundColor Green -NoNewline
    Write-Host  "to " -NoNewline
    Write-Host "$Date " -ForegroundColor Green -NoNewline
    Write-Host "and adding " -NoNewline
    Write-Host 'ExtensionAttribute 10 ' -NoNewline -ForegroundColor Green
    Write-Host "to " -NoNewline
    Write-Host "'NoGalsync'" -ForegroundColor Green -NoNewline
    Write-Host "."
    Write-Host " "
    Write-Warning "NoGalsync prevents unwanted contacts syncing with our sibling copmanies."
    Write-Host " "
    Write-Host "Setting " -NoNewline
    Write-Host "msExchHideFromAddressLists " -ForegroundColor green -NoNewline
    Write-Host "set to boolean " -NoNewline
    Write-Host "'True'" -ForegroundColor Green -NoNewline
    Write-Host "."
    Write-Host " "
    
    # Hide the user account and clear the manager field

    # Get-ADUser -Server "corp.zulily.com" $accountName -Properties (your property name) | ?{$_.(your property name) -eq ""} | %{$_ | Set-ADUser -(your property name) (new property value)}

    Set-ADUser -Server "corp.zulily.com" $accountName -HomePage "hide" -Description $Date -Replace @{ msExchHideFromAddressLists="TRUE"; ExtensionAttribute10="NoGalsync"; ExtensionAttribute15="None"} `
    -AccountExpirationDate $Date -Enabled $false -Manager $null -Department $null

   

    # Export details to txt file
    "***Active Directory changes report***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "Descripton set to $Date."
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "Web page: set to hide."
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "Extension Attribute 10 set to NoGalsync."
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "msExchHideFromAddressLists set to boolean True."
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  " "
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "ExpirationDate set to $Date"
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  " "
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "Enabled set to boolean False."

    # Declare a new variable which will include AD User name and retrieves group memberships
    $SourceUser = Get-ADUser -Server corp.zulily.com $accountName -Properties memberof | Select-Object @{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$'}} 

    # Append "Groups removed" to the Termination log file
    Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  ""
    "***AD Groups Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

    # Look Through each group contained in the Source user properties
    ForEach ($SourceDN In $SourceUser.memberOf)
    {
        # IF the name of the group is not Domain Users:
        # Remove the account from the group
        If ($SourceDN -ne "DomainUsers")
        {
        Write-Host "Removing " -NoNewline
        Write-Host $sourceDN -ForegroundColor Green -NoNewline
        Write-Host " AD group." 
        Remove-ADPrincipalGroupMembership -Server corp.zulily.com -Identity $accountName -MemberOf $SourceDN  -Confirm:$false -ErrorAction:SilentlyContinue
        
        $SourceDN | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
        }  
    }
 
 
    if($zulily){
        $MB = Get-EXOMailbox $zulily
        $DName = $MB.DistinguishedName
        $ID = $MB.Identity
        $Filter = "Members -like ""$DName"""

        #Exports the Group names to be added to the removal section
        Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress | `
        Export-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv -NoTypeInformation

        $DLs = Import-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv
        $DLP = $DLs.PrimarySmtpAddress

        #Removal of all groups for specified user.
        write-host "Processing $ID removal from Distribution List and/or Groups.." -ForegroundColor Green

        If ($DLP -eq $null){
                write-host "$ID isn't associated with any DLs or Groups..." -ForegroundColor Red
            }
        Else {
            "***Exchange Distribution Lists Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
            Foreach($Object in $DLP){
                    Write-Host $Object" "
                    Remove-DistributionGroupMember -identity $Object -Member $zulily -confirm:$false -erroraction:silentlycontinue
                    $Object | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
                }
            }

        #Mobile Device block Settings Exchange 0365
        
     
        $SMTP = (Get-EXOMailbox -Identity $zulily| Get-MsolUser).UserPrincipalName

        $ObjectId = (Get-EXOMailbox -Identity $zulily| Get-MsolUser).ObjectId

        "***Exchange Blocked Credentials***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Set-MsolUser -UserPrincipalName $SMTP -BlockCredential $true 

        Get-MsolUser -UserPrincipalName $SMTP | Select-Object block* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        "***Exchange Protocols disabled***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Write-Host "Processing Exchange Mailbox Protocols for $SMTP" -ForegroundColor Green

        Set-CASMailbox $SMTP -OWAEnabled $False -ImapEnabled $False -MAPIEnabled $False -EwsEnabled:$False -OWAforDevicesEnabled:$False -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Andriod/*"} -EwsAllowOutlook:$False -OutlookMobileEnabled $false -MacOutlookEnabled $false -UniversalOutlookEnabled $false

        Write-Host "Processing results for $SMTP" -ForegroundColor Green

        Get-EXOCASMailbox $SMTP |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Get-EXOCASMailbox $SMTP |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled 

        Write-Host "Processing Azure Token Refresh" -ForegroundColor Green

       "*** AzureAD refresh token Revoked ***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Revoke-AzureADUserAllRefreshToken -ObjectId $ObjectId 

        Get-AzureADUser -ObjectId $ObjectId | Select-Object Refresh* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

        Get-AzureADUser -ObjectId $ObjectId | Select-Object Refresh*

    }
    elseif($zulily365){
        $MB = Get-EXOMailbox $zulily365
        $DName = $MB.DistinguishedName
        $ID = $MB.Identity
        $Filter = "Members -like ""$DName"""

        #Exports the Group names to be added to the removal section
        Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress | `
        Export-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv -NoTypeInformation

        $DLs = Import-Csv c:\Script\CSV-Files\Exported\RemoveUsersDLs.csv
        $DLP = $DLs.PrimarySmtpAddress

        #Removal of all groups for specified user.
        write-host "Processing $ID removal from Distribution List and/or Groups.." -ForegroundColor Green

        If ($DLP -eq $null){
                write-host "$ID isn't associated with any DLs or Groups..." -ForegroundColor Red
            }
        Else {
            "***Exchange Distribution Lists Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
            Foreach($Object in $DLP){
                    Write-Host $Object" "
                    Remove-DistributionGroupMember -identity $Object -Member $zulily365 -confirm:$false -erroraction:silentlycontinue
                    $Object | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
                }
            }

         #Mobile Device block Settings Exchange 0365
        
         $SMTP = (Get-EXOMailbox -Identity $zulily365 | Get-MsolUser).UserPrincipalName
 
         $ObjectId = (Get-EXOMailbox -Identity $zulily365 | Get-MsolUser).ObjectId
 
         "***Exchange Blocked Credentials***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
 
         Set-MsolUser -UserPrincipalName $SMTP -BlockCredential $true 
 
         Get-MsolUser -UserPrincipalName $SMTP | Select-Object block* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt

         "***Exchange Protocols disabled***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
 
         Write-Host "Processing Exchange Mailbox Protocols for $SMTP" -ForegroundColor Green
 
         Set-CASMailbox $SMTP -OWAEnabled $False -ImapEnabled $False -MAPIEnabled $False -EwsEnabled:$False -OWAforDevicesEnabled:$False -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Andriod/*"} -EwsAllowOutlook:$False -OutlookMobileEnabled $false -MacOutlookEnabled $false -UniversalOutlookEnabled $false
 
         Write-Host "Processing results for $SMTP" -ForegroundColor Green
 
         Get-EXOCASMailbox $SMTP |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
 
         Get-EXOCASMailbox $SMTP |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled 
 
         Write-Host "Processing Azure Token Refresh" -ForegroundColor Green
 
        "*** AzureAD refresh token Revoked ***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
 
         Revoke-AzureADUserAllRefreshToken -ObjectId $ObjectId 
 
         Get-AzureADUser -ObjectId $ObjectId | Select-Object Refresh* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt
 
         Get-AzureADUser -ObjectId $ObjectId | Select-Object Refresh*
    }else{

    }


   if($zulily){
    Write-Host " "
    Write-Warning "Checking $DN for Litigation Holds"
    Write-Host " "
    
    $CheckLit = (Get-EXOMailbox $zulily).LitigationHoldEnabled
    
        If ($CheckLit -eq $True){
            Write-Host "User is currently on a Litigation Case, moving to Lititgation OU in Active Directory."
            
            $User = Get-ADUser -Server "corp.zulily.com" -Identity $accountName -properties distinguishedName
            Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
    
            Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "*** $DN was on a Litigation Case, moved to Litigation OU ***"
            Write-Host "Disable Termination complete." -foregroundcolor Yellow
        }
        else{
            Write-Host "Not on Lithold moving $DN to Disabled Users OU Container" -ForegroundColor Cyan

            $User = Get-ADUser -Server "corp.zulily.com" -Identity $accountName -properties distinguishedName
            Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"

            Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "*** $DN  moved to 'Disabled Users' folder ***"
            Write-Host "Disable Termination complete." -foregroundcolor Yellow
        }
   }ElseIf($zulily365){
    Write-Host " "
    Write-Warning "Checking $DN for Litigation Holds"
    Write-Host " "
    
    $CheckLit = (Get-EXOMailbox $zulily365).LitigationHoldEnabled
    
        If ($CheckLit -eq $True){
            Write-Host "User is currently on a Litigation Case, moving to Lititgation OU in Active Directory."
            
            $User = Get-ADUser -Server "corp.zulily.com" -Identity $zulily365 -properties distinguishedName
            Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
    
            Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "*** $DN was on a Litigation Case, moved to Litigation OU ***"
            Write-Host "Disable Termination complete." -foregroundcolor Yellow
        }
        else{
            Write-Host "Not on Lithold moving $DN to Disabled Users OU Container" -ForegroundColor Cyan

            $User = Get-ADUser -Server "corp.zulily.com" -Identity $accountName -properties distinguishedName
            Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"

            Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "*** $DN  moved to 'Disabled Users' folder ***"
            Write-Host "Disable Termination complete." -foregroundcolor Yellow
        }

   } Else {
        Write-Host "Moving $DN to Email Hold OU Container" -ForegroundColor Cyan

        $User = Get-ADUser -Server "corp.zulily.com" -Identity $accountName -properties distinguishedName
        Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Email Hold,DC=corp,DC=zulily,DC=com"

        Add-Content \\seafile03\ITHD\TermedUsers\$DN-$accountName-Disabled-$Date.txt  "*** $DN  moved to 'EmailHold' folder ***"
        Write-Host "Disable Termination complete." -foregroundcolor Yellow
   }
    
}
Else {
Write-Host "End of Script."  -ForegroundColor Red
}


