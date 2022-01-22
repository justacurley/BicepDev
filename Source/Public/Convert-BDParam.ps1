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
        $BuiltModule,
        [Parameter(HelpMessage = "Enter names of parameters to convert to outputs")]
        [alias('Params')]
        [string[]]
        $ParametersToConvert
    )
    process {
        $ModuleFileContent = Get-Content $BuiltModule.FullName -Encoding 'utf8' -Raw | ConvertFrom-Json
        $ModuleFileContent.variables | Add-Member 'bdParams' ([pscustomobject]@{})
        if ($ParametersToConvert) {
           $Parameters = $ModuleFileContent.parameters.psobject.Properties | Where-Object {$_.Name -in $ParametersToConvert}
           Write-Verbose "Found $($Parameters.Count) of $($ParametersToConvert.Count) parameters to convert"
           if ($Parameters.Count -ne $ParametersToConvert.Count) {
            $MissingParams=(($ParametersToConvert | Where-Object {$_ -notin $ModuleFileContent.parameters.psobject.Properties.Name}) -join ', ')
               Write-Warning "Could not find these provided params: $MissingParams"
           }
        }
        else {
            $Parameters = $ModuleFileContent.parameters.psobject.Properties
            Write-Verbose "Found $($Parameters.Count) parameters to convert"
        }
        $Parameters | ForEach-Object {
            $name = $_.name
            $value = "[parameters('{0}')]" -f $name
            $ModuleFileContent.variables.bdParams | Add-Member NoteProperty $name $value -Force
        }
        $ModuleFileContent.outputs | Add-Member NoteProperty "bdParams" @{type = 'object'; value = "[variables('bdParams')]" } -Force
        $ModuleFileContent | ConvertTo-Json -Depth 99 | Out-File $BuiltModule.FullName
    }
}