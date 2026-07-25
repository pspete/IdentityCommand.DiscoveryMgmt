---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Get-DMDiscoveredAccountTypeMap

## SYNOPSIS

Returns reference data describing the identifiers expected for each discovered account Type/SubType.

## SYNTAX

```
Get-DMDiscoveredAccountTypeMap [[-Type] <String>] [[-SubType] <String>] [<CommonParameters>]
```

## DESCRIPTION

Returns the CyberArk discovered account Type/SubType to identifiers mapping table, sourced from
[Types of accounts that can be sent via API](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-api-types.htm).

For each Type/SubType combination, the returned object describes the mandatory Identifiers, any
OptionalIdentifiers, and Notes explaining any known limitation.

A small number of rows in the source documentation describe an identifier only in prose (e.g. AWS's
"AWS Account ID"), rather than giving the literal field name expected by the API. Those identifiers
are intentionally omitted from Identifiers/OptionalIdentifiers rather than guessed at - Notes
explains which identifier is affected on those rows. This does not stop you from including such an
identifier yourself, if you separately know the correct field name to use - the -identifiers
parameter of New-DMDiscoveredAccountObject, Test-DMDiscoveredLocalAccount &
Add-DMDiscoveredLocalAccount always accepts any keys you provide; this command only describes what
is confidently known, and drives their -type/-subType tab-completion and shape-mismatch warnings.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-DMDiscoveredAccountTypeMap
```

Returns the full Type/SubType to identifiers mapping table.

### Example 2

```powershell
PS C:\> Get-DMDiscoveredAccountTypeMap -Type AWS
```

Returns the mapping table rows for the AWS type.

### Example 3

```powershell
PS C:\> (Get-DMDiscoveredAccountTypeMap -Type AWS -SubType Password).Notes
```

Reads the Notes for AWS/Password, explaining that "AWS Account ID" is a documented identifier whose
literal field name is not confirmed, and is therefore not enforced by Test-DMDiscoveredAccountIdentifier.

## PARAMETERS

### -SubType

Filter results to a specific account SubType. Only applied when -Type is also specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Type

Filter results to a specific account Type.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-api-types.htm](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-api-types.htm)
