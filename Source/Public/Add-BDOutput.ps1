function Add-BDOutput {
    <#
    .SYNOPSIS
        Add outputs to an arm template created by New-BDFile
    .DESCRIPTION
        Provide Name, Type, Value of the output to have it added.
    .EXAMPLE
        PS C:\> .\appGateway.json | Add-BDOutput -Name 'testString' -Type 'string' -value 'hello'
        Add a string output to appGateway.json
    .EXAMPLE
        PS C:\> $foo.BuiltModule | Add-BDOutput -Name 'testObject' -Type 'object' -value @{'hi'='hello'}
        Add an object output to appGateway.json
    .EXAMPLE
        PS C:\> $foo.BuiltModule | Add-BDOutput -Name 'testArray' -Type 'array' -value @('hi','hello')
        Add an array output to appGateway.json
    .INPUTS
        (New-BDFile).BuiltModule
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "The built bicep template returned from New-BDFile")]
        [System.IO.FileInfo]
        $BuiltModule,
        [parameter(Mandatory, HelpMessage = "Name of the output")]
        [string]
        $Name,
        [parameter(Mandatory, HelpMessage = "[type] of the output")]
        [string]
        $Type,
        [parameter(Mandatory, HelpMessage = "Value of the output")]
        $Value
    )
    process {
        $ModuleFileContent = Get-Content $BuiltModule.FullName -Encoding 'utf8' -Raw | ConvertFrom-Json
        $ModuleFileContent.outputs | Add-Member NoteProperty $Name @{type = $type; value = $Value} -Force
        $ModuleFileContent | ConvertTo-Json -Depth 99 | Out-File $BuiltModule.FullName
    }
}