---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Add-DMDiscoveredLocalAccount

## SYNOPSIS
Add a specific account from the list of discovered local endpoint accounts to the Discovered Accounts list.

## SYNTAX

```
Add-DMDiscoveredLocalAccount [-type] <String> [-identifiers] <Hashtable> [[-isPrivileged] <Boolean>]
 [[-customProperties] <Hashtable>] [[-source] <String>] [<CommonParameters>]
```

## DESCRIPTION
Adds a specific account from the list of discovered accounts for local endpoint Windows and MacOS accounts to the Discovered Accounts list.

Applies to the accounts that are discovered by the EPM scanning of endpoints, including loosely connected devices:
- Windows loosely connected devices
- Mac loosely connected devices
- Linux loosely connected devices

Requires one of the following roles:
- Privilege Cloud Administrator
- Privilege Cloud Administrator Basic
- Privilege Cloud Administrator Lite

A warning is emitted if the supplied -identifiers does not look like a match for -type (subType is
always loosely for this command), per Get-DMDiscoveredAccountTypeMap - any keys you provide are
always included as-is; nothing is stripped or rejected.

## EXAMPLES

### EXAMPLE 1
```
Add-DMDiscoveredLocalAccount -type windows -identifiers @{'username'='administrator'; 'address'='somemachine.pspete.dev'}
```

Adds the specified local account as a discovered local account.

## PARAMETERS

### -type
The type of the account.

Typical values are windows, mac & unix (tab-completion is provided, sourced from
Get-DMDiscoveredAccountTypeMap), but any value is accepted.


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

### -identifiers
List of properties that define the uniqueness of the account.

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

### -isPrivileged
Whether the user is privileged on the target.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -customProperties
List of additional account properties.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -source
The service which discovered the account.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/privilege-cloud-shared-services/latest/en/Content/Privilege%20Cloud/PrivCloud-DiscoveredAccountsService-Add.htm](https://docs.cyberark.com/privilege-cloud-shared-services/latest/en/Content/Privilege%20Cloud/PrivCloud-DiscoveredAccountsService-Add.htm)
