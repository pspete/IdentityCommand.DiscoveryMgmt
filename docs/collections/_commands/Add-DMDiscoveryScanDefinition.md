---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Add-DMDiscoveryScanDefinition

## SYNOPSIS

Adds a new discovery scan definition.

## SYNTAX

```
Add-DMDiscoveryScanDefinition [-name] <String> [-type] <String> [-properties] <Hashtable>
 [[-locationType] <String>] [[-credentials] <Hashtable[]>] [[-networkId] <String>] [[-tags] <String[]>]
 [[-recurrenceType] <String>] [[-recurrenceData] <Hashtable>] [[-State] <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Creates a new scan definition to discover accounts in target machines.

The required/valid keys of the `-properties` hashtable (and, for some scan types, whether
`-networkId` is required) depend on the value provided for `-type`. Similarly, the required keys of
`-recurrenceData` depend on the value of `-recurrenceType`. See the linked CyberArk API documentation
for the full set of supported scan types and their properties/credentials/recurrenceData shapes.

## EXAMPLES

### Example 1

```powershell
PS C:\> $properties = @{
    domain   = 'company.com'
    ou       = 'cn=mygroup'
    targets  = @{ domainController = $true; nonPrivileged = $true }
    adGroups = @{ groups = $true }
}
PS C:\> $credentials = @(
    @{ name = 'DOMAIN_ADMIN'; type = 'ACCOUNT'; properties = @{ account_id = '111_5' } }
)
PS C:\> Add-DMDiscoveryScanDefinition -name Windows-nix-scan -type WIN_NIX_DOMAIN -networkId dsdfsdf-5342-asdb-bd22-sdfdg3425 -properties $properties -credentials $credentials -recurrenceType IMMEDIATE -State ACTIVE
```

Creates a new Windows and *nix domain discovery scan definition.

### Example 2

```powershell
PS C:\> $properties = @{
    domain                   = 'company.com'
    resource                 = @{ id = '980ece7a-a4de-43ac-a61b-fake' }
    certificateConfiguration = @{ validateCertificate = $true }
}
PS C:\> $credentials = @(
    @{ name = 'DOMAIN_ADMIN'; type = 'ACCOUNT'; properties = @{ account_id = '82_5' } }
)
PS C:\> $recurrenceData = @{
    date          = '2025-12-15'
    times         = @('13:30')
    timeZone      = 'US'
    repeatPattern = 'WEEKLY'
    daysOfWeek    = @('TUESDAY')
}
PS C:\> Add-DMDiscoveryScanDefinition -name SQLScan -type SQL_SERVER -networkId 353e85d5-4671-4ghjghg-ghjgee -tags tag1 -properties $properties -credentials $credentials -recurrenceType RECURRING -recurrenceData $recurrenceData -State INACTIVE
```

Creates a new SQL Server discovery scan definition with a weekly recurring schedule.

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

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: ACTIVE, INACTIVE

Required: False
Position: 9
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

```yaml
Type: Hashtable[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -locationType

The location of the scan targets.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: AWS, AZURE, ON_PREM

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name

The name of the scan definition.

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

### -networkId

The network selected to run the scan from.
The network must be defined in Connector Management and must be assigned to a connector pool with
at least one connector.

Mandatory for list & database scans, not required for domain scans.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -properties

A hashtable of properties which define the scan.
The required/valid keys depend on the value provided for -type.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -recurrenceData

A hashtable defining the schedule of the scan.
Required when -recurrenceType is SCHEDULED or RECURRING; the required keys depend on the value of
-recurrenceType.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: IMMEDIATE, SCHEDULED, RECURRING

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tags

User-defined tags to add to accounts discovered by this scan.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type

The scan type to use for this scan definition.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: WIN_NIX_LIST, WIN_NIX_DOMAIN, POSTGRESQL, MYSQL, ORACLE, SQL_SERVER, INVENTORY_WIN_NIX_LIST

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

[https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-apis/discovery-addnewscandefinition.htm](https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-apis/discovery-addnewscandefinition.htm)
