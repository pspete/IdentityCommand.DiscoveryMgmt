---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Add-DMDiscoveryScanResource

## SYNOPSIS

Defines a new discovery scan resource.

## SYNTAX

```
Add-DMDiscoveryScanResource [-type] <String> [-name] <String> [-content] <Hashtable>
 [[-locationType] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Generates a unique resource id for a machine list file or a cloud scope, used by file-based, database, and cloud infrastructure discovery scans.

The resulting resource id is referenced from the properties of a scan definition created with Add-DMDiscoveryScanDefinition/Set-DMDiscoveryScanDefinition.

The required/valid keys of the `-content` hashtable depend on the value provided for `-type`. New-DMDiscoveryScanResourceMachineObject and New-DMDiscoveryScanResourceCloudObject can be used to build correctly structured content for this parameter, rather than constructing it by hand. See the linked CyberArk API documentation for the full set of supported types and their content shapes.

## EXAMPLES

### Example 1

```powershell
PS C:\> $machineList = @(
    New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Tags sampleTag
)
PS C:\> Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = $machineList}
```

Defines a file-based discovery scan resource from a single machine list entry.

### Example 2

```powershell
PS C:\> $machineList = @(
    New-DMDiscoveryScanResourceMachineObject -Address address1.com -Username domainUserName -Database DatabaseName1 -Port 1433 -Domain Domain.com -Tags Tag1 -Instances *
)
PS C:\> Add-DMDiscoveryScanResource -type SQL_SERVER -name sql_server_scan.csv -content @{machineList = $machineList}
```

Defines an MSSQL database discovery scan resource.

### Example 3

```powershell
PS C:\> $content = New-DMDiscoveryScanResourceCloudObject -account 123456789012 -regions us-east-1,eu-west-1 -vpcs vpc-0abc123,vpc-0def456 -cloud_tags env:prod,team:platform
PS C:\> Add-DMDiscoveryScanResource -type INVENTORY_WIN_NIX_LIST -locationType AWS -name aws-inventory-prod -content $content
```

Defines a cloud infrastructure discovery scan resource for an AWS account.

## PARAMETERS

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

### -content

A hashtable defining the content of the scan resource.
The required/valid keys depend on the value provided for -type.

New-DMDiscoveryScanResourceMachineObject builds a single machine list entry (for WIN_NIX_LIST, SQL_SERVER, ORACLE, MYSQL & POSTGRESQL types) to be collected into an array and passed as the machineList key of this hashtable.

New-DMDiscoveryScanResourceCloudObject builds the entire content hashtable for the INVENTORY_WIN_NIX_LIST type.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -locationType

The cloud vendor of the scan resource.
Required when -type is INVENTORY_WIN_NIX_LIST.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name

The name of the scan resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type

The type of resource that will be represented by the resource id.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: WIN_NIX_LIST, SQL_SERVER, ORACLE, MYSQL, POSTGRESQL, INVENTORY_WIN_NIX_LIST

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-addresourceid.htm](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-addresourceid.htm)
