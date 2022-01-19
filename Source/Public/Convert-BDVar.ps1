function Convert-BDVar {
    <#
    .SYNOPSIS
        Converts all variables in an arm template to ouputs
    .DESCRIPTION
        This cmdlet adds two outputs to the $BuiltModule arm template: 'bdCopyVars' & 'bdVariables'

        When bicep builds to an ARM template, all copy loop array variables are added to a single variable named 'copy'. We use
        similar logic here to take all of those copy loops inside the copy var, and put them in a new ARM object variable, which
        we use to make a more simple output in bdCopyVars output. The pattern follows for all other variables, which are outputted
        in bdVariables.
    .EXAMPLE
        PS C:\> New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
        PS C:\> $BD.BuiltModule | Convert-BDVar

        Add all variables in $BD.BuiltModule to new variables (bdVariables, bdCopyVars), and output those variables in the arm template.
    .INPUTS
        (New-BDFile).BuiltModule
    .NOTES
        TODO optionally convert specific vars to outputs instead of all of them
        TODO all template variables should go into ONE output variable instead of split out as it is now
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, HelpMessage = "The built bicep template returned from New-BDFile")]
        [System.IO.FileInfo]
        $BuiltModule
    )
    process {
        $ModuleFileContent = Get-Content $BuiltModule.FullName -Encoding 'utf8' -Raw | ConvertFrom-Json
        $ModuleFileContent.variables | Add-Member 'bdVariables' ([pscustomobject]@{})
        $ModuleFileContent.variables | Add-Member 'bdCopyVars' ([pscustomobject]@{})
        $ModuleFileContent.variables.psobject.Properties | ForEach-Object {
            $name = $_.name
            $value = $_.value
            if ($name -notin @('copy','bdVariables','bdCopyVars')) {
                $ModuleFileContent.variables.bdVariables | Add-Member NoteProperty $name $PSItem.Value -Force
            }
            elseif ($name -eq 'copy') {
                foreach ($copyArray in $value) {
                    $ModuleFileContent.variables.bdCopyVars | Add-Member NoteProperty $copyArray.Name ("[variables('{0}')]" -f $copyArray.name) -Force
                }
            }
        }
        $ModuleFileContent.outputs | Add-Member NoteProperty "bdCopyVars" @{type = 'object'; value = "[variables('bdCopyVars')]" } -Force
        $ModuleFileContent.outputs | Add-Member NoteProperty "bdVariables" @{type = 'object'; value = "[variables('bdVariables')]"} -Force
        $ModuleFileContent | ConvertTo-Json -Depth 99 | Out-File $BuiltModule.FullName
    }
}