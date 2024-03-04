$username = Read-Host "USERNAME"
$user = Get-ADUser -Identity $username -Properties *
$usergroups = $user.MemberOf
$displayname = $user.DisplayName

$securitygroups = $usergroups | ForEach{

    $props = @{
      GroupName = (Get-ADGroup $_).Name
      }

      New-Object PsObject -Property $props

}

$securitygroups | Select GroupName | Export-CSV -Path C:\Foundation\ISC\SeaBizOffice\$displayname.csv -NoTypeInformation