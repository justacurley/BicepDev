function Convert-BDParam {
    <#
    .SYNOPSIS
        Converts all parameters in an arm template to ouputs
    .EXAMPLE
        PS C:\> New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
        PS C:\> $BD.BuiltModule | Convert-BDParam

        Convert all parameters in $BD.BuiltModule to outputs, with a prefix of 'pars_' as the name.
    .INPUTS
        (New-BDFile).BuiltModule
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "The built bicep template returned from New-BDFile")]
        [System.IO.FileInfo]
        $BuiltModule
        # TODO optionally convert specific params to outputs instead of all of them
        # [Parameter(HelpMessage = "Enter names of parameters to convert to outputs")]
        # [alias('Params')]
        # [string[]]
        # $ParametersToConvert
    )
    $ModuleFileContent = Get-Content $BuiltModule.FullName -Encoding 'utf8' -Raw | ConvertFrom-Json
    $ModuleFileContent.parameters.psobject.Properties | foreach {
        $name = $_.name
        $value = "[parameters('{0}')]" -f $name
        $ModuleFileContent.outputs | Add-Member NoteProperty "pars_$name" @{type = $PSItem.Value.type; value = $value } -Force
    }
    $ModuleFileContent | ConvertTo-Json -Depth 99 | Out-File $BuiltModule.FullName
}