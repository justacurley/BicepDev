# Remove-BDFile

## SYNOPSIS
Deletes files created by New-BDFile

## SYNTAX

### pipe
```
Remove-BDFile [-BicepDeploymentFile <FileInfo>] [-BicepModuleFile <FileInfo>] [-BuiltModule <FileInfo>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### besteffort
```
Remove-BDFile [-RemoveFromDirectory <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Either delete all files from current session (Output of New-BDFile) or make a best effort at deleting all .json and .bicep files in the directory provided with RemoveFromDirectory

## EXAMPLES

### EXAMPLE 1
```
New-BDFile -BicepDeploymentFile testAppGateway.bicep -BicepModuleFile appGateway.bicep -outvariable $BD
PS C:\> $BD | Remove-BDFile
```

Returns a PSObject of files to be used with the other cmdlets in the module

## PARAMETERS

### -BicepDeploymentFile
The .bicep file that calls the bicep module we want to transform

```yaml
Type: FileInfo
Parameter Sets: pipe
Aliases: Deploy

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BicepModuleFile
The .bicep module we want to transform

```yaml
Type: FileInfo
Parameter Sets: pipe
Aliases: Module

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -BuiltModule
The .json file that was built from New-BDFile

```yaml
Type: FileInfo
Parameter Sets: pipe
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoveFromDirectory
Search for and remove files matching files created by New-BDFile

```yaml
Type: String
Parameter Sets: besteffort
Aliases:

Required: False
Position: Named
Default value: None
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

### (New-BDFile)
## OUTPUTS

## NOTES

## RELATED LINKS
