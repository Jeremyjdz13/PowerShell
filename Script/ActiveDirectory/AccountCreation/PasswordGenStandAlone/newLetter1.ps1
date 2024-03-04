$value = Get-Random -minimum 1 -maximum 26
if ($value -eq 1){
$Char = "a"
}
Elseif ($value -eq 2){
$Char = "b"
}
Elseif ($value -eq 3){
$Char = "c"
}
Elseif ($value -eq 4){
$Char = "d"
}
Elseif ($value -eq 5){
$Char = "e"
}
Elseif ($value -eq 6){
$Char = "f"
}
Elseif ($value -eq 7){
$Char = "g"
}
Elseif ($value -eq 8){
$Char = "h"
}
Elseif ($value -eq 9){
$Char = "i"
}
Elseif ($value -eq 10){
$Char = "j"
}
Elseif ($value -eq 11){
$Char = "k"
}
Elseif ($value -eq 12){
$Char = "k"
}
Elseif ($value -eq 13){
$Char = "m"
}
Elseif ($value -eq 14){
$Char = "n"
}
Elseif ($value -eq 15){
$Char = "o"
}
Elseif ($value -eq 16){
$Char = "p"
}
Elseif ($value -eq 17){
$Char = "q"
}
Elseif ($value -eq 18){
$Char = "r"
}
Elseif ($value -eq 19){
$Char = "s"
}
Elseif ($value -eq 20){
$Char = "t"
}
Elseif ($value -eq 21){
$Char = "u"
}
Elseif ($value -eq 22){
$Char = "v"
}
Elseif ($value -eq 23){
$Char = "w"
}
Elseif ($value -eq 24){
$Char = "x"
}
Elseif ($value -eq 25){
$Char = "y"
}
Else{
$Char = "z"
}
$Char | out-file -filepath .\Password.txt