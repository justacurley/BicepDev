[![Build on push](https://github.com/justacurley/BicepDev/actions/workflows/build.yml/badge.svg)](https://github.com/justacurley/BicepDev/actions/workflows/build.yml)
[![BicepDev](https://img.shields.io/powershellgallery/v/BicepDev.svg?style=flat-square&label=BicepDev)](https://www.powershellgallery.com/packages/BicepDev/)

# BicepDev
## Description
A module for faster Bicep module testing and debugging.

I've been creating large, complex Bicep modules and templates for a year now, and always lamented having to debug them. I have three sets of templates:
 - A blank template to test simple functions
 - A copy of 'production' templates with all the resources removed to test variables/parameters between linked templates
 - The 'production' templates I deploy with

I got tired of keeping my copy up to date, and the slim usefulness of the blank template, so I made this PS module.

The real beauty here is being able to test variables and parameters as data is passed through linked templates.

## Example
```powershell
#Create temp copies of bicep files (DeploymentFile, ModuleFile) and build (BuiltModule)
#This will empty the resources array in the json ARM template (BuiltModule), so nothing is deployed.
$BicepDeploymentFile = ".\deploy.bicep"
$BicepModuleFile = ".\appGateway.bicep"
New-BDFile -BicepDeploymentFile $BicepDeploymentFile -BicepModuleFile $BicepModuleFile -OutVariable BD
BicepDeploymentFile     BicepModuleFile             BuiltModule                 OutputName
-------------------     ---------------             -----------                 ----------
\dae1_deploy.bicep      \dae1_appGateway.bicep      \dae1_appGateway.json       appGateway

#Convert all variables in BuiltModule to outputs
$BD | Convert-BDVar

#Deploy to Azure and return variable outputs
New-AzResourceGroupDeployment -ResourceGroupName "rg-bicep" -TemplateFile $BD.BicepDeploymentFile -OutVariable Deploy
DeploymentName          : dae1_deploy
ResourceGroupName       : rg-bicep
ProvisioningState       : Succeeded
Timestamp               : 1/23/2022 8:22:32 PM
Mode                    : Incremental
TemplateLink            :
Parameters              :
Outputs                 : ...

$BDOutput = $Deploy | Get-BDOutput -OutputName $BD.OutputName
$BDOutput.bdVars.value
diagnosticsLogs                              : {@{category=ApplicationGatewayAccessLog; enabled=True; retentionPolicy=}, @{category=ApplicationGatewayPerformanceLog; enabled=True; retentionPolicy=}, @{category=ApplicationGatewayFirewallLog; enabled=True; retentionPolicy=}}
diagnosticsMetrics                           : {@{category=AllMetrics; timeGrain=; enabled=True; retentionPolicy=}}
backendAddressPools                          : {@{name=pool_0; type=Microsoft.Network/applicationGateways/backendAddressPools; properties=}}
probes_var                                   : {@{name=httpSettings_8101Probe; type=Microsoft.Network/applicationGateways/probes; properties=}}
backendHttpConfigurations_var                : {@{name=httpSettings_8101; properties=}}
frontendHttpsPorts                           : {@{name=port8101; properties=}, @{name=port443; properties=}}
frontendHttpsListeners_var                   : {@{name=listener_8101; properties=}, @{name=listener_443; properties=}}
frontendHttpPorts                            : {@{name=port80; properties=}}
frontendHttpListeners_var                    : {@{name=listener_80; properties=}}
httpsRequestRoutingRules                     : {@{name=listener_443-httpSettings_8101-httpSettings_8101; properties=}, @{name=listener_8101-httpSettings_8101-httpSettings_8101; properties=}}
frontendHttpRedirectPorts                    : {@{name=port80; properties=}}
frontendHttpRedirects_var                    : {@{name=httpRedirect80; properties=}}
httpRequestRoutingRules                      : {@{name=httpRedirect80-listener_443; properties=}}
httpRedirectConfigurations                   : {@{name=httpRedirect80; properties=}}
applicationGatewayResourceId                 : /subscriptions/167823da-0f70-4b25-992f-f29fdd28d520/resourceGroups/rg-pos-azusw2-dvo-dv1/providers/Microsoft.Network/applicationGateways/agw-bdfiles
subnetResourceId                             : /subscriptions/sn
frontendPublicIPConfigurationName            : public
frontendPrivateIPConfigurationName           : private
frontendPrivateIPDynamicConfiguration        : @{privateIPAllocationMethod=Dynamic; subnet=}
frontendPrivateIPStaticConfiguration         : @{privateIPAllocationMethod=Static; privateIPAddress=; subnet=}
redirectConfigurationsHttpRedirectNamePrefix : httpRedirect
httpListenerhttpRedirectNamePrefix           : httpRedirect
requestRoutingRuleHttpRedirectNamePrefix     : httpRedirect
wafConfiguration                             : @{enabled=True; firewallMode=Detection; ruleSetType=OWASP; ruleSetVersion=3.0; disabledRuleGroups=System.Object[]; requestBodyCheck=True; maxRequestBodySizeInKb=128}
sslCertificates                              : {@{name=star-bdfiles-com; properties=}}
frontendPorts                                : {@{name=port80; properties=}, @{name=port8101; properties=}, @{name=port443; properties=}}
httpListeners                                : {@{name=listener_80; properties=}, @{name=listener_8101; properties=}, @{name=listener_443; properties=}, @{name=httpRedirect80; properties=}}
redirectConfigurations                       : {@{name=httpRedirect80; properties=}}
requestRoutingRules                          : {@{name=listener_443-httpSettings_8101-httpSettings_8101; properties=}, @{name=listener_8101-httpSettings_8101-httpSettings_8101; properties=}, @{name=httpRedirect80-listener_443; properties=}}
identityType                                 : UserAssigned
identity                                     : @{type=UserAssigned; userAssignedIdentities=}
```

## BicepDev Cmdlets
### [Add-BDOutput](Docs/Add-BDOutput.md)
Add outputs to an arm template created by New-BDFile

### [Convert-BDParam](Docs/Convert-BDParam.md)
Converts all parameters in an arm template to ouputs

### [Convert-BDVar](Docs/Convert-BDVar.md)
Converts all variables in an arm template to ouputs

### [Get-BDOutput](Docs/Get-BDOutput.md)
Convert JObject, returned from 'Outputs' property of New-AzResourceGroupDeployment, to PSCustomObject.

### [New-BDFile](Docs/New-BDFile.md)
Creates copies of bicep files to be used for testing with this module.

### [Remove-BDFile](Docs/Remove-BDFile.md)
Deletes files created by New-BDFile


