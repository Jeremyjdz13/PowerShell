# To the Email Hold Users OU based on separation type 1, 2 or 3.

Write-Host "What was the Separation Type? (1,2,3)" -nonewline -ForegroundColor Cyan
$Type = Read-Host



If ($Type -eq "1"){
Write-Warning "Checking $AccountName for Litigation Holds"

$CheckLit = Get-Mailbox $accountName | Select LitigationHoldEnabled

		If ($CheckLit -eq $true){
		Write-Host "User is currently on a Litigation Case, moving to Lithold folder."
		
		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"

		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** $accountname was on a Litigation Case, moved to Litigation OU ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow
	}
		else{
		Write-Host "Not on Lithold moving $AccountName to Email Hold OU Container" -ForegroundColor Cyan

		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=Email Hold,DC=corp,DC=zulily,DC=com"

		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** $accountname  moved to 'EmailHold' folder ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow
		}
}
ElseIf ($Type -eq "2"){

$CheckLit = Get-Mailbox $accountName | Select LitigationHoldEnabled

 		if ($Checklit -eq $true){
		Write-Host "$accountName is currently on a Litigation Case, moving account to Litigation OU but not setting Lithold duration." -ForegroundColor Cyan

		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
		
		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** $accountname  moved to 'Litigation' folder already on a Litigation Case ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow
	}
	Else{
		Write-Host "Not on Litigation Hold moving Account to Litigation OU Container and setting Lithold for 180 days." -ForegroundColor Cyan

		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=Litigation,OU=Email Hold,DC=corp,DC=zulily,DC=com"
		
		Set-Mailbox -identity $accountName -LitigationHoldEnabled $true -LitigationHoldDuration 180

		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** $accountname  moved to 'Litigation' folder Lithold set to 180 days ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow
		}
}


ElseIf ($Type -eq "3"){

$CheckLit = Get-Mailbox $accountName | Select LitigationHoldEnabled

	If ($CheckLit -eq $true){
	
		Write-Host "$accountName is currently on a Litigation Case, moving account to HR Exectuive OU but not setting Lithold duration." -ForegroundColor Cyan

		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=HR Executives, OU=Email Hold,DC=corp,DC=zulily,DC=com"

		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** AD Account moved to 'HR Executives' folder $accountname & already on a Litigation Case ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow
	}
	Else{
		Write-Host "Not on Litigation Hold moving Account to HR Executive OU Container and setting Lithold for 365 days" -ForegroundColor Cyan

		$User = Get-ADUser -Identity $accountName -properties distinguishedName
		Move-ADObject -Identity $User.distinguishedName -TargetPath "OU=HR Executives, OU=Email Hold,DC=corp,DC=zulily,DC=com"

		Add-Content \\Seafile02\ITHD\TermedUsers\$accountName-Disabled.txt  "*** AD Account moved to 'HR Executives' folder $accountname & Lithold set to 365 days ***"
		Write-Host "Disable Termination complete." -foregroundcolor Yellow

		Set-Mailbox -identity $accountName -LitigationHoldEnabled $true -LitigationHoldDuration 365
		}
		
}
