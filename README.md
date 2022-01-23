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


