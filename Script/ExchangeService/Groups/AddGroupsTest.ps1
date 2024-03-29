Write-Host "What is the Username of the person you need to add groups? " -NoNewline -ForegroundColor Green
$UPN = Read-Host

Write-Host "How many additional groups do you need to enter? " -NoNewline -ForegroundColor Green
Write-Host "Warning Maximum is set to 10!  " -nonewline -ForegroundColor Yello
$Glist = Read-Host

If ($Glist -eq "1")
{
Write-Host "Type group name and press Enter. " -NoNewline -ForegroundColor Green
$GN1 = Read-Host
Add-DistributionGroupMember -Identity $GN1 -Member $UPN -ErrorVariable err -erroraction silentlycontinue

  If ($err -eq $True){
	Write-Host "You may have misspelled group" -NoNewline -ForegroundColor Green
	Write-Host " '$GN1' " -NoNewline -ForegroundColor Red
	Write-Host "try looking up the group using the " -NoNewline -ForegroundColor Green
	Write-Host "'findgroup' " -NoNewline -ForegroundColor Magenta
	Write-Host "function to look up groups that contain the letters you entered."  -ForegroundColor Green
	}
	Else{
	Write-Host "$UPN " -NoNewline -ForegroundColor Yellow
	Write-Host "added to " -NoNewline -ForegroundColor green
	Write-Host "$GN1" -NoNewline -ForegroundColor Magenta
	Write-Host "." -ForegroundColor Green
	}
 }


