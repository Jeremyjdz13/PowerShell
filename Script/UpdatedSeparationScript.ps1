Function Load-Modules{
    #Microsoft online
    Connect-MsolService

    #Azure-AD
    Connect-AzureAD

    #Exchange Online
    Connect-ExchangeOnline

    #Active Directory
    Import-Module ActiveDirectory
}

# Welcome and Warnings
Write-Host "****************************************************************************************************************" -BackgroundColor Black -ForegroundColor Yellow
Write-Host "*                                                                                                              *" -BackgroundColor Black -ForegroundColor Yellow
Write-Host "*   WELCOME TO THE NEW SEPARATION SCRIPT. PLEASE REPORT ANY ERRORS WHEN RUNNING THIS SCRIPT TO YOUR MANAGER.   *" -BackgroundColor Black -ForegroundColor Yellow
Write-Host "*                                                                                                              *" -BackgroundColor Black -ForegroundColor Yellow
Write-Host "****************************************************************************************************************" -BackgroundColor Black -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host "Do you want to load the Microsoft 365 modules?" -ForegroundColor Cyan
Write-Host ""
Write-Host "  * " -NoNewline -ForegroundColor DarkYellow
Write-Host "Azure Active Directory"
Write-Host "  * " -NoNewline -ForegroundColor DarkYellow
Write-Host "Exchange Online"
Write-Host "  * " -NoNewline -ForegroundColor DarkYellow
Write-Host "Microsoft Online Service"
Write-Host "  * " -NoNewline -ForegroundColor DarkYellow
Write-Host "On-Premises Active Directory"
Write-Host ""
Write-Warning 'If you have already loaded these modules in the current PowerShell session, please enter "N"'
Write-Host ""

Do{
    Write-Host 'Please enter "Y" to load the modules or "N" to bypass loading the modules: ' -NoNewline -ForegroundColor Cyan
    $LoadModules = ""
    $LoadModules = Read-Host

    If(($LoadModules -eq "Y") -or ($LoadModules -eq "N")){
        $Response = $true
    }Else{
        $Response = $false
        Write-Host ""
        Write-Host -ForegroundColor Red "Invalid input. Please try again."
        Start-Sleep -Seconds 1
        Write-Host ""
    }
}Until($Response)

If($LoadModules -eq "Y"){
    Load-Modules
}Else{
    Write-Host ""
    Write-Warning "The Microsoft 365 modules are not being loaded."
}

# This "Do" runs the entire separation and is used to loop back if you need to run another.
Do{

    $Date = Get-Date -format M-d-yyyy-hhmm

    # This "Do" is used to loop back if no AD account is found with the username provided.
    Do{
        # Variable that stores the AD username being offboarded and another warning.
        $AccountName = ""
    
        Write-Host ""
        Write-Host ""
        Write-Warning "YOU ARE ABOUT TO DISABLE AN ACTIVE DIRECTORY USER OBJECT. BE ABSOLUTELY CERTAIN YOU HAVE THE CORRECT SEPARATION!"
        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""

        # Prompt for account name and store input into the AccountName Variable
        Write-Host ""
        Write-Host "What is the user's logon name? (Example: q123456) " -NoNewline -ForegroundColor Cyan
        $AccountName = Read-host
        $ErrorActionPreference = "Stop"
        Write-Host ""
    
        # Looks up the user in AD and Display results on screen if user is found.  Ends script if no user is found.  Sets additional Groups, ADUser and DN Variables.
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""
        Write-Host "DATE: " -NoNewline
        Write-Host $Date -BackgroundColor Black -ForegroundColor Green
        Write-Host ""
        Write-Host ""
        Write-Host "Checking Active Directory for " -nonewline
        Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " in domain " -NoNewline
        Write-Host "corp.zulily.com" -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host "."
        Write-Host ""
        Write-Host ""
    
        Try{
            $SecurityGroups = @()
            $ADUser = Get-ADUser -Server corp.zulily.com -Identity $AccountName -Properties *
            $ADUserMemberOf = $ADUser.MemberOf 
            ForEach($Group in $ADUserMemberOf) {
                $SecurityGroups += $Group.split(",")[0].split("=")[1]
            }
            Write-Host "ACTIVE DIRECTORY ACCOUNT INFORMATION"
            Write-Host "____________________________________"
            Get-ADUser -Server corp.zulily.com -Identity $AccountName -Properties * | Select-Object -Property Name, Office, Title, Emailaddress, SamAccountName, whenCreated, LastlogonDate, Department, Enabled, UserPrincipalName, `
            @{name="AD Group Membership";expression={$SecurityGroups -join ', '}}, `
            @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
            @{Name="AccountExpirationDate";Expression={([datetime]::FromFileTime($_.AccountExpirationDate))}}
        
            $DisplayName = $ADUser.GivenName + " " + $ADUser.SurName
            $FindAccount = "Y"
        }
        Catch{
            $FindAccount = "N"
            Write-Host ""
            Write-Host "ERROR: AD Account " -NoNewline -ForegroundColor Red
            Write-Host $AccountName -NoNewline -ForegroundColor White
            Write-Host " does not exist." -ForegroundColor Red
            Write-Host ""
            Write-Host ""
        
            Do{
                $Startover = Read-Host "Would you like to try again? (Y/N)"
                If(($Startover -eq "Y") -or ($Startover -eq "N")){
                    $Valid = $true
                }Else{
                    Write-Host -ForegroundColor Red "Invalid input. Please try again."
                }
            }Until($Valid)
    
            If($Startover -eq "N"){
                Exit
            }
            Cls
        }
    }Until($FindAccount -eq "Y")

    # Checks for an Exchange Mailbox and sets primary SMTP email address variables.  Checks for either zulily com or zulily 365 onmicrosoft com accounts and displays email address.
    Write-Host ""
    Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
    Write-Host ""
    Write-Host ""
    Write-Host "Checking Exchange Online for an email associated with " -NoNewline
    Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green 
    Write-Host ""
    Write-Host ""

    Try{
        $zulily = (Get-EXOMailbox -Identity $AccountName@zulily.com -erroraction:silentlycontinue).primarysmtpaddress
    }Catch{
        $zulily365 = (Get-EXOMailbox -Identity $AccountName@zulily365.onmicrosoft.com -erroraction:silentlycontinue).primarysmtpaddress
    }

    If($zulily){
        Write-Host ""
        Write-Host "Email Address: " -NoNewline
        Write-Host $zulily -BackgroundColor Black -ForegroundColor Green
        Write-Host ""
    }

    If($zulily365){
        Write-Host ""
        Write-Host "Email Address: " -NoNewline
        Write-Host $zulily365 -BackgroundColor Black -ForegroundColor Green
        Write-Host ""
    }

    If(($zulily -eq $null) -and ($zulily365 -eq $null)){
        Write-Host ""
        Write-Host "No email address exists for " -NoNewline
        Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host ""
    }

    # Display the users first and last name specified and prompts to continue
    Write-Host ""
    Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
    Write-Host ""
    Write-Host ""
    Write-Warning "The account to be DISABLED is $DisplayName"
    Write-Host ""
    Write-Host ""
    Write-Host "Do you want to continue (y or n)?  " -NoNewline -ForegroundColor Cyan
    $Continue = Read-host 
    Write-Host ""
    Write-Host ""
    Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
    Write-Host ""

    # Decides if user is valid and to continue and provides warning of title of export. Collects information and exports to \\seafile03\ITHD\TermedUsers.
    If($Continue -eq "y"){
        Write-Host ""
        Write-Host "Collecting Active Directory account information and exporting to " -NoNewline
        Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt " -BackgroundColor Black
        Write-Host ""
        Write-Host ""

        # Collect variable to generate title for text file created and output to \\seafile03\ITHD\TermedUsers.
        "***Date Separation Processed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        $Date | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""

        # Export Active AD Account Information and sets AP, Name and UPN variables for AD attributes collected.  Sets new Groups variable.
        "***Active Directory Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

        $AP = Get-ADUser -Server corp.zulily.com -Identity $AccountName -Properties * | Select-Object -Property Name, Office, Title, Emailaddress, SamAccountName, whenCreated, LastlogonDate, Department, Enabled, UserPrincipalName, `
        @{name="AD Group Membership";expression={$SecurityGroups -join '; '}}, `
        @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
        @{Name="AccountExpirationDate";Expression={([datetime]::FromFileTime($_.AccountExpirationDate))}}

        $AP | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

        $Name = $AP.Name

        Write-Host "Finished writing Active Directory account information to " -NoNewline
        Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt " -BackgroundColor Black
        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""
        Write-Host "Collecting Exchange account information and exporting to " -NoNewline
        Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt " -BackgroundColor Black
        Write-Host ""

        # Checks Microsoft Exchange for mailbox.  Sets Data and Msol Variables. Changes UPN variable. Warning if no mailbox exists
        If($zulily){
        
            "***Exchange Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            Get-EXOMailbox $zulily -erroraction:silentlycontinue | `
            Select-Object @{name="Name";expression={$_.DisplayName}}, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name="EmailAddresses";Expression={ ($_.EmailAddresses | `
            Where-Object {$_ -cmatch "smtp:*"}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }} | `
            Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            $Data = Get-EXOMailbox $zulily -erroraction:silentlycontinue
            $UPN = $Data.UserPrincipalName

            $Msol = Get-Msoluser -UserPrincipalName $UPN | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime
            $Msol | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Write-Host ""
            Write-Host "Finished writing Exchange account information to " -NoNewline
            Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt " -BackgroundColor Black
        }

        # Repeats the process for zulily365 onmicrosoft com account
        If($zulily365){
        
            "***Exchange Account Information***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            Get-EXOMailbox $zulily365 -erroraction:silentlycontinue | `
            Select-Object @{name="Name";expression={$_.DisplayName}}, alias, windowsemailaddress, primarysmtpaddress, whenmailboxcreated, @{Name="EmailAddresses";Expression={ ($_.EmailAddresses | `
            Where-Object {$_ -cmatch "smtp:*"}| ForEach-Object {$_ -replace 'smtp:' }) -join ';' }} | `
            Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            $Data = Get-EXOMailbox $zulily365 -erroraction:silentlycontinue
            $UPN = $Data.UserPrincipalName

            $Msol = Get-Msoluser -UserPrincipalName $UPN | Select SigninName, ImmutableID, *Licenses*, lastdirsynctime
            $Msol | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Write-Host ""
            Write-Host "Finished writing Exchange account information to " -NoNewline
            Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt " -BackgroundColor Black
        
        }

        # If both variables are null, the user does not have a mailbox.
        If(($zulily -eq $null) -and ($zulily365 -eq $null)){
            "***No Exchange Account for $Name***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
        }

        # Collect Pre-Term Data

        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""
        Write-Host "Collecting pre termination data and exporting to " -NoNewline
        Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt" -BackgroundColor Black
        Write-Host ""
        Write-Host ""
        Write-Host "Finished writing pre termination data to " -NoNewline
        Write-Host "$DisplayName-$AccountName-Disabled-$Date.txt" -BackgroundColor Black
        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""
        Write-Host "Disabling account for $DisplayName " -NoNewline
        Write-Host "(" -NoNewline
        Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host ")..."
        Write-Host ""
        Write-Host "Setting " -NoNewline
        Write-Host "Web page" -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to " -NoNewline
        Write-Host "hide" -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host " and " -NoNewline 
        Write-Host 'Expiration Date' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to " -NoNewline
        Write-Host $Date  -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "."
        Write-Host ""
        Write-Host "Setting " -NoNewline
        Write-Host 'Description' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to " -NoNewline
        Write-Host "$Date" -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host " and adding " -NoNewline
        Write-Host 'ExtensionAttribute 10' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to " -NoNewline
        Write-Host "'NoGalsync'" -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "."
        Write-Host ""
        Write-Host "Clearing " -NoNewline
        Write-Host 'Manager' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host ', ' -NoNewline
        Write-Host 'Department' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host ', and ' -NoNewline
        Write-Host 'Extension Attribute 15 fields' -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host "."
        Write-Host ""
        Write-Warning "NoGalsync prevents unwanted contacts syncing with our sibling copmanies."
        Write-Host ""
        Write-Host "Setting " -NoNewline
        Write-Host "msExchHideFromAddressLists" -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to boolean " -NoNewline
        Write-Host "'True'" -NoNewline -BackgroundColor Black -ForegroundColor Yellow
        Write-Host "."
        Write-Host ""
        Write-Host "Resetting domain password for " -NoNewline
        Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " to a random generated password."
        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""

        # Generates a random password and stores it into a variable $RandomPWD

        $Upper = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
        $Lower = "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
        $Number = "1","2","3","4","5","6","7","8","9","0"
        $Char = "!","@","#","$","%","^","&","*","(",")","+"

        $Random = Get-Random -Count 14 -InputObject ($Upper+$Lower+$Number+$Char)
        $RandomPWD = ConvertTo-SecureString ($Random -join("")) -AsPlainText -Force

        # Modifies AD attributes with either null or changed information and disables AD account if not done from Okta.

        Set-ADUser -Server "corp.zulily.com" -Identity $AccountName -HomePage "hide" -Description $Date `
        -Replace @{ msExchHideFromAddressLists="TRUE"; ExtensionAttribute10="NoGalsync"; ExtensionAttribute15="None"} `
        -AccountExpirationDate $Date -Enabled $false -Manager $null -Department $null

        Set-ADAccountPassword -Server "corp.zulily.com" -Identity $AccountName -NewPassword $RandomPWD -Reset

        # ...and then export those details to the output text file
        "***Active Directory changes report***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Descripton set to $Date."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Web page: set to hide."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Extension Attribute 10 set to NoGalsync."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "msExchHideFromAddressLists set to boolean True."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "ExpirationDate set to $Date"
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Enabled set to boolean False."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Manager, Department, and Extension Attribute 15 fields cleared."
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "Password reset to random generated password."

        # Sets a new variable, SourceUser, which includes AD username and retrieves group memberships
        $SourceUser = Get-ADUser -Server corp.zulily.com -Identity $AccountName -Properties memberof | Select-Object @{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$'}} 

        # Appends the AD groups to be removed to the output text file
        Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
        "***AD Groups Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

        # Look through each group contained in the Source user properties (WHERE IS THE SourceDN = variable??)
        Write-Host "Processing " -NoNewline
        Write-Host $AccountName -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host " removal from Security Groups."
        Write-Host ""
        Write-Host ""
        ForEach($SourceDN In $SourceUser.memberOf){
            # IF the name of the group is not Domain Users:
            # Remove the account from the group
            If($SourceDN -ne "DomainUsers"){
                Write-Host "Removing " -NoNewline
                Write-Host $SourceDN -BackgroundColor Black -ForegroundColor Green -NoNewline
                Write-Host " AD group." 
                Remove-ADGroupMember -Server corp.zulily.com -Identity $SourceDN -Members $AccountName -Confirm:$false -ErrorAction:SilentlyContinue
            
                $SourceDN | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            }  
        }

        Write-Host ""
        Write-Host ""
        Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
        Write-Host ""
        Write-Host ""

        # Sets new variables for Mailbox, Distinguished Name, ID, and Filters for only the user who match the Distinguished Name for zulily com email addresses
        If($zulily){
            $MailBox = Get-EXOMailbox $zulily
            $MailBoxDisplayName = $MailBox.DisplayName
            $DistinguishedName = $MailBox.DistinguishedName
            $MailBoxSMTP = $MailBox.PrimarySmtpAddress
            $Filter = "Members -like ""$DistinguishedName"""

            # Gets distribution list memberships and creates variable for each DLs smtp. Gets list of DLs owned
            $DistributionLists = Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress
            $DistributionSMTP = $DistributionLists.PrimarySMTPAddress
            $DistributionListsOwned = Get-DistributionGroup -ResultSize Unlimited -WarningAction 0 | Where-Object {$_.ManagedBy -Contains "$MailBoxDisplayName"}
            $DistributionOwnedSMTP = $DistributionListsOwned.PrimarySMTPAddress

            # Warning of action for removal of distribution lists or warning if user does not have any distribution lists. Pulls data from local file to exported text file.
            Write-Host "Processing " -NoNewline
            Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black -ForegroundColor Green
            Write-Host " removal from Distribution Lists."
            Write-Host ""
            Write-Host ""

            If($DistributionSMTP -eq $null){
                Write-Host "The mailbox " -NoNewline -ForegroundColor Red
                Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black
                Write-Host " isn't associated with any Distribution Lists" -ForegroundColor Red
            }
            Else{
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                "***Exchange Distribution Lists Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                Foreach($Distro in $DistributionSMTP){
                    Write-Host "Removing " -NoNewline
                    Write-Host $Distro -BackgroundColor Black -ForegroundColor Green -NoNewline
                    Write-Host " Distribution List." 
                    Remove-DistributionGroupMember -identity $Distro -Member $zulily -confirm:$false -erroraction:silentlycontinue
                    $Distro | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                }
            }

            # Loops through each DL owned and checks how many owners there are. If they are the only owner it adds a substitute owner and removes them. If not only owner it just removes them.
            If($DistributionOwnedSMTP -eq $null){
                Write-Host "The mailbox " -NoNewline -ForegroundColor Red
                Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black
                Write-Host " is not an owner of any Distribution Lists" -ForegroundColor Red
            }
            Else{
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                "***Exchange Distribution List Ownership Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                ForEach($DistroOwned in $DistributionOwnedSMTP){
                    $DistroGroup = Get-DistributionGroup -Identity $DistroOwned
                    $DLOwners = $DistroGroup.ManagedBy
                    # If they are an owner and are the only owner, add substitute owner and remove them as an owner
                    If($DLOwners.count -lt 2){
                        Set-DistributionGroup $DistroOwned -BypassSecurityGroupManagerCheck -ManagedBy @{Add="s-o365groupmanager@zulily.com"; Remove=$MailBoxSMTP}
                        Write-Host "Removed as owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                        Write-Host ", and " -NoNewline
                        Write-Host "s-o365groupmanager@zulily.com" -NoNewline -BackgroundColor Black -ForegroundColor Green
                        Write-Host " was added as a new owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                        $DistroOwned | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                    }Else{
                        Set-DistributionGroup $DistroOwned -BypassSecurityGroupManagerCheck -ManagedBy @{Remove=$MailBoxSMTP}
                        Write-Host "Removed as owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                        $DistroOwned | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                    }
                }
            }

            Write-Host ""
            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""

            # Removes Unified Group memberships and if they are the only owner, it adds a substitute owner
            # Set Variables used for getting the users Unified Group Memberships and the Unified Group owner substitute if needed
            $UPN2 = (Get-EXOMailbox -Identity $zulily | Get-MsolUser).UserPrincipalName
            $AzureADUser = Get-AzureADUser -ObjectID $UPN2
            $AzureADUserObjectId = $AzureADUser.ObjectId
            $OwnerSubstitution = Get-AzureADUser -ObjectId s-o365groupmanager@zulily.com
            $GroupIDs = Get-AzureADUserMembership -ObjectID $AzureADUserObjectId
            $GroupObjectIDs = $GroupIDs.ObjectID
            $UnifiedGroups = ForEach($group in $GroupObjectIDs){Get-AzureADMSGroup -Id $group | Where-Object {$_.GroupTypes -eq "Unified"}}
            $UnifiedGroupsName = $UnifiedGroups.DisplayName
            $UnifiedGroupsId = $UnifiedGroups.Id

            Write-Host "Processing " -NoNewline
            Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black -ForegroundColor Green
            Write-Host " removal from Unified Groups."
            Write-Host ""
            Write-Host ""

            # Remove from all Unified Groups
            Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
            "***Unified Groups Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            ForEach($UG in $UnifiedGroups){
                Remove-AzureADGroupMember -ObjectId $UG.Id -MemberId $AzureADUserObjectId
                Write-Host "Removed from " -NoNewline
                Write-Host "$($UG.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                $UG.DisplayName | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            }

            # Check to see if the user is an owner of the Unified Group they're a member of
            ForEach($UGroup in $UnifiedGroups){
                $owners = Get-AzureADGroupOwner -ObjectId $UGroup.Id
                # If they are an owner and are the only owner, add substitute owner and remove them as an owner
                If(($owners.UserPrincipalName -contains $UPN2) -and ($owners.count -lt 2)){
                    Add-AzureADGroupOwner -ObjectId $UGroup.Id -RefObjectID $OwnerSubstitution.ObjectID
                    Remove-AzureADGroupOwner -ObjectId $UGroup.Id -OwnerId $AzureADUserObjectId
                    Write-Host "Removed as owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                    Write-Host ", and " -NoNewline
                    Write-Host "$($OwnerSubstitution.UserPrincipalName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                    Write-Host " was added as a new owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                }
                # If they are an owner but there are other owners as well, then remove them as an owner
                If(($owners.UserPrincipalName -contains $UPN2) -and ($owners.count -gt 1)){
                    Remove-AzureADGroupOwner -ObjectId $UGroup.Id -OwnerId $AzureADUserObjectId
                    Write-Host "Removed as owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                }
            }

            # Blocks Exchange and related protocols in O365 and sets SMTP and Object ID variables.  Exports warnings to output text file.        
            $UPN4 = (Get-EXOMailbox -Identity $zulily | Get-MsolUser).UserPrincipalName
            $UserObjectId = (Get-EXOMailbox -Identity $zulily | Get-MsolUser).ObjectId.Guid

            Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
            "***Exchange Blocked Credentials***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Set-MsolUser -UserPrincipalName $UPN4 -BlockCredential $true 

            Get-MsolUser -UserPrincipalName $UPN4 | Select-Object block* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            "***Exchange Protocols disabled***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Write-Host ""
            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Setting new Exchange Mailbox Protocols for " -NoNewline
            Write-Host $UPN4 -BackgroundColor Black -ForegroundColor Green
            Write-Host ""
            Write-Host ""

            Set-CASMailbox $UPN4 -OWAEnabled $False -ImapEnabled $False -MAPIEnabled $False -EwsEnabled:$False -OWAforDevicesEnabled:$False -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Andriod/*"} -EwsAllowOutlook:$False -OutlookMobileEnabled $false -MacOutlookEnabled $false -UniversalOutlookEnabled $false

            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Gathering results for " -NoNewline
            Write-Host $UPN4 -BackgroundColor Black -ForegroundColor Green
            Write-Host ""
            Write-Host ""

            Get-EXOCasMailbox $UPN4 |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Get-EXOCasMailbox $UPN4 |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled

            Write-Host ""
            Write-Host ""

            # Blocks Azure Token and refreshes Azure objects to prevent cloud sign in.
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Processing Azure Token Refresh"
            Write-Host ""
            Write-Host "Removing Azure Registered Devices"
            Write-Host ""
            Write-Host "Disabling Azure User"
            Write-Host ""

            "*** AzureAD refresh token and devices revoked.  User disabled in AzureAD ***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            $ManuallyAssignedCloudApps = (Get-AzureADUserAppRoleAssignment -ObjectId $UserObjectId | Where-Object {$_.PrincipalType -ne "Group"}).ObjectId

            ForEach($CloudApp in $ManuallyAssignedCloudApps){
                Remove-AzureADUserAppRoleAssignment -AppRoleAssignmentId $CloudApp -ObjectId $UserObjectId -erroraction:silentlycontinue
            }

            Revoke-AzureADUserAllRefreshToken -ObjectId $UserObjectId
 
            Set-AzureADUser -ObjectId $UserObjectId -AccountEnabled $false -erroraction:silentlycontinue
 
            Get-AzureADUserRegisteredDevice -ObjectId $UserObjectId | Set-AzureADDevice -AccountEnabled $false
 
            Revoke-AzureADUserAllRefreshToken -ObjectId $UserObjectId

            Get-AzureADUser -ObjectId $UserObjectId | Select-Object Refresh* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Get-AzureADUser -ObjectId $UserObjectId | Select-Object Refresh* 

            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow

        }

        # ...and does the whole process over for zulily365 onmicrosoft accounts.
        If($zulily365){
            $MailBox = Get-EXOMailbox $zulily365
            $MailBoxDisplayName = $MailBox.DisplayName
            $DistinguishedName = $MailBox.DistinguishedName
            $MailBoxSMTP = $MailBox.PrimarySmtpAddress
            $Filter = "Members -like ""$DistinguishedName"""

            # Gets distribution list memberships and creates variable for each DLs smtp
            $DistributionLists = Get-DistributionGroup -ResultSize Unlimited -Filter $Filter -WarningAction 0 | Select-Object PrimarySmtpAddress
            $DistributionSMTP = $DistributionLists.PrimarySMTPAddress
            $DistributionListsOwned = Get-DistributionGroup -ResultSize Unlimited -WarningAction 0 | Where-Object {$_.ManagedBy -Contains "$MailBoxDisplayName"}
            $DistributionOwnedSMTP = $DistributionListsOwned.PrimarySMTPAddress

            # Warning of action for removal of distribution lists or warning if user does not have any distribution lists. Pulls data from local file to exported text file.
            Write-Host "Processing " -NoNewline
            Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black -ForegroundColor Green
            Write-Host " removal from Distribution Lists."
            Write-Host ""
            Write-Host ""

            If($DistributionSMTP -eq $null){
                Write-Host "The mailbox " -NoNewline -ForegroundColor Red
                Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black
                Write-Host " isn't associated with any Distribution Lists" -ForegroundColor Red
            }
            Else{
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                "***Exchange Distribution Lists Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                ForEach($Distro in $DistributionSMTP){
                    Write-Host "Removing " -NoNewline
                    Write-Host $Distro -BackgroundColor Black -ForegroundColor Green -NoNewline
                    Write-Host " Distribution List." 
                    Remove-DistributionGroupMember -identity $Distro -Member $zulily365 -confirm:$false -erroraction:silentlycontinue
                    $Distro | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                }
            }

            # Loops through each DL owned and checks how many owners there are. If they are the only owner it adds a substitute owner and removes them. If not only owner it just removes them.
            If($DistributionOwnedSMTP -eq $null){
                Write-Host "The mailbox " -NoNewline -ForegroundColor Red
                Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black
                Write-Host " is not an owner of any Distribution Lists" -ForegroundColor Red
            }
            Else{
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                "***Exchange Distribution List Ownership Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                ForEach($DistroOwned in $DistributionOwnedSMTP){
                    $DistroGroup = Get-DistributionGroup -Identity $DistroOwned
                    $DLOwners = $DistroGroup.ManagedBy
                    # If they are an owner and are the only owner, add substitute owner and remove them as an owner
                    If($DLOwners.count -lt 2){
                        Set-DistributionGroup $DistroOwned -BypassSecurityGroupManagerCheck -ManagedBy @{Add="s-o365groupmanager@zulily.com"; Remove=$MailBoxSMTP}
                        Write-Host "Removed as owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                        Write-Host ", and " -NoNewline
                        Write-Host "s-o365groupmanager@zulily.com" -NoNewline -BackgroundColor Black -ForegroundColor Green
                        Write-Host " was added as a new owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                        $DistroOwned | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                    }Else{
                        Set-DistributionGroup $DistroOwned -BypassSecurityGroupManagerCheck -ManagedBy @{Remove=$MailBoxSMTP}
                        Write-Host "Removed as owner of " -NoNewline
                        Write-Host "$($DistroGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                        $DistroOwned | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
                    }
                }
            }

            Write-Host ""
            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""

            # Removes Unified Group memberships and if they are the only owner, it adds a substitute owner
            # Set Variables used for getting the users Unified Group Memberships and the Unified Group owner substitute if needed
            $UPN2 = (Get-EXOMailbox -Identity $zulily365 | Get-MsolUser).UserPrincipalName
            $AzureADUser = Get-AzureADUser -ObjectID $UPN2
            $AzureADUserObjectId = $AzureADUser.ObjectId
            $OwnerSubstitution = Get-AzureADUser -ObjectId s-o365groupmanager@zulily.com
            $GroupIDs = Get-AzureADUserMembership -ObjectID $AzureADUserObjectId
            $GroupObjectIDs = $GroupIDs.ObjectID
            $UnifiedGroups = ForEach($group in $GroupObjectIDs){Get-AzureADMSGroup -Id $group | Where-Object {$_.GroupTypes -eq "Unified"}}
            $UnifiedGroupsName = $UnifiedGroups.DisplayName
            $UnifiedGroupsId = $UnifiedGroups.Id

            Write-Host "Processing " -NoNewline
            Write-Host $MailBoxSMTP -NoNewline -BackgroundColor Black -ForegroundColor Green
            Write-Host " removal from Unified Groups."
            Write-Host ""
            Write-Host ""

            # Remove from all Unified Groups
            Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
            "***Unified Groups Removed***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            ForEach($UG in $UnifiedGroups){
                Remove-AzureADGroupMember -ObjectId $UG.Id -MemberId $AzureADUserObjectId
                Write-Host "Removed from " -NoNewline
                Write-Host "$($UG.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                $UG.DisplayName | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt
            }

            # Check to see if the user is an owner of the Unified Group they're a member of
            ForEach($UGroup in $UnifiedGroups){
                $owners = Get-AzureADGroupOwner -ObjectId $UGroup.Id
                # If they are an owner and are the only owner, add substitute owner and remove them as an owner
                If(($owners.UserPrincipalName -contains $UPN2) -and ($owners.count -lt 2)){
                    Add-AzureADGroupOwner -ObjectId $UGroup.Id -RefObjectID $OwnerSubstitution.ObjectID
                    Remove-AzureADGroupOwner -ObjectId $UGroup.Id -OwnerId $AzureADUserObjectId
                    Write-Host "Removed as owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                    Write-Host ", and " -NoNewline
                    Write-Host "$($OwnerSubstitution.UserPrincipalName)" -NoNewline -BackgroundColor Black -ForegroundColor Green
                    Write-Host " was added as a new owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                }
                # If they are an owner but there are other owners as well, then remove them as an owner
                If(($owners.UserPrincipalName -contains $UPN2) -and ($owners.count -gt 1)){
                    Remove-AzureADGroupOwner -ObjectId $UGroup.Id -OwnerId $AzureADUserObjectId
                    Write-Host "Removed as owner of " -NoNewline
                    Write-Host "$($UGroup.DisplayName)" -BackgroundColor Black -ForegroundColor Green
                }
            }

            # Blocks Exchange and related protocols in O365 and sets SMTP and Object ID variables.  Exports warnings to output text file.        
            $UPN4 = (Get-EXOMailbox -Identity $zulily365 | Get-MsolUser).UserPrincipalName
            $UserObjectId = (Get-EXOMailbox -Identity $zulily365 | Get-MsolUser).ObjectId.Guid

            Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
            "***Exchange Blocked Credentials***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Set-MsolUser -UserPrincipalName $UPN4 -BlockCredential $true 

            Get-MsolUser -UserPrincipalName $UPN4 | Select-Object block* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            "***Exchange Protocols disabled***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Write-Host ""
            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Setting new Exchange Mailbox Protocols for " -NoNewline
            Write-Host $UPN4 -BackgroundColor Black -ForegroundColor Green
            Write-Host ""
            Write-Host ""

            Set-CASMailbox $UPN4 -OWAEnabled $False -ImapEnabled $False -MAPIEnabled $False -EwsEnabled:$False -OWAforDevicesEnabled:$False -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Andriod/*"} -EwsAllowOutlook:$False -OutlookMobileEnabled $false -MacOutlookEnabled $false -UniversalOutlookEnabled $false

            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Gathering results for " -NoNewline
            Write-Host $UPN4 -BackgroundColor Black -ForegroundColor Green
            Write-Host ""
            Write-Host ""

            Get-EXOCasMailbox $UPN4 |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Get-EXOCasMailbox $UPN4 |  Select-Object ActiveSyncEnabled, OWAEnabled, PopEnabled, MapiEnabled, SmtpClientAuthenticationDisabled, ImapEnabled, EwsEnabled, EwsBlockList, EwsAllowOutlook, OutlookMobileEnabled, MacOutlookEnabled, OWAforDevicesEnabled, UniversalOutlookEnabled

            Write-Host ""
            Write-Host ""

            # Blocks Azure Token and refreshes Azure objects to prevent cloud sign in.
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow
            Write-Host ""
            Write-Host ""
            Write-Host "Processing Azure Token Refresh"
            Write-Host ""
            Write-Host "Removing Azure Registered Devices"
            Write-Host ""
            Write-Host "Disabling Azure User"
            Write-Host ""

            "*** AzureAD refresh token and devices revoked.  User disabled in AzureAD ***" | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            $ManuallyAssignedCloudApps = (Get-AzureADUserAppRoleAssignment -ObjectId $UserObjectID | Where-Object {$_.PrincipalType -ne "Group"}).ObjectId

            ForEach($CloudApp in $ManuallyAssignedCloudApps){
                Remove-AzureADUserAppRoleAssignment -AppRoleAssignmentId $CloudApp -ObjectId $UserObjectId -erroraction:silentlycontinue
            }

            Revoke-AzureADUserAllRefreshToken -ObjectId $UserObjectId
 
            Set-AzureADUser -ObjectId $UserObjectId -AccountEnabled $false -erroraction:silentlycontinue
 
            Get-AzureADUserRegisteredDevice -ObjectId $UserObjectId | Set-AzureADDevice -AccountEnabled $false
 
            Revoke-AzureADUserAllRefreshToken -ObjectId $UserObjectId

            Get-AzureADUser -ObjectId $UserObjectId | Select-Object Refresh* | Out-File -Append \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt

            Get-AzureADUser -ObjectId $UserObjectId | Select-Object Refresh* 

            Write-Host ""
            Write-Host "****************" -BackgroundColor Black -ForegroundColor Yellow

        }

        # Checks if zulily com account is on Litigation Hold and creates a variable for it.  Sets User variable and moves the AD account to the proper OU.  Adds to output text file.
        If($zulily){
            Write-Host " "
            Write-Warning "Checking $DisplayName for Litigation Holds"
            Write-Host " "

            $UPN5 = (Get-Mailbox $zulily).UserPrincipalName
            $Licenses = (Get-MsolUser -UserPrincipalName $UPN5).Licenses
            $ObjectID = (Get-MsolUser -UserPrincipalName $UPN5).ObjectId.Guid
            $CheckLit = (Get-Mailbox $zulily).LitigationHoldEnabled
        
            If($CheckLit -eq $True){
                Write-Host "User is currently on a Litigation Case, moving to Litigation OU in Active Directory." -ForegroundColor Cyan
            
                $User = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties *
                $UserUPN = $User.UserPrincipalName
                Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"

                Do{
                    Try{
                        $ConfirmOU = Get-ADUser -Filter "SamAccountName -eq '$AccountName'" -SearchBase "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
                    }Catch{
                        $User2 = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                        Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
                    }
                }Until($ConfirmOU)

                # Remove manually assigned licenses except the E3 license
                #ForEach($License in $Licenses){
                    #If(($License.AccountSkuId -ne "zulily365:ENTERPRISEPACK") -and (($License.GroupsAssigningLicense -contains $ObjectID) -or ($License.GroupsAssigningLicense.Count -eq 0))){
                        #Set-MsolUserLicense -UserPrincipalName $UPN5 -RemoveLicenses $License.AccountSkuId
                    #}
                #}

                #Set-MsolUserLicense -UserPrincipalName $UserUPN -AddLicenses "zulily365:ENTERPRISEPACK"

                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "*** $DisplayName was on a Litigation Case, moved to Litigation OU ***"
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "A 'zulily365:ENTERPRISEPACK' (E3) license has been manually assigned due to Litigation Hold status."
                Write-Host "Disable Termination complete." -foregroundcolor Yellow
            }else{

                Write-Host "User is not on a Litigation Case, moving to Disabled Users OU in Active Directory." -ForegroundColor Cyan
            
                $User = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"

                Do{
                    Try{
                        $ConfirmOU = Get-ADUser -Filter "SamAccountName -eq '$AccountName'" -SearchBase "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                    }Catch{
                        $User2 = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                        Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                    }
                }Until($ConfirmOU)

                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "*** $DisplayName was not on a Litigation Case, moved to Disabled Users OU ***"
                Write-Host "Disable Termination complete." -foregroundcolor Yellow
            }
        }

        # ...and does the whole process over for zulily365 onmicrosoft accounts.
        If($zulily365){
            Write-Host " "
            Write-Warning "Checking $DisplayName for Litigation Holds"
            Write-Host " "
        
            $UPN5 = (Get-Mailbox $zulily365).UserPrincipalName
            $Licenses = (Get-MsolUser -UserPrincipalName $UPN5).Licenses
            $ObjectID = (Get-MsolUser -UserPrincipalName $UPN5).ObjectId.Guid
            $CheckLit = (Get-Mailbox $zulily365).LitigationHoldEnabled            
            $CheckLit = (Get-Mailbox $zulily365).LitigationHoldEnabled
        
            If($CheckLit -eq $True){
                Write-Host "User is currently on a Litigation Case, moving to Litigation OU in Active Directory." -ForegroundColor Cyan
            
                $User = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties *
                $UserUPN = $User.UserPrincipalName
                Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"

                Do{
                    Try{
                        $ConfirmOU = Get-ADUser -Filter "SamAccountName -eq '$AccountName'" -SearchBase "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
                    }Catch{
                        $User2 = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                        Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
                    }
                }Until($ConfirmOU)

                # Remove manually assigned licenses except the E3 license
                #ForEach($License in $Licenses){
                    #If(($License.AccountSkuId -ne "zulily365:ENTERPRISEPACK") -and (($License.GroupsAssigningLicense -contains $ObjectID) -or ($License.GroupsAssigningLicense.Count -eq 0))){
                        #Set-MsolUserLicense -UserPrincipalName $UPN5 -RemoveLicenses $License.AccountSkuId
                    #}
                #}

                #Set-MsolUserLicense -UserPrincipalName $UserUPN -AddLicenses "zulily365:ENTERPRISEPACK"

                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "*** $DisplayName was on a Litigation Case, moved to Litigation OU ***"
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  ""
                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "A 'zulily365:ENTERPRISEPACK' (E3) license has been manually assigned due to Litigation Hold status."
                Write-Host "Disable Termination complete." -foregroundcolor Yellow
            }Else{

                Write-Host "User is not on a Litigation Case, moving to Disabled Users OU in Active Directory." -ForegroundColor Cyan
            
                $User = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"

                Do{
                    Try{
                        $ConfirmOU = Get-ADUser -Filter "SamAccountName -eq '$AccountName'" -SearchBase "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                    }Catch{
                        $User2 = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                        Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                    }
                }Until($ConfirmOU)

                Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "*** $DisplayName was not on a Litigation Case, moved to Disabled Users OU ***"
                Write-Host "Disable Termination complete." -foregroundcolor Yellow
            }
        }

        # If the user does not have a mailbox
        If(($zulily -eq $null) -and ($zulily365 -eq $null)){
            Write-Host "Moving $DisplayName to Disabled Users OU in Active Directory." -ForegroundColor Cyan

            $User = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
            Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"

            Do{
                Try{
                    $ConfirmOU = Get-ADUser -Filter "SamAccountName -eq '$AccountName'" -SearchBase "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                }Catch{
                    $User2 = Get-ADUser -Server "corp.zulily.com" -Identity $AccountName -properties distinguishedName
                    Move-ADObject -Server "corp.zulily.com" -Identity $User.distinguishedName -TargetPath "OU=Users,OU=Disabled,DC=corp,DC=zulily,DC=com"
                }
            }Until($ConfirmOU)

            Add-Content \\seafile03\ITHD\TermedUsers\$DisplayName-$AccountName-Disabled-$Date.txt  "*** $DisplayName  moved to Disabled Users OU ***"
            Write-Host "Disable Termination complete." -foregroundcolor Yellow
        }

        $Upper2 = "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
        $Lower2 = "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
        $Number2 = "1","2","3","4","5","6","7","8","9","0"
        $Char2 = "!","@","#","$","%","^","&","*","(",")","+"

        $Random2 = Get-Random -Count 14 -InputObject ($Upper2+$Lower2+$Number2+$Char2)
        $RandomPWD2 = ConvertTo-SecureString ($Random2 -join("")) -AsPlainText -Force

        Set-ADAccountPassword -Server "corp.zulily.com" -Identity $AccountName -NewPassword $RandomPWD2 -Reset

        # Finish
        Write-Host "End of Script."  -ForegroundColor Red
    }

    Do{
        $again = Read-host "Do you want to run another separation? (Y/N)"
        If(($again -eq "Y") -or ($again -eq "N")){
            $go = $true
        }Else{
            Write-Host -ForegroundColor Red "Invalid input. Please try again."
        }
    }Until($go)

}Until($again -eq "N")
