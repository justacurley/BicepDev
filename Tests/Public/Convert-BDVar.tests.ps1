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
Describe "Convert-BDVar" {
    Context "Convert ALL vars" {
        BeforeAll {
            $appGatewayTestFolder = Get-ChildItem $PSScriptRoot\.. -Recurse -Directory -Filter appGateway
            $script:BicepDeploymentFile = Get-ChildItem $appGatewayTestFolder -Recurse -File -Filter deploy.bicep
            $script:BicepModuleFile = Get-ChildItem $appGatewayTestFolder -Recurse -File -Filter appGateway.bicep
            Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
            $Parameters = @{
                BicepDeploymentFile = $BicepDeploymentFile.FullName
                BicepModuleFile     = $BicepModuleFile.FullName
            }
            $script:BD = New-BDFile @Parameters
            $BD | Convert-BDVar
            $script:BuiltModuleContent = Get-Content -Path $BD.BuiltModule | ConvertFrom-Json
        }

        it "should stuff all variables in bdVars variable" {
            $CopyVars = $BuiltModuleContent.variables.copy
            $CopyVars.Name | % { $_ | Should -BeIn $BuiltModuleContent.variables.bdVars.psobject.properties.name }
        }
        it "should create bdVars object in output" {
            'bdVars' | Should -BeIn $BuiltModuleContent.Outputs.psobject.properties.name
        }
        it "should cleanup" {
            { $BD | Remove-BDFile } | Should -Not -Throw
        }
    }
    Context "Convert specific vars" {
        BeforeAll {
            $appGatewayTestFolder = Get-ChildItem $PSScriptRoot\.. -Recurse -Directory -Filter appGateway
            $script:BicepDeploymentFile = Get-ChildItem $appGatewayTestFolder -Recurse -File -Filter deploy.bicep
            $script:BicepModuleFile = Get-ChildItem $appGatewayTestFolder -Recurse -File -Filter appGateway.bicep
            Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
            $Parameters = @{
                BicepDeploymentFile = $BicepDeploymentFile.FullName
                BicepModuleFile     = $BicepModuleFile.FullName
            }
            $script:BD = New-BDFile @Parameters
            $BD | Convert-BDVar -VariablesToConvert 'diagnosticsMetrics', 'applicationGatewayResourceId', 'foo'
            $script:BuiltModuleContent = Get-Content -Path $BD.BuiltModule | ConvertFrom-Json
        }

        it "should have diagnosticsMetrics and applicationGatewayResourceId in bdVars" {
            'diagnosticsMetrics', 'applicationGatewayResourceId' | Should -BeIn $BuiltModuleContent.variables.bdVars.psobject.properties.name
        }
        it "should not add missing vars to bdVars" {
            'foo' | Should -Not -BeIn $BuiltModuleContent.variables.bdVars.psobject.properties.name
        }
        it "should create bdVars object in output" {
            'bdVars' | Should -BeIn $BuiltModuleContent.Outputs.psobject.properties.name
        }
        it "should cleanup" {
            { $BD | Remove-BDFile } | Should -Not -Throw
        }

    }
}