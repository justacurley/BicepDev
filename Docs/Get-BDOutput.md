# Get-BDOutput

## SYNOPSIS
Convert JObject, returned from 'Outputs' property of New-AzResourceGroupDeployment, to PSCustomObject.

## SYNTAX

```
Get-BDOutput [-InputObject] <Object> [-OutputName] <String> [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
PS C:\> New-AzResourceGroupDeployment -ResourceGroupName 'rg-bdfiles' -TemplateFile $BD.BuiltModule | Get-BDOutput -OutputName $BD.OutputName
```

Grabs the appGateway output property and converts it from jqlinq to PSCustomObject

## PARAMETERS

### -InputObject
The output of New-AzResourceGroupDeployment

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OutputName
The name of the output variable to return

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### [PSResourceGroupDeployment]
## OUTPUTS

### [PsCustomObject]
## NOTES

## RELATED LINKS
