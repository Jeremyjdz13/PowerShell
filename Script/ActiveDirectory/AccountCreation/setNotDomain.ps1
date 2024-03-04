Add-ADGroupMember -Identity "Not Domain Users" -Members $_.ADAccount

$groupsid = (Get-ADGroup "Not Domain Users").sid
[int]$primarygroupid = $groupsid.Value.Substring($groupsid.Value.LastIndexOf("-")+1)
Set-ADUser $_.ADAccount -Replace @{primaryGroupID=$primarygroupid}
Remove-ADGroupMember "Domain Users" $_.ADAccount -Confirm:$false