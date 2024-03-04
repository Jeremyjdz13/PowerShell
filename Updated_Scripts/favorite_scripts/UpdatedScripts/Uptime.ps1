# import BurntToast module
if (Get-Module -ListAvailable -Name 'BurntToast') {
    Import-Module -Name 'BurntToast'
} else {
    return $false
}

# determine days since last reboot
$os = Get-WmiObject -Namespace 'root\cimv2' -Class 'win32_OperatingSystem'
$LastBoot = $os.converttodatetime($os.lastbootuptime)
$days = ((get-date)-$lastboot).Days

# display reminder if 1+ days since last reboot
if ($days -ge 1) {
    # create text objects for the message content
    $text1 = New-BTText -Content 'Restart Recommended'
    $text2 = New-BTText -Content "It has been $days days since your PC was last rebooted. Zulily IT recommends rebooting once a day for best system performance."

    # assemble the notification object
    $binding1 = New-BTBinding -Children $text1, $text2 -AppLogoOverride $image1
    $visual1 = New-BTVisual -BindingGeneric $binding1
    $content1 = New-BTContent -Visual $visual1 -Audio $audio1 -Scenario IncomingCall

    # submit the notification object to be displayed
    Submit-BTNotification -Content $content1 -UniqueIdentifier "CUBERestart"
}

return $true