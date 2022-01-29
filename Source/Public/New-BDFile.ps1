function New-BDFile {
    <#
    .SYNOPSIS
        Creates copies of bicep files to be used for testing with this module.
    .DESCRIPTION
        Given a bicep module that you want to develop/test with, and a bicep template file that calls that module,
        this cmdlet should copy both files, build your template, and output an ARM template ready for use by
        the other cmdlets in this module.
    .EXAMPLE
        PS C:\> New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
        PS C:\> $BD | fl
                BicepDeploymentFile : appGateway\ec03_test.bicep
                BicepModuleFile     : appGateway\ec03_appGatewayMicrosoft.bicep
                BuiltModule         : appGateway\ec03_appGatewayMicrosoft.json
                OutputProperty      : appGateway

        Returns a PSObject of files to be used with the other cmdlets in the module
    .OUTPUTS
        [PSCustomObject]
    .NOTES
        TODO Make {$BicepDepFileContent -replace "'.*$ReplaceString'", "'$($NewBicModFile.Name)'"} handle more than 0 path levels
        TODO Write New-BDDeployment controller function
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory, HelpMessage = "The .bicep file that calls the bicep module we want to transform")]
        [ValidateScript( { Test-Path $_ })]
        [Alias('Deploy')]
        [string]
        $BicepDeploymentFile,
        [Parameter(Mandatory, HelpMessage = "The .bicep module we want to transform")]
        [ValidateScript( { Test-Path $_ })]
        [Alias('Module')]
        [string]
        $BicepModuleFile,
        [Parameter(HelpMessage = "Prevent this function from clearing out the resources array from the file we will be injecting output into")]
        [switch]
        $KeepResources
    )
    #Create a new guid and copy the bicep files so we don't go mucking around in the original bicep files
    $GUID = (New-Guid).guid.split('-')[1]
    $NewBicDepName = "$($GUID)_" + (split-path $BicepDeploymentFile -leaf)
    $NewBicModName = "$($GUID)_" + (split-path $BicepModuleFile -leaf)
    $NewBicDepFile = Copy-Item -Path $BicepDeploymentFile -Destination (Join-Path (Split-Path $BicepDeploymentFile) $NewBicDepName) -PassThru -Force
    $NewBicModFile = Copy-Item -Path $BicepModuleFile -Destination (Join-Path (Split-Path $BicepModuleFile) $NewBicModName) -PassThru -Force

    #Replace path to $BicepModuleFile with $NewBicepModFile in $BicepDeploymentFile and build
    $ReplaceString = Split-Path $BicepModuleFile -Leaf
    $BicepDepFileContent = Get-Content $NewBicDepFile -Encoding 'utf8' -Raw
    $BicepDepFileContent = $BicepDepFileContent -replace "'.*$ReplaceString'", "'$($NewBicModFile.Name)'"
    $BicepDepFileContent | Set-Content $NewBicDepFile -Force

    #If build was successful, update the path to $NewBicepModFile with the json file we built and return object for pipeline
    #We have to build twice, the second time with --stdout, becasue something has changed in githubs windows-latest build servers
    # that it no longer allows redirecting output without --stdout
    $BicepBuild = bicep build $NewBicModFile.FullName
    $Warnings = bicep build $NewBicModFile.FullName --stdout 2>&1
    $BuiltModule = Get-Item ([Io.Path]::ChangeExtension($NewBicModFile.FullName, ".json")) -ErrorAction Ignore

    if ($BuiltModule) {
        $OutputName = (Get-Content $NewBicDepFile | Where-Object { $_ -match $NewBicModFile.Name }).Split(' ')[1]
        $NewBicepDepFileContent = (Get-Content $NewBicDepFile -Encoding 'utf8' -Raw)
        $NewBicepDepFileContent = $NewBicepDepFileContent -replace "'$($NewBicModFile.Name)'", "'$($BuiltModule.Name)'"
        $NewBicepDepFileContent += "`n output $OutputName object = $OutputName"
        $NewBicepDepFileContent | Set-Content $NewBicDepFile -Force

        if (-not $KeepResources) {
            $BuiltModuleContent = (Get-Content $BuiltModule -Encoding 'utf8' -Raw) | ConvertFrom-Json
            $BuiltModuleContent.resources = @()
            $BuiltModuleContent | ConvertTo-Json -Depth 99 | Set-Content $BuiltModule -Force
        }
        if (-not $BuiltModuleContent.outputs) {
            $BuiltModuleContent | Add-Member NoteProperty outputs ([PSCustomObject]@{}) -PassThru | ConvertTo-Json -Depth 99 | Set-Content $BuiltModule -Force
        }
        [PSCustomObject]@{
            BicepDeploymentFile = $NewBicDepFile
            BicepModuleFile     = $NewBicModFile
            BuiltModule         = $BuiltModule
            OutputName          = $OutputName
        }
    }
    else {
        if (Test-Path $NewBicDepFile) {
            Remove-BDFile -BicepDeploymentFile $NewBicDepFile
        }
        if (Test-Path $NewBicModFile) {
            Remove-BDfile -BicepModuleFile $NewBicModFile
        }
        if ($Warnings -Match ": Error BCP") {
            throw ($Warnings | Where-Object { $_ -like "*: Error BCP*" })
        }
    }
}