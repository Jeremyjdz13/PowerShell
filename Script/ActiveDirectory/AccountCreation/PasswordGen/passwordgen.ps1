$Cap = "11"
$Number = "12"
$password = ""


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
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap1.ps1
}
Elseif ($Number -eq 1){
$Char = Get-Random -minimum 1 -maximum 9
$Char | out-file -filepath C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter1.ps1
}
$Char = ""
if ($Cap -eq 2){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1
}
Elseif ($Number -eq 2){
$Char = Get-Random -minimum 1 -maximum 9
$Char | out-file -filepath C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt -Append
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}
$Char = ""
if ($Cap -eq 3){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 3){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}
$Char = ""
if ($Cap -eq 4){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 4){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1
}
$Char = ""
if ($Cap -eq 5){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 5){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}
$Char = ""
if ($Cap -eq 6){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 6){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}
$Char = ""
if ($Cap -eq 7){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 7){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}
$Char = ""
if ($Cap -eq 8){
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newCap.ps1

}
Elseif ($Number -eq 8){
$Char = Get-Random -minimum 1 -maximum 9
Add-Content C:\Script\ActiveDirectory\AccountCreation\PasswordGen\Password.txt $Char
}
Else {
C:\Script\ActiveDirectory\AccountCreation\PasswordGen\newLetter.ps1

}