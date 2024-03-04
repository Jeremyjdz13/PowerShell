Write-Host	"Name of group you wish to find it's members? " -NoNewline -ForegroundColor Green
$GPN = Read-Host

$Results = Get-DistributionGroupMember -Identity $GPN 

Foreach ($colItems in $Results)
{
Write-Host "" $colItems.name -ForegroundColor Green
}
