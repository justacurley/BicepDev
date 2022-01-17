
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
    $Destination = (Join-Path $OutputFolder $FileName)
    Invoke-WebRequest -Uri $DownloadUri -OutFile $Destination -ErrorAction Stop | Out-Null
    if ($OutputFileName) {
        Get-Item $Destination | Rename-Item -NewName $OutputFileName
        Write-Information "$OutputFileName downloaded to $OutputFolder" -InformationAction Continue
    }
}
catch {
    throw $_
}


