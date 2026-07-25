---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# New-DMDiscoveredAccountObject

## SYNOPSIS

Creates hashtable structured to be used as input for the accounts parameter of Test-DMDiscoveredLocalAccount

## SYNTAX

```
New-DMDiscoveredAccountObject [-type] <String> [-subType] <String> [-identifiers] <Hashtable>
 [-externalId] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Provide parameter values to return a hashtable, correctly structured to represent a single discovered account.

The required/valid keys of the -identifiers hashtable depend on the value provided for -type/-subType.
Get-DMDiscoveredAccountTypeMap describes the expected identifiers for every documented Type/SubType
combination - a warning is emitted if the supplied -identifiers does not look like a match, but any
keys you provide are always included as-is; nothing is stripped or rejected.

-type and -subType both provide tab-completion (sourced from Get-DMDiscoveredAccountTypeMap),
with -subType's completions narrowing to those valid for whichever -type has already been typed.

The output of this function is intended to be collected into an array and passed to the accounts parameter of Test-DMDiscoveredLocalAccount, to check the existence of multiple discovered accounts in a single request.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-DMDiscoveredAccountObject -type Windows -subType Domain -identifiers @{address='win-computer.cyber-ark.com'; username='admin'} -externalId user_account_5924
```

Returns hashtable structured to represent a single discovered Windows/Domain account.

### Example 2

```powershell
PS C:\> $accounts = @(
    New-DMDiscoveredAccountObject -type windows -subType loosely -identifiers @{address='win-computer.cyber-ark.com'; username='admin'} -externalId user_account_5924
    New-DMDiscoveredAccountObject -type mac -subType loosely -identifiers @{address='mac-computer.cyber-ark.com'; username='root'} -externalId user_account_1132
)
PS C:\> Test-DMDiscoveredLocalAccount -accounts $accounts
```

Builds an array of discovered account objects and checks the existence of all of them in a single request.

### Example 3

```powershell
PS C:\> New-DMDiscoveredAccountObject -type AWS -subType Password -identifiers @{username='someuser'} -externalId aws_account_1
```

Returns hashtable structured to represent a single discovered AWS account - a Type/SubType whose
identifiers are not the common address/username shape.

## PARAMETERS

### -externalId

The external id of the account

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -identifiers

List of properties that define the uniqueness of the account, as a hashtable.

The required/valid keys depend on the value provided for -type/-subType - see
Get-DMDiscoveredAccountTypeMap for reference.

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

### -subType

The account subtype

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

The account type

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

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-api-types.htm](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-api-types.htm)
