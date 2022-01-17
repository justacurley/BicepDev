#requires -module BicepDev
#requires -Module @{ModuleName="Pester"; ModuleVersion="5.3.1"}
BeforeDiscovery {
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_deploy.bicep | Remove-Item
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_throwBuild.bicep | Remove-Item
}
Describe "Convert-BDVar" {
    BeforeAll {
        $script:BicepDeploymentFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter deploy.bicep
        $script:BicepModuleFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter appGateway.bicep
        Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
        $Parameters = @{
            BicepDeploymentFile = $BicepDeploymentFile.FullName
            BicepModuleFile     = $BicepModuleFile.FullName
        }
        $script:BD = New-BDFile @Parameters
    }
    it "should convert all variables to outputs" {
        {$BD | Remove-BDFile} | Should -Not -Throw
    }
}