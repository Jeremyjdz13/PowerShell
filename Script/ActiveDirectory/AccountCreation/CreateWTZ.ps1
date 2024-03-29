$date = Get-Date -format M-d-yyyy

Import-Csv "\\seafile02\ithd\completed newhire sheets\by Jeremy\NewAccountsCSV\NewHire-$date.csv" | % {

$firstname = ."First Name"
$lastname = ."Last Name"
$sam = ."Username"
$password = ."Password"

Function createWordDocument($firstname,$lastname,$sam,$password)
{
     $word = New-Object -ComObject "Word.application"

     $doc = $word.Documents.add("C:\Script\ActiveDirectory\AccountCreation\WTZTest.docx")         
     $FillName=$doc.Bookmarks.Item("FirstName").Range
     $FillName.Text="$FirstName"         
     $FillUser=$doc.Bookmarks.Item("Sam").Range
     $FillUser.Text="$sam"       
     $FillMail=$doc.Bookmarks.Item("Password").Range
     $FillMail.Text="$Password"       
     $file = "\\seafile02\ithd\completed newhire sheets\by Jeremy\2015wtz\'$firstname $lastname-$date.docx'"
     $doc.SaveAs([ref]$file)

     $Word.Quit()


}}