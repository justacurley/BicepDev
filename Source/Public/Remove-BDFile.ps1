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
        TODO search for and remove BDFiles if no parameters are passed in
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .bicep file that calls the bicep module we want to transform")]
        [Alias('Deploy')]
        [System.IO.FileInfo]
        $BicepDeploymentFile,
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .bicep module we want to transform")]
        [Alias('Module')]
        [System.IO.FileInfo]
        $BicepModuleFile,
        [Parameter(ValueFromPipelineByPropertyName, HelpMessage = "The .json file that was built from New-BDFile")]
        [System.IO.FileInfo]
        $BuiltModule
    )
    process {
        $PSBoundParameters.GetEnumerator().ForEach( {
                $_.Value | Remove-Item -Force
            })
    }
}