
Write-Host "Username? " -nonewline -ForegroundColor Green
$UPN = Read-Host

Write-Host "Type the new password.. " -NoNewline -ForegroundColor Green
$NewPass = Read-Host

Set-MsolUserPassword -UserPrincipalName $UPN@zulily.com -NewPassword $NewPass -ForceChangePassword $false