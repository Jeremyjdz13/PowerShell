$value = Get-Random -minimum 1 -maximum 26
if ($value -eq 1){
$Char = "A"
}
Elseif ($value -eq 2){
$Char = "B"
}
Elseif ($value -eq 3){
$Char = "C"
}
Elseif ($value -eq 4){
$Char = "D"
}
Elseif ($value -eq 5){
$Char = "E"
}
Elseif ($value -eq 6){
$Char = "F"
}
Elseif ($value -eq 7){
$Char = "G"
}
Elseif ($value -eq 8){
$Char = "H"
}
Elseif ($value -eq 9){
$Char = "J"
}
Elseif ($value -eq 10){
$Char = "J"
}
Elseif ($value -eq 11){
$Char = "K"
}
Elseif ($value -eq 12){
$Char = "L"
}
Elseif ($value -eq 13){
$Char = "M"
}
Elseif ($value -eq 14){
$Char = "N"
}
Elseif ($value -eq 15){
$Char = "N"
}
Elseif ($value -eq 16){
$Char = "P"
}
Elseif ($value -eq 17){
$Char = "Q"
}
Elseif ($value -eq 18){
$Char = "R"
}
Elseif ($value -eq 19){
$Char = "S"
}
Elseif ($value -eq 20){
$Char = "T"
}
Elseif ($value -eq 21){
$Char = "U"
}
Elseif ($value -eq 22){
$Char = "V"
}
Elseif ($value -eq 23){
$Char = "W"
}
Elseif ($value -eq 24){
$Char = "X"
}
Elseif ($value -eq 25){
$Char = "Y"
}
Else{
$Char = "Z"
}
$Char | out-file -filepath .\Password.txt