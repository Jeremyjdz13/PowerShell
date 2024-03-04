Write-Host "What is the username for the user?  " -NoNewline -ForegroundColor Cyan
$User = Read-host 
import-csv c:\Script\ActiveDirectory\AddADGroups\AddADGroups.csv | % {
Add-ADGroupMember -Identity $_.ADGroup -Member $User -Confirm:$False
}