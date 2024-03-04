# This script is designed to help facilitate accuracy and consistency with zu new hires.
# Get current date.

$Date = Get-Date -format M-d-yyyy-hhmm

Write-Host " "
Write-Host "Current Date: " $Date -ForegroundColor Yellow
Write-Host " "
Write-Host " "
Write-Host "Importing Dayforce user First Name, Last Name, and Email Address." -ForegroundColor Cyan

# Import Data from Dayforce csv and AD Pending Users ou

$DayForceList = Import-Csv  'C:\Script\New-Hire\DF Email Verification.csv' | `
Select-Object "First Name", "Last Name", "Zulily Address" | `
Sort-Object "First Name"

Write-Host " "
Write-Host "Checking import was successful." -ForegroundColor Yellow

If(!$DayForceList){
    Write-Host " "
    Write-Warning "Import Failed!"
    Write-Host " "
} Else {
    Write-Host " "
    Write-Host "Import SUCCESS!!!" -ForegroundColor Green
    Write-Host " "
}


$NewHires = Import-Csv "C:\Script\New-Hire\New-Hire-Import.csv"

ForEach ($NHObject in $NewHires) {

    $GivenName =  $NHObject.FirstName 
    $SurName = $NHObject.LastName
    $Title = $NHObject.JobTitle
    $Department = $NHObject.Department
    $Description = $NHObject.JobTitle
    $Office = $NHObject.Office
    $Manager = $NHObject.Manager
    $Company = $NHObject.Company

    Write-Host " "
    Write-Host "Processing  $($GivenName) $($SurName)" -ForegroundColor Yellow -BackgroundColor black
    Write-Host " "

    $NewHire = Get-Aduser -Filter {GivenName -eq $GivenName -and Surname -eq $SurName} -SearchBase "OU=Pending Users,DC=Corp,DC=zulily,DC=com" -Properties * -ErrorAction:SilentlyContinue | `
    Select-Object GivenName, SurName,  @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
    Description, Title, Office, @{label='Memberof';expression={$_.Memberof -replace '^CN=|,.*$','*'}}, EmailAddress, Company, Department, UserPrincipalName, SamAccountName, DistinguishedName
        
        if($NewHire){

            Write-Host "Found $($GivenName) $($SurName) in Pending Users OU!!" -ForegroundColor Green
            Write-Host " "
        
            Write-Host " ** GivenName:            " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.GivenName -ForegroundColor Green 
        
            Write-Host " ** SurName:              " -ForegroundColor Yellow -NoNewline 
            Write-Host $NewHire.SurName -ForegroundColor Green
        
            Write-Host " ** Email:                " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.EmailAddress
        
            Write-Host " ** AD SamAccountName: " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.SamAccountName

            Write-Host " ** AD UserPrincipalName: " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.UserPrincipalName 
        
            Write-Host " ** Description:          " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Description -ForegroundColor green
        
            Write-Host " ** Job Title:            " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Title -ForegroundColor Green 
        
            Write-Host " ** Manager:              " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Manager -ForegroundColor Green
        
            Write-Host " ** Department:           " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Department -ForegroundColor Green 
        
            Write-Host " ** Company:              " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Company -ForegroundColor Green
        
            Write-Host " ** Office Location:             " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.Office -ForegroundColor Green

            Write-Host " ** DistinguishedName     " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.DistinguishedName -ForegroundColor Green
        
            Write-Host " ** AD Groups:            " -ForegroundColor Yellow -NoNewline
            Write-Host $NewHire.MemberOf -ForegroundColor Green 
            Write-Host " "
        
            #Find O365 Object in Azure AD
            Write-Host "Checking O365 Object.." -ForegroundColor Yellow
            Write-Host " "

            $LicenseEmail = Get-MsolUser -UserPrincipalName $NewHire.UserPrincipalName -ErrorAction: SilentlyContinue | `
            Select-Object isLicensed, Licenses, UserPrincipalName, SignInName, ObjectID
    
            if($LicenseEmail.isLicensed -eq $True){
    
                Write-Host " ** Azure AD Object " -ForegroundColor Cyan -NoNewline
                Write-Host $LicenseEmail.Licenses.AccountSKUid -ForegroundColor Green
                Write-Host " ** isLicensed:       " -ForegroundColor Yellow -NoNewline
                Write-Host $LicenseEmail.isLicensed
                Write-Host " ** UserPrincipalName: " -ForegroundColor Yellow -NoNewline
                Write-Host $LicenseEmail.SignInName
    
            } elseif ($LicenseEmail.isLicensed -eq $False) {
                Write-Host " ** Azure AD Object " -ForegroundColor Cyan -NoNewline
                Write-Host " "
                Write-Host " ** isLicensed:       " -ForegroundColor Yellow -NoNewline
                Write-Host $LicenseEmail.isLicensed
                Write-Host " ** O365 SignIn Address: " -ForegroundColor Yellow -NoNewline
                Write-Host $LicenseEmail.SignInName
    
                
            } 

            #Compare first initial and last name with Dayforce Imported Users.
        
            $FirstLetter = $NewHire.GivenName.substring(0,1)
                
            if($FirstLetter){
                Write-Host " "
                Write-Host "Comparing First Letter " -ForegroundColor Yellow -NoNewline
                Write-Host $FirstLetter -ForegroundColor Green -NoNewline
                Write-Host " of " -ForegroundColor Yellow -NoNewline
                Write-Host $NewHire.GivenName -ForegroundColor Green -NoNewline
                Write-Host " and " -ForegroundColor Yellow -NoNewline
                Write-Host $NewHire.SurName -ForegroundColor Green -NoNewline
                Write-Host " with Dayforce CSV export." -ForegroundColor Yellow
                Write-Host " " 
            
                foreach ($UserObject in $DayForceList){
            
                    $DFFirstLetter = $UserObject."First Name".substring(0,1)
                    
                    if(!$UserObject."Zulily Address"){
                        #Do Nothing if zulily address is blank
                    } elseif (($UserObject."Last Name" -eq $NewHire.SurName) -and ($DFFirstLetter -eq $FirstLetter)) {
            
                        Write-Host "New Hire " -ForegroundColor Yellow -NoNewline
                        Write-Host $NewHire.GivenName $NewHire.SurName -ForegroundColor Green -NoNewline
                        Write-Host " compares to " -ForegroundColor Yellow -NoNewline
                        Write-Host $UserObject."First Name" $UserObject."Last Name" -ForegroundColor Cyan -NoNewline
                        Write-Host " who was assigned this email address: " -ForegroundColor Yellow -NoNewline
                        Write-Host $UserObject."Zulily Address" -ForegroundColor Cyan 
            
                    } 
                    
                }
            
            }

            Write-Host "Would you like to continue processing $($GivenName) $($SurName)? (Y or N)" -ForegroundColor Yellow -BackgroundColor Black -NoNewline

            $Answer = Read-Host

            If($Answer -like "N"){

                Write-Warning "Skipping $($GivenName) $($SurName)"

            }else {

                $EmailAddress = Read-Host "Enter an email address based on compared list from the Dayforce export." 

                Write-Host "Storing email address: $($EmailAddress)." -ForegroundColor Yellow 
                Write-Host " "
                Write-Host "Storing $($EmailAddress) for AzureAD UserPrincipalName"

                function attributes {
                    param (
                        [string]$Attribute1,
                        [string]$Attribute2
                    )
                Write-Host "You entered $($Attribute1) for $($Attribute2)."
                Write-Host "Processing basic AD Groups for $($Attribute1)." -ForegroundColor Green

                }
    
                If ($Department){
        
                    $attribute1 = $Department
                    $attribute2 = "Department"
        
                    If($attribute1 -eq "CR"){
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Creative, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zulily_Creative', 'Zu_Team_Studio', 'O365_standard_license')
        
                    } elseif ($attribute1 -eq "MD") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Merchandising, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zulily_Merchandising','Zu_Team_Merchandising','O365_enterprise_license')
                        
                    } elseif ($attribute1 -eq "HR") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2
                        $DepartmentPath = "Ou=Users, OU=HR, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @( 'Zulily_HR', 'Zu_Team_HR', 'Chrome_WalkMe_Extension', 'payroll', 'zulily_recruiting', 'O365_enterprise_license')
                        
                    } elseif ($attribute1 -eq "IT") {

                        $ADSecurityGroups = @('CyberArk_Users', 'splunk', 'Zu_Team_Tech', 'Zulily_IT', 'O365_Enterprise_license')
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=IT, OU=Departments, DC=Corp, DC=zulily, DC=Com"
                        
                    } elseif ($attribute1 -eq "FL") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Fullfillment, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zulily_Fulfillment', 'zulily_Fulfillment2', 'Zu_Team_Fulfillment_VendorSpecialists', 'VOIS_Access', 'O365_enterprise_license')
        
                    } elseif ($attribute1 -eq "FN") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Finance, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zulily_Finance', 'zulily_Finance2', 'Seafile02_Zebra_Read_Write', 'printer-sap', 'Zu_Team_Finance', 'O365_Enterprise_license')
        
                    } elseif ($attribute1 -eq "LG") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Legal, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @( 'Zulily_Merchandising', 'Zulily_Finance', 'Zulily_Marketing', 'Zulily_Legal',
                        'Legal_Restricted', 'zukeeper_user', 'Zu_Team_Legal', 'printer-legal', 'ZC_Access', 'ZD_Cms',
                        'zuKeeper_blowout_blacklist_edit', 'VOIS_DOC_ADMINS', 'gc-ga-bq-editor',
                        'zuKeeper_compliance_legal_invalidation_edit', 'O365_enterprise_license', 'O365_Flowfree_license',
                        'okta-passport')
        
                    }  elseif ($attribute1 -eq "FC") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Facilities, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zu_Team_Facilities', 'Zulily_Facilities','O365_Standard_license')
        
                    } elseif ($attribute1 -eq "CS") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2
                        $DepartmentPath = "OU=agents, Ou=Users, OU=Customer Service, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @( 'Zulily_CS', 'ZuCare_Users', 'zulily_CS2', 'Zu_Team_CustomerService',
                        'FCUI_Reshipment-Tool', 'Zu_Team_CustomerService_Agents', 'PCI_WFH_Certified_Users ', '', 'O365_Standard_license')

                    #    If($Title -eq "Customer Service Specialist"){
                    #         $DepartmentPath = "OU=agents, Ou=Users, OU=Customer Service, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                    #         $ADSecurityGroups = @( 'Zulily_CS', 'ZuCare_Users', 'zulily_CS2', 'Zu_Team_CustomerService',
                    #         'FCUI_Reshipment-Tool', 'Zu_Team_CustomerService_Agents', 'PCI_WFH_Certified_Users ', '', 'O365_Standard_license')

                    #     }elseif ($Title -eq "Q Agent" -and $Title -like "QVC CSR") {
                    #         $DepartmentPath = "OU=ZuCare Contractors, Ou=Users, OU=Customer Service, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                    #         $ADSecurityGroups = @( 'Zulily_CS', 'ZuCare_Users', 'zulily_CS2', 'Zu_Team_CustomerService',
                    #         'FCUI_Reshipment-Tool', 'Zu_Team_CustomerService_Agents', 'PCI_WFH_Certified_Users ', '', 'O365_Standard_license')
                    #     } 

                    } elseif ($attribute1 -eq "MK") {
        
                        attributes -attribute1 $attribute1 -attribute2 $attribute2

                        $DepartmentPath = "Ou=Users, OU=Marketing, OU=Departments, DC=Corp, DC=zulily, DC=Com"

                        $ADSecurityGroups = @('Zu_Team_Marketing', 'Zulily_Marketing', 'Big_Query_Users', 'Seafile02_Analytics_Read_Write', 'O365_enterprise_license')
        
                    } else {
                        Write-Error "No Department was entered on the spread sheet for $($NewHire.GivenName)$($NewHire.SurName)"
                    }
    
    
                }

                Write-Host " "
                Write-Host "What Exhcange License would you like to assign to $($NewHire.GivenName)$($NewHire.SurName)? (E3 or E1)" -ForegroundColor Yellow -NoNewline

                $ExL = Read-Host

                If ($ExL -eq "E3"){

                    $ExLicense = "zulily365:ENTERPRISEPACK"
                } elseif ($Exl -eq "E1") {

                    $ExLicense = "zulily365:STANDARDPACK"
                }
                function NewHireCheck {
                    param (
                        [string]$Manager,
                        [string]$Title,
                        [string]$Office,
                        [string]$EmailAddress,
                        [string[]]$arrMemberOf,
                        [string]$AzureADUPN,
                        [string]$Department,
                        [string]$Description,
                        [string]$GivenName,
                        [string]$SurName,
                        [string]$ExLicense,
                        [string]$Company
                    )
                    
                    $Description = $Title
                
                    Write-Host "You entered these details for $($GivenName) $($SurName)." -ForegroundColor Green
                    Write-Host "Manager =" $Manager
                    Write-Host "Job Title = " $Title
                    Write-Host "Office = " $Office
                    Write-Host "EmailAddress = " $EmailAddress
                    Write-Host "Azure AD SignInName = " $AzureADUPN
                    Write-Host "You Assigned Exchange License = " $ExLicense
                    Write-Host "Department = " $Department
                    Write-Host "Description = " $Description
                    Write-Host "MemberOf Security Groups: " -ForegroundColor Green
                    Write-Host "Company: " $Company -ForegroundColor Green
                    #Process AD Groups
                    foreach($m in $arrMemberOf){
                    
                        Write-Host $m
                    }
                    
                }

                Write-Host " " 
                NewHireCheck -GivenName $GivenName -SurName $SurName -Title $Title -AzureADUPN $EmailAddress -Manager $Manager -Office $Office -department $Department -description $Description -emailaddress $EmailAddress -arrMemberOf $ADSecurityGroups -ExLicense $ExLicense -Company $Company

                Write-Host " "
                Write-Host "Do all the attributes look correct? (Y or N)" -ForegroundColor Yellow -NoNewline
                
                $AnswerWrite = Read-Host

                If($AnswerWrite -eq "Y"){
                    Write-Host "Modifying New Hire AD Object.."
                    "#####################################################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "###### Date New Hire Processed : $($Date) #####" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    $AdminName = Get-WmiObject -ComputerName $env:computerName -Class Win32_ComputerSystem | Select-Object UserName

                    "###### By UserName $($AdminName.UserName) #######################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "#####################################################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    " " | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    "#####################################################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "####### Before Changes ##############################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    $Groups = (Get-ADPrincipalGroupMembership -Server "Corp.zulily.com" -Identity $NewHire.SamAccountName | Select-Object -ExpandProperty name) -join ', '

                    Get-Aduser -Filter {GivenName -eq $GivenName -and Surname -eq $SurName} -SearchBase "OU=Pending Users,DC=Corp,DC=zulily,DC=com" -Properties * -ErrorAction:SilentlyContinue | `
                    Select-Object GivenName, SurName,  @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
                    Description, Title, Office, @{label='AD Group Membership';expression={$Groups}}, EmailAddress, Company, Department, UserPrincipalName, SamAccountName, DistinguishedName | `
                    Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    Get-MsolUser -UserPrincipalName $NewHire.UserPrincipalName -ErrorAction: SilentlyContinue | `
                    Select-Object isLicensed, Licenses, UserPrincipalName, SignInName, ObjectID | `
                    Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    "###### Entered Changes ##############################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "#####################################################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "                                                " | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "You entered these details for $($GivenName) $($SurName)." | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Manager = $($Manager)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Job Title = $($Title)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Office = $($Office)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "EmailAddress = $($EmailAddress)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Azure AD SignInName = $($EmailAddress)"  | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt$AzureADUPN
                    "Exchange License = $($ExLicense)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Department = $($Department)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "Description = $($Description)" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "MemberOf Security Groups: "  | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    #Process AD Groups
                    foreach($m in $ADSecurityGroups){
                    
                         $m | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    } 

                    " " | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "#####################################################" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                    "###### Modified AD Object Check results #############" | Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    
                    Set-MsolUserPrincipalName -UserPrincipalName $NewHire.UserPrincipalName -NewUserPrincipalName $EmailAddress

                    #Set-AzureADUser -ObjectId $EmailAddress -UsageLocation US

                    Set-ADUser -Identity $NewHire.SamAccountName -Title $Title -Manager $Manager -Department $Department -Office $Office -EmailAddress $EmailAddress -Description $Title -Company $Company

                    foreach($m in $ADSecurityGroups){

                        Add-ADPrincipalGroupMembership -Server corp.zulily.com -Identity $NewHire.SamAccountName -MemberOf $m 
                    } 

                    Move-ADObject -Server "corp.zulily.com" -Identity $NewHire.DistinguishedName -TargetPath $DepartmentPath 

                    Set-MsolUser -UserPrincipalName $EmailAddress -UsageLocation "US"
                    Set-MsolUserLicense -UserPrincipalName $EmailAddress -AddLicenses $ExLicense 

                    $Groups = (Get-ADPrincipalGroupMembership -Server "Corp.zulily.com" -Identity $NewHire.SamAccountName | Select-Object -ExpandProperty name) -join ', '

                    Get-Aduser -Filter {GivenName -eq $GivenName -and Surname -eq $SurName} -SearchBase "DC=Corp,DC=zulily,DC=com" -Properties * -ErrorAction:SilentlyContinue | `
                    Select-Object GivenName, SurName,  @{label='Manager';expression={$_.manager -replace '^CN=|,.*$'}}, `
                    Description, Title, Office, @{label='AD Group Membership';expression={$Groups}}, EmailAddress, Company, Department, UserPrincipalName, SamAccountName, DistinguishedName | `
                    Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt

                    Get-MsolUser -UserPrincipalName $NewHire.UserPrincipalName -ErrorAction: SilentlyContinue | `
                    Select-Object isLicensed, Licenses, UserPrincipalName, SignInName, ObjectID | `
                    Out-File -Append \\seafile02\ITHD\NewHires\$GivenName-$SurName-$Title-$Date.txt
                     
                } Else {
                    Write-Host " "
                    Write-Host "Skipping $($GivenName) $($Surname)..." -ForegroundColor Cyan
                    Write-Host " "
                }
                    
            }
    

        } Else {
            Write-Host "User $($GivenName) $($Surname) doesn't exist; user AD Object isn't in 'Pending Users' OU; user first and last name misspelled..." -ForegroundColor Red -BackgroundColor Black

            Write-Warning "Skipping $($GivenName) $($Surname)..."

            Write-Host " "
        }
        
        
    

}

