#requires -module BicepDev
#requires -Module @{ModuleName="Pester"; ModuleVersion="5.3.1"}
BeforeDiscovery {
    if (($env:Path -notmatch "Bicep CLI") -and ($env:Path -notmatch "BicepDev")) {
        $BicepPath = Resolve-Path $PSScriptRoot\..\..\Output\
        $env:Path += $env:Path + ";$BicepPath"
    }
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_deploy.bicep | Remove-Item
    Get-ChildItem $PSScriptRoot\..\SampleData -Recurse -File -Filter *_throwBuild.bicep | Remove-Item
}
Describe "Convert-BDParam" {
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
    it "should convert all parameters to outputs" {
        {$BD | Remove-BDFile} | Should -Not -Throw
    }
}