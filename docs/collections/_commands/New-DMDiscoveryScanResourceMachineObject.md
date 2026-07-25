---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# New-DMDiscoveryScanResourceMachineObject

## SYNOPSIS

Creates hashtable structured to be used as a machine list entry for Add-DMDiscoveryScanResource

## SYNTAX

```
New-DMDiscoveryScanResourceMachineObject [-Address] <String> [-Username <String>] [-Database <String>]
 [-Port <Int32>] [-Domain <String>] [-Tags <String[]>] [-Instances <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Provide parameter values to return a hashtable, correctly structured to represent a single machine list entry.

The output of this function is intended to be collected into an array and passed as the machineList key of the -content hashtable of Add-DMDiscoveryScanResource, when defining a resource for a WIN_NIX_LIST, SQL_SERVER, ORACLE, MYSQL or POSTGRESQL scan.

Not every parameter is applicable to every scan type - Username, Database & Port apply to database scan types, Domain & Instances apply only to SQL_SERVER, and Tags applies to WIN_NIX_LIST & SQL_SERVER. See the linked CyberArk API documentation for the exact fields expected per type.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Tags sampleTag
```

Returns hashtable structured to represent a single WIN_NIX_LIST machine list entry.

### Example 2

```powershell
PS C:\> $machineList = @(
    New-DMDiscoveryScanResourceMachineObject -Address address1.com -Username domainUserName -Database DatabaseName1 -Port 1433 -Domain Domain.com -Tags Tag1 -Instances *
    New-DMDiscoveryScanResourceMachineObject -Address address2.com -Username domainUserName -Database DatabaseName2 -Port 1433 -Domain Domain.com
)
PS C:\> Add-DMDiscoveryScanResource -type SQL_SERVER -name sql_server_scan.csv -content @{machineList = $machineList}
```

Builds an array of SQL_SERVER machine list entries and defines a discovery scan resource from them.

## PARAMETERS

### -Address

The address of the target machine to scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### -Database

The name of the database to scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Domain

The domain of the target machine, applicable to SQL_SERVER scans only.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Instances

The database instances to scan, applicable to SQL_SERVER scans only.
A value of * runs the scan on all instances of the database.
If not specified, the scan runs on the database specified by -Database.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Port

The port of the database to scan.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tags

User-defined tags to add to accounts discovered from this machine list entry.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Username

The name of the user running the scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-addresourceid.htm](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-addresourceid.htm)
