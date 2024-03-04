$pwCount = ""
$pwCount = Read-Host "How many Passwords do you want?"
$date = Get-Date -format M-d-yyyy-hhmm
$Cap = ""
$Number = ""
$password = ""
"Passwords:" > .\passwordlist$date".txt"
Do {

$Cap = Get-Random -minimum 1 -maximum 9
$Number = Get-Random -minimum 1 -maximum 9
if ($Cap -eq $Number) {
$Cap = Get-Random -minimum 1 -maximum 9
$Number = Get-Random -minimum 1 -maximum 9
}
if ($Cap -eq $Number) {
$Cap = Get-Random -minimum 1 -maximum 9
$Number = Get-Random -minimum 1 -maximum 9
}
if ($Cap -eq $Number) {
$Cap = 4
$Number = 7
}

$Char = ""
# if Capital or Number are the same as the character number post that character in the password else use a Letter 
if ($Cap -eq 1){
.\newCap1.ps1
}
Elseif ($Number -eq 1){
$Char = Get-Random -minimum 1 -maximum 9
$Char | out-file -filepath .\Password.txt
}
Else {
.\newLetter1.ps1
}
$Char = ""
if ($Cap -eq 2){
.\newCap.ps1
}
Elseif ($Number -eq 2){
$Char = Get-Random -minimum 1 -maximum 9
$Char | out-file -filepath .\Password.txt -Append
}
Else {
.\newLetter.ps1

}
$Char = ""
if ($Cap -eq 3){
.\newCap.ps1

}
Elseif ($Number -eq 3){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1

}
$Char = ""
if ($Cap -eq 4){
.\newCap.ps1

}
Elseif ($Number -eq 4){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1
}
$Char = ""
if ($Cap -eq 5){
.\newCap.ps1

}
Elseif ($Number -eq 5){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1

}
$Char = ""
if ($Cap -eq 6){
.\newCap.ps1

}
Elseif ($Number -eq 6){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1

}
$Char = ""
if ($Cap -eq 7){
.\newCap.ps1

}
Elseif ($Number -eq 7){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1

}
$Char = ""
if ($Cap -eq 8){
.\newCap.ps1

}
Elseif ($Number -eq 8){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content .\Password.txt $Char
}
Else {
.\newLetter.ps1

}
$newPassword = Get-Content .\password.txt
$password = $newPassword -join ""
$password >> .\passwordlist$date".txt"
$pwCount = $pwCount - 1
} While ($pwCount -ne 0)

