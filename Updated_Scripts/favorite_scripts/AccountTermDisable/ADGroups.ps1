$groupname = Read-Host "GROUPNAME"
$group = Get-ADGroup -Identity $groupname -Properties *
$groupgroups = $group.MemberOf
$displayname = $group.Name

$securitygroups = $groupgroups | ForEach{

    $props = @{
      GroupName = (Get-ADGroup $_).Name
      }

      New-Object PsObject -Property $props

}

$securitygroups | Select GroupName | Export-CSV -Path C:\Foundation\NestedGroups\$displayname.csv -NoTypeInformation