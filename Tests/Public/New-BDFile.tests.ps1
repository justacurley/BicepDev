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
Describe "New-BDFile" {
    BeforeAll {
        $script:BicepDeploymentFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter deploy.bicep
        $script:BicepModuleFile = Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter appGateway.bicep
        Write-Information "Testing $($BicepModuleFile.Name) deployment file in '$(Convert-Path $PSScriptRoot\..)'" -InformationAction Continue
        $Parameters = @{
            BicepDeploymentFile = $BicepDeploymentFile.FullName
            BicepModuleFile     = $BicepModuleFile.FullName
        }
    }
    it "should return 4 properties" {
        $BD = New-BDFile @Parameters
        $BD.BicepDeploymentFile | Should -BeOfType 'System.IO.FileSystemInfo'
        $BD.BicepModuleFile | Should -BeOfType 'System.IO.FileSystemInfo'
        $BD.BuiltModule | Should -BeOfType 'System.IO.FileSystemInfo'
        $BD.OutputName | Should -BeOfType 'string'
        {$BD | Remove-BDFile} | Should -Not -Throw
    }
    it "should throw on failed bicep build and remove copied files" {
        $ThrowBicepModuleFile = $BicepModuleFile.FullName -replace 'appGateway.bicep', 'throwBuild.bicep'
        {New-BDFile -BicepDeploymentFile $BicepDeploymentFile -BicepModuleFile $ThrowBicepModuleFile} | Should -Throw
        Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter *_deploy.bicep | Should -BeNullOrEmpty
        Get-ChildItem $PSScriptRoot\.. -Recurse -File -Filter *_throwBuild.bicep | Should -BeNullOrEmpty
    }
}