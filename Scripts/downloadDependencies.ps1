
[CmdletBinding()]
param (
       [Parameter()]
       [String]
       $DownloadUri='https://github.com/Azure/bicep/releases/download/v0.4.1124/bicep-win-x64.exe',
       [Parameter(Mandatory)]
       [String]
       $OutputFolder,
       [Parameter()]
       [String]
       $OutputFileName='bicep.exe'
)
try {
    $FileName = ($DownloadUri.Split('/')[-1])
    Invoke-WebRequest -Uri $DownloadUri -OutFile (Join-Path $OutputFolder $FileName) -ErrorAction Stop | Out-Null
    if ($OutputFileName) {
        Get-Item (Join-Path $OutputFolder $FileName) | Rename-Item -NewName $OutputFileName
    }
}
catch {
    throw $_
}


