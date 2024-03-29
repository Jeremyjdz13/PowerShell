

$comObject = Get-ADcomputer  -searchbase 'CN=Computers,DC=corp,DC=zulily,DC=com'  -Filter '*' | select -Exp name

Foreach ($colobjects in $comObject)
{
If ($colObjects -match "CR-")
{
Get-ADComputer -Identity $colObjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Creative, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Creative" -ForegroundColor Cyan
}
Elseif ($colObjects -match "Edit")
{
Get-ADComputer -Identity $colObjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Creative, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Creative" -ForegroundColor Cyan
}

Elseif ($colObjects -match "Produc")
{
Get-ADComputer -Identity $colObjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Creative, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Creative" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "MD-")
{
Get-ADComputer -Identity $colObjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Merchandising, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Merchandising" -ForegroundColor Cyan
}

elseif ($colObjects -match "fn-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Finance, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Finance" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "cr-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Creative, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Creative" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "cs-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou="Customer Service", ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Customer Service" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "ex-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Executives, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Executive" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "it-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=IT, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Tech" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "fl-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Fullfillment, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Fullfillment" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "hr-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=HR, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Human Resources" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "mk-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Marketing, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Marketing" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "lg-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Legal, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Legal" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "fc-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou=Facilities, ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Facilities" -ForegroundColor Cyan
}

ElseIf ($colObjects -match "bd-")
{
Get-ADComputer -Identity $colobjects | Move-ADObject  -TargetPath 'ou=Computers, ou="Business Development", ou=Departments, dc=corp, dc=zulily, dc=com'
Write-Host "Moving: " -NoNewline -ForegroundColor Cyan
Write-Host ""$colobjects -NoNewline -ForegroundColor Green
Write-Host " to Business Developement" -ForegroundColor Cyan
}



}