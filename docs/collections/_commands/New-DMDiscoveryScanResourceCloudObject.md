---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# New-DMDiscoveryScanResourceCloudObject

## SYNOPSIS

Creates hashtable structured to be used as the content parameter of Add-DMDiscoveryScanResource for a cloud infrastructure scan

## SYNTAX

### AWS (Default)
```
New-DMDiscoveryScanResourceCloudObject -account <String> [-vpcs <String[]>] [-regions <String[]>]
 [-cloud_tags <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### AZURE
```
New-DMDiscoveryScanResourceCloudObject -subscription_id <String> [-resource_groups <String[]>]
 [-vnet_ids <String[]>] [-regions <String[]>] [-cloud_tags <String[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Provide parameter values to return a hashtable, correctly structured to represent the scope of a cloud infrastructure discovery scan resource for either AWS or Azure.

The output of this function is intended to be passed directly as the -content parameter of Add-DMDiscoveryScanResource, when defining a resource for an INVENTORY_WIN_NIX_LIST scan.

## EXAMPLES

### Example 1

```powershell
PS C:\> $content = New-DMDiscoveryScanResourceCloudObject -account 123456789012 -regions us-east-1,eu-west-1 -vpcs vpc-0abc123,vpc-0def456 -cloud_tags env:prod,team:platform
PS C:\> Add-DMDiscoveryScanResource -type INVENTORY_WIN_NIX_LIST -locationType AWS -name aws-inventory-prod -content $content
```

Builds scope content for an AWS cloud infrastructure scan resource and defines the resource.

### Example 2

```powershell
PS C:\> $content = New-DMDiscoveryScanResourceCloudObject -subscription_id aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee -regions eastus -resource_groups rg-prod-1 -vnet_ids vnet-prod -cloud_tags env:prod
PS C:\> Add-DMDiscoveryScanResource -type INVENTORY_WIN_NIX_LIST -locationType AZURE -name azure-inventory-prod -content $content
```

Builds scope content for an Azure cloud infrastructure scan resource and defines the resource.

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

### -account

The 12-digit AWS account id to scope the scan to.

```yaml
Type: String
Parameter Sets: AWS
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -cloud_tags

Optional filter, limiting the scan scope to resources with the specified cloud tags.
Defaults to no filter.

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

### -regions

Optional filter, limiting the scan scope to the specified regions.
Defaults to no filter.

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

### -resource_groups

Optional filter, limiting the scan scope to the specified Azure resource groups.
Defaults to no filter.

```yaml
Type: String[]
Parameter Sets: AZURE
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -subscription_id

The Azure subscription id (UUID) to scope the scan to.

```yaml
Type: String
Parameter Sets: AZURE
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -vnet_ids

Optional filter, limiting the scan scope to the specified Azure virtual network ids.
Defaults to no filter.

```yaml
Type: String[]
Parameter Sets: AZURE
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -vpcs

Optional filter, limiting the scan scope to the specified AWS VPCs.
Defaults to no filter.

```yaml
Type: String[]
Parameter Sets: AWS
Aliases:

Required: False
Position: Named
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
