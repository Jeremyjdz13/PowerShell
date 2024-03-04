
Write-Host "Type the computer name to add to the pgp_users group. " -NoNewline -ForegroundColor Cyan

$computer = Read-Host

Add-ADGroupMember "pgp_users" -Members "$computer$"

Write-Host "Computer object " -NoNewline -ForegroundColor Cyan
Write-Host "$computer " -NoNewline -ForegroundColor Yellow
Write-Host "has been added to the PGP_Users AD group." -ForegroundColor Cyan





