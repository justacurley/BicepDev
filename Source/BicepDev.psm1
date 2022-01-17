foreach($file in Get-ChildItem $PSScriptRoot -Recurse -Filter *.ps1) {
    . $file
}