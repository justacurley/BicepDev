function Get-BDOutput {
    <#
    .SYNOPSIS
        Convert JObject, returned from 'Outputs' property of New-AzResourceGroupDeployment, to PSCustomObject.
    .DESCRIPTION
        This is a simple quality of life feature, since the output of New-AzResourceGroupDeployment isn't readily usable in PS
    .EXAMPLE
        PS C:\> New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
        PS C:\> New-AzResourceGroupDeployment -ResourceGroupName 'rg-bdfiles' -TemplateFile $BD.BuiltModule | Get-BDOutput -OutputName $BD.OutputName

        Grabs the appGateway output property and converts it from jqlinq to PSCustomObject
    .INPUTS
        [PSResourceGroupDeployment]
    .OUTPUTS
        [PsCustomObject]
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "The output of New-AzResourceGroupDeployment")]
        [Object]
        $InputObject,
        [Parameter(Mandatory, HelpMessage = "The name of the output variable to return")]
        [string]
        $OutputName
    )
    process {
        $InputObject.outputs.$OutputName.Value.ToString() | ConvertFrom-Json
    }
}