# Import the New Accounts.csv file and run a For Each line code
$date = Get-Date -format M-d-yyyy-hhmm
$gmailOutput = @()

import-csv c:\Script\ActiveDirectory\AccountLookup\NewAccounts.csv | % {
# Record Details in a csv that can be imported into Gmail
$AdAccount = $_.ADAccount
$Email = ("{0}@{1}" -f $_.ADAccount,"zulily.com")
c:\Script\ActiveDirectory\AccountCreation\PasswordGen\passwordgen.ps1
$newPassword = Get-Content c:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt
$password = $newPassword -join ""
$details = @{            
                "First Name"    = $_.FirstName            
                "Last Name"     = $_.LastName                 
                "Email Address" = $Email
				Password     	= $password
				UserName 		= $_.ADAccount
				Title 			= $_.Title
				
	}	
					
$gmailOutput += (New-Object PSObject -Property $details)
		
# Look at role and run the appropriate scripts to create the account
if ($_.Role -eq "Copy") { 
c:\Script\ActiveDirectory\AccountCreation\Roles\ACCopy.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}


ElseIf ($_.Role -eq "CPSup") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCSSupervisor.ps1
# Run the SetNotDomain function which:
# Removes Domain users
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "datavail") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACDatavail.ps1
# Run the SetNotDomain function which:
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Verify") {
C:\Script\ActiveDirectory\AccountCreation\Roles\AVerify.ps1
# Run the SetNotDomain function which:
# Removes Domain users
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "compex") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCompExternal.ps1
# Run the SetNotDomain function which:
# Removes Domain users
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "zkexternal") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACzkexternal.ps1
# Run the SetNotDomain function which:
# Removes Domain users
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Merch") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACMerch.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Planner") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACPlanner.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Planning") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACPlanner.ps1

Write-Host $_.ADAccount created -ForegroundColor yellow
}
ElseIf ($_.Role -eq "GMM") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACGMM.ps1

Write-Host $_.ADAccount created -ForegroundColor yellow
}
ElseIf ($_.Role -eq "Contract Photo") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCPhoto.ps1
# run the SetNotDomain function which:
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "MK") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACMark.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "HR") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACHR.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Recruiter") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACRecruiter.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Recruiting") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACRecruiter.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Studio") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACStudio.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "CS Agent") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCSAgent.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "CS2") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCSAgent2.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "CS Manager") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCSManager.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "fl") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACFL.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "fn") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACFN.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "CS Ops") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCSOps.ps1

Write-Host $_.ADAccount created -ForegroundColor yellow
}
ElseIf ($_.Role -eq "Photographer") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACPhotographer.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Tech Dev") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACTechDev.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Tech PM") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACTechPM.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Tech Manager") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACTechManager.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Photo Editor") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACPhotoEditor.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "Vendor Specialist") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACVS.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "VS") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACVS.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

ElseIf ($_.Role -eq "CPAgent") {
C:\Script\ActiveDirectory\AccountCreation\Roles\ACCPAgent.ps1
# Run the SetNotDomain function which:
# Removes Domain users
C:\Script\ActiveDirectory\AccountCreation\setNotDomain.ps1
Write-Host $_.ADAccount created -ForegroundColor yellow
}

# Explain to the user that one of the roles doesn't match the conditional statme
# Tells the User the Roles that will work 
Else {
Write-Host $_.ADAccount not complete check role: $_.Role -ForegroundColor Cyan
Write-Host 
Write-Host Acceptable roles are: "Copy, Merch, Studio, HR, Marketing, Contract Photo," -ForegroundColor Cyan
Write-Host "CPAgent, CS Agent, CS2, CS Manager, CS Ops, CPSup, Fulfilment, fn, GMM" -ForegroundColor Cyan
Write-Host "Photographer, Photo Editor, Recruiter, Planner, Planning" -ForegroundColor Cyan
Write-Host "Tech Dev, Tech PM, Tech Manager, Vendor Specialist, VS, zkexternal, compex, Verify" -ForegroundColor Cyan

}
}

$gmailOutput | Select-Object -Property "First Name","Last Name",UserName,"Email Address",password | Export-CSV .\NewHire.csv -notype
$gmailOutput | Select-Object -Property "First Name","Last Name",UserName,"Email Address",password | Export-CSV \\seafile02\ithd\"completed newhire sheets"\"by Jeremy"\NewAccountsCSV\NewHire-$date.csv -notype
$gmailOutput | Select-Object -Property "First Name","Last Name",UserName,"Email Address",password,title > \\seafile02\ithd\"completed newhire sheets"\"by Jeremy"\NewAccountsTXT\NewAccounts-$date.txt