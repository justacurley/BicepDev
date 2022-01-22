function Remove-BDFile {
    <#
    .SYNOPSIS
        Deletes files created by New-BDFile
    .EXAMPLE
        PS C:\> New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
        PS C:\> $BD | Remove-BDFile

        Returns a PSObject of files to be used with the other cmdlets in the module
    .INPUTS
        (New-BDFile)
    .NOTES
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .bicep file that calls the bicep module we want to transform", ParameterSetName = 'pipe')]
        [Alias('Deploy')]
        [System.IO.FileInfo]
        $BicepDeploymentFile,
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .bicep module we want to transform", ParameterSetName = 'pipe')]
        [Alias('Module')]
        [System.IO.FileInfo]
        $BicepModuleFile,
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .json file that was built from New-BDFile", ParameterSetName = 'pipe')]
        [System.IO.FileInfo]
        $BuiltModule,
        [Parameter(HelpMessage = "Search for and remove files matching files created by New-BDFile", ParameterSetName = 'besteffort')]
        [ValidateScript({Test-Path $_})]
        [string]
        $RemoveFromDirectory
    )
    process {
        if ($RemoveFromDirectory) {
            Write-Verbose "Searching for bicep and json files in $RemoveFromDirectory"
            Get-ChildItem -Path $RemoveFromDirectory -Recurse -File -Include *.bicep,*.json | Where-Object {$_.Name -match "(\d|[a-z]){4}_"} | Foreach-Object {
                Write-Verbose "Attempting to remove $($_.FullName)"
                $_ | Remove-Item -Force
            }
        }
        else {
            $PSBoundParameters.GetEnumerator().ForEach( {
                    Write-Verbose "Attempting to remove $($_.Value.Name)"
                    $_.Value | Remove-Item -Force
                })
        }
    }
}