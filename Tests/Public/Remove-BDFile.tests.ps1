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
Describe "Remove-BDFile" {
    Context "Remove BD files piped in" {
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
        }
        it "should cleanup" {
            { $BD | Remove-BDFile } | Should -Not -Throw
            { Get-Item $BD.BicepDeploymentFile -ErrorAction Stop } | Should -Throw
            { Get-Item $BD.BicepModuleFile -ErrorAction Stop } | Should -Throw
            { Get-Item $BD.BicepDeploymentFile -ErrorAction Stop } | Should -Throw
        }
    }
    Context "Convert specific params" {
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
        }
        it "should cleanup" {
            { Remove-BDFile -RemoveFromDirectory (Split-Path $BD.BicepDeploymentFile) } | Should -Not -Throw
            { Get-Item $BD.BicepDeploymentFile -ErrorAction Stop } | Should -Throw
            { Get-Item $BD.BicepModuleFile -ErrorAction Stop } | Should -Throw
            { Get-Item $BD.BicepDeploymentFile -ErrorAction Stop } | Should -Throw
            $nestedPath = Join-Path (Split-Path $BD.BicepDeploymentFile) ".bicep\nested_bicepModule.bicep"
            { Get-Item $nestedPath -ErrorAction Stop } | Should -Not -Throw
        }
    }
}