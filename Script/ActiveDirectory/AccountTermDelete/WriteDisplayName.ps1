# Pull info using get ADUser function 
# and output Name, Title, Manager to a new text file named after AD Username 
# Save it in the ITHD Termed users folder on network share

$Fullname = Get-ADUser -Identity $accountName -Properties Name,Title,Manager | Select Name,Title,Manager
$Fullname | out-file \\Seafile02\ITHD\TermedUsers\$accountName-Deleted.txt