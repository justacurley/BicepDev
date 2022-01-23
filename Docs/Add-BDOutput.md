# Add-BDOutput

## SYNOPSIS
Add outputs to an arm template created by New-BDFile

## SYNTAX

```
Add-BDOutput [-BuiltModule] <FileInfo> [-Name] <String> [-Type] <String> [-Value] <Object> [<CommonParameters>]
```

## DESCRIPTION
Provide Name, Type, Value of the output to have it added.

## EXAMPLES

### EXAMPLE 1
```
.\appGateway.json | Add-BDOutput -Name 'testString' -Type 'string' -value 'hello'
Add a string output to appGateway.json
```

### EXAMPLE 2
```
$foo.BuiltModule | Add-BDOutput -Name 'testObject' -Type 'object' -value @{'hi'='hello'}
Add an object output to appGateway.json
```

### EXAMPLE 3
```
$foo.BuiltModule | Add-BDOutput -Name 'testArray' -Type 'array' -value @('hi','hello')
Add an array output to appGateway.json
```

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

### -Name
Name of the output

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

### -Type
\[type\] of the output

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value of the output

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
