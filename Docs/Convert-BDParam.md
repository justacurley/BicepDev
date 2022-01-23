# Convert-BDParam

## SYNOPSIS
Converts all parameters in an arm template to ouputs

## SYNTAX

```
Convert-BDParam [-BuiltModule] <FileInfo> [[-ParametersToConvert] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
PS C:\> $BD.BuiltModule | Convert-BDParam
```

Convert all parameters in $BD.BuiltModule to outputs, with a prefix of 'pars_' as the name.

## PARAMETERS

### -BuiltModule
The built bicep template returned from New-BDFile

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ParametersToConvert
Enter names of parameters to convert to outputs

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Params

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### (New-BDFile).BuiltModule
## OUTPUTS

## NOTES

## RELATED LINKS
