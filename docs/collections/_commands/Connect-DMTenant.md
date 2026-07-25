---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Connect-DMTenant

## SYNOPSIS
Connects to a PrivilegeCloud Discovery tenant

## SYNTAX

```
Connect-DMTenant [-subdomain] <String> [<CommonParameters>]
```

## DESCRIPTION
Connects to the discoverymgmt & privilegecloud Discovery hosts of a tenant, to be able to run
IdentityCommand.DiscoveryMgmt module commands against them.

Requires prior authentication to the related ISPSS Identity Shared Services tenant using the `IdentityCommand` module.

## EXAMPLES

### Example 1
```
Connect-DMTenant -subdomain sometenant
```

Connects to the https://sometenant.discoverymgmt.cyberark.cloud and https://sometenant.privilegecloud.cyberark.cloud hosts for subsequent module operations

## PARAMETERS

### -subdomain
The tenant subdomain shared by the discoverymgmt & privilegecloud hosts

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
