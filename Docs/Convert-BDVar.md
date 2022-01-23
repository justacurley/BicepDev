# Convert-BDVar

## SYNOPSIS
Converts all variables in an arm template to ouputs

## SYNTAX

```
Convert-BDVar [-BuiltModule] <FileInfo> [[-VariablesToConvert] <String[]>] [<CommonParameters>]
```

## DESCRIPTION
This cmdlet adds one output to the $BuiltModule arm template: 'bdVars'

When bicep builds to an ARM template, all copy loop array variables are added to a single variable named 'copy'.
We use
similar logic here to take all of those copy loops inside the copy var, and put them in a new ARM template variable, which
we use to make a more simple output in bdVars.
The pattern follows for all other variables.

## EXAMPLES

### EXAMPLE 1
```
New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
PS C:\> $BD.BuiltModule | Convert-BDVar
```

Add all variables in $BD.BuiltModule to new variable (bdVars), and output variable bdVars in the arm template.

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

### -VariablesToConvert
Enter names of variables to convert to outputs

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Vars

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
