# New-BDFile

## SYNOPSIS
Creates copies of bicep files to be used for testing with this module.

## SYNTAX

```
New-BDFile [-BicepDeploymentFile] <String> [-BicepModuleFile] <String> [-KeepResources] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Given a bicep module that you want to develop/test with, and a bicep template file that calls that module,
this cmdlet should copy both files, build your template, and output an ARM template ready for use by
the other cmdlets in this module.

## EXAMPLES

### EXAMPLE 1
```
New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
PS C:\> $BD | fl
        BicepDeploymentFile : appGateway\ec03_test.bicep
        BicepModuleFile     : appGateway\ec03_appGatewayMicrosoft.bicep
        BuiltModule         : appGateway\ec03_appGatewayMicrosoft.json
        OutputProperty      : appGateway
```

Returns a PSObject of files to be used with the other cmdlets in the module

## PARAMETERS

### -BicepDeploymentFile
The .bicep file that calls the bicep module we want to transform

```yaml
Type: String
Parameter Sets: (All)
Aliases: Deploy

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BicepModuleFile
The .bicep module we want to transform

```yaml
Type: String
Parameter Sets: (All)
Aliases: Module

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeepResources
Prevent this function from clearing out the resources array from the file we will be injecting output into

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [PSCustomObject]
## NOTES
TODO Make {$BicepDepFileContent -replace "'.*$ReplaceString'", "'$($NewBicModFile.Name)'"} handle more than 0 path levels
TODO Write New-BDDeployment controller function

## RELATED LINKS
