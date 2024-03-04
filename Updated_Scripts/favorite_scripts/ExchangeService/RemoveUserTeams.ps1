$User = 'User You want to Remove'
$Teams = Get-Team

foreach ($Team in $Teams) {

    $Members = Get-TeamUser -GroupId $Team.GroupId

    If ($Members.User -contains $Owner) {

        Write-Host "Removing $($Owner) from $($Team.Alias)"
        Remove-TeamUser -GroupId $Team.GroupId -User $user #Optional: -Role Owner

    }
    else
    {
        Write-Host "Skip Team:$($Team.Alias) since $($Owner) is not a member"
    }
}