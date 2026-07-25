---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Set-DMDiscoveryScanDefinition

## SYNOPSIS

Updates an existing discovery scan definition.

## SYNTAX

```
Set-DMDiscoveryScanDefinition [-id] <String> [[-name] <String>] [[-type] <String>] [[-properties] <Hashtable>]
 [[-locationType] <String>] [[-credentials] <Hashtable[]>] [[-networkId] <String>] [[-tags] <String[]>]
 [[-recurrenceType] <String>] [[-recurrenceData] <Hashtable>] [[-State] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Updates an existing scan definition used to discover accounts in target machines.

Any property not passed as a parameter is left unchanged, retaining its current value from the
existing scan definition, so the update does not clear properties which are not being modified.

The scan type (-type) and location type (-locationType) of an existing scan definition cannot
actually be changed by the API once set, even if different values are supplied here.

The required/valid keys of the `-properties` hashtable (and, for some scan types, whether
`-networkId` is required) depend on the value of `-type`. Similarly, the required keys of
`-recurrenceData` depend on the value of `-recurrenceType`. See the linked CyberArk API
documentation for the full set of supported scan types and their properties/credentials/
recurrenceData shapes. Passing `-properties`/`-recurrenceData`/`-credentials` replaces the existing
value entirely, rather than merging into it.

## EXAMPLES

### Example 1

```powershell
PS C:\> Set-DMDiscoveryScanDefinition -id d571cdfgdfg8 -State INACTIVE
```

Deactivates an existing scan definition, leaving all other properties unchanged.

### Example 2

```powershell
PS C:\> $properties = @{
    domain   = 'company.com'
    ou       = 'cn=mygroup'
    targets  = @{ domainController = $true; nonPrivileged = $false }
    adGroups = @{ groups = $true }
}
PS C:\> Set-DMDiscoveryScanDefinition -id d571cdfgdfg8 -properties $properties
```

Replaces the properties of an existing Windows and *nix domain scan definition, leaving its name,
credentials, and schedule unchanged.

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

### -State

Whether the scan is in an active or inactive state.
If a scan is inactive, no scan instances can run from it.

If not specified, the existing state of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ACTIVE, INACTIVE

Required: False
Position: 10
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

### -credentials

The credentials used to run the scan and access the targets, when scanning a database or from a
list of targets, as an array of hashtables.

Each hashtable defines name, type (ACCOUNT or UNMANAGED_ACCOUNT), properties (a hashtable containing
account_id), and optionally defaultAccount.

If not specified, the existing credentials of the scan definition are left unchanged. If specified,
replaces the existing credentials entirely.

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -id

The id of the scan definition to update.

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

### -locationType

The location of the scan targets.

This value cannot actually be changed once a scan definition is created; if not specified, the
existing locationType of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, ON_PREM

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name

The name of the scan definition.

If not specified, the existing name of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -networkId

The network selected to run the scan from.
The network must be defined in Connector Management and must be assigned to a connector pool with
at least one connector.

If not specified, the existing networkId of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -properties

A hashtable of properties which define the scan.
The required/valid keys depend on the value of -type.

If not specified, the existing properties of the scan definition are left unchanged. If specified,
replaces the existing properties entirely, rather than merging into them.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -recurrenceData

A hashtable defining the schedule of the scan.
Required when -recurrenceType is SCHEDULED or RECURRING; the required keys depend on the value of
-recurrenceType.

If not specified, the existing recurrenceData of the scan definition is left unchanged. If
specified, replaces the existing recurrenceData entirely.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -recurrenceType

Determines the recurrence policy of the scan.

IMMEDIATE is a one time scan that runs immediately after the scan is defined.
SCHEDULED is a one time scan that runs at a predefined time.
RECURRING is periodic scan(s) that run on specific days of the week, or specific dates of the
month, at given times.

If not specified, the existing recurrenceType of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: IMMEDIATE, SCHEDULED, RECURRING

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tags

User-defined tags to add to accounts discovered by this scan.

If not specified, the existing tags of the scan definition are left unchanged. If specified,
replaces the existing tags entirely.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type

The scan type of this scan definition.

This value cannot actually be changed once a scan definition is created; if not specified, the
existing type of the scan definition is left unchanged.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: WIN_NIX_LIST, WIN_NIX_DOMAIN, POSTGRESQL, MYSQL, ORACLE, SQL_SERVER, INVENTORY_WIN_NIX_LIST

Required: False
Position: 2
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

[https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-apis/discovery-updatescandefinition.htm](https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-apis/discovery-updatescandefinition.htm)
