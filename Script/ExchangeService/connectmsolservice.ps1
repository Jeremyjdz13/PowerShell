Write-Output "Connecting to MSolService"

$cred = get-credential "maadmin@zulily.com"
Connect-Msolservice -credential $cred