#requires -module BicepDev
#requires -Module @{ModuleName="Pester"; ModuleVersion="5.3.1"}
BeforeDiscovery {
    if ($env:Path -notmatch "Bicep CLI") {
        $BicepPath = Resolve-Path $PSScriptRoot\..
        $env:Path += $env:Path + ";$BicepPath"
    }
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_deploy.bicep | Remove-Item
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_throwBuild.bicep | Remove-Item
}
Describe "Convert-BDParam" {
    Context "Convert ALL params" {
        BeforeAll {
            $script:BicepDeploymentFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter deploy.bicep
            $script:BicepModuleFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter appGateway.bicep
            Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
            $Parameters = @{
                BicepDeploymentFile = $BicepDeploymentFile.FullName
                BicepModuleFile     = $BicepModuleFile.FullName
            }
            $script:BD = New-BDFile @Parameters
            $BD | Convert-BDParam
            $script:BuiltModuleContent = Get-Content -Path $BD.BuiltModule | ConvertFrom-Json
        }
        it "should stuff all parameters in bdParams variable" {
            $Params = $BuiltModuleContent.parameters.psobject.properties
            $Params.Name | % {$_ | Should -BeIn $builtmodulecontent.variables.bdparams.psobject.properties.name}
        }
        it "should create bdParams object in output" {
            'bdParams' | Should -BeIn $BuiltModuleContent.Outputs.psobject.properties.name
        }
        it "should cleanup" {
            {$BD | Remove-BDFile} | Should -Not -Throw
        }
    }
    Context "Convert specific params" {
        BeforeAll {
            $script:BicepDeploymentFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter deploy.bicep
            $script:BicepModuleFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter appGateway.bicep
            Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
            $Parameters = @{
                BicepDeploymentFile = $BicepDeploymentFile.FullName
                BicepModuleFile     = $BicepModuleFile.FullName
            }
            $script:BD = New-BDFile @Parameters
            $BD | Convert-BDParam -ParametersToConvert 'sku','capacity','foo'
            $script:BuiltModuleContent = Get-Content -Path $BD.BuiltModule | ConvertFrom-Json
        }
        it "should have sku and capacity in bdParams" {
            'sku','capacity' | Should -BeIn $BuiltModuleContent.variables.bdParams.psobject.properties.name
        }
        it "should not add missing params to bdParams" {
            'foo' | Should -Not -BeIn $BuiltModuleContent.variables.bdParams.psobject.properties.name
        }
        it "should create bdParams object in output" {
            'bdParams' | Should -BeIn $BuiltModuleContent.Outputs.psobject.properties.name
        }
        it "should cleanup" {
            {$BD | Remove-BDFile} | Should -Not -Throw
        }
    }
}