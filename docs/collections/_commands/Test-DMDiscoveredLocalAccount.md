---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Test-DMDiscoveredLocalAccount

## SYNOPSIS

Check discovered account existence

## SYNTAX

### single
```
Test-DMDiscoveredLocalAccount -type <String> -subtype <String> -identifiers <Hashtable>
 -externalId <String> [<CommonParameters>]
```

### multiple
```
Test-DMDiscoveredLocalAccount -accounts <Hashtable[]> [<CommonParameters>]
```

## DESCRIPTION

Check discovered account existence

-type and -subtype both provide tab-completion (sourced from Get-DMDiscoveredAccountTypeMap), with
-subtype's completions narrowing to those valid for whichever -type has already been typed. A
warning is emitted (for both the single and multiple parameter sets) if the supplied identifiers do
not look like a match for the given Type/SubType, per Get-DMDiscoveredAccountTypeMap - any keys you
provide are always included as-is; nothing is stripped or rejected.

## EXAMPLES

### Example 1

```powershell
PS C:\> Test-DMDiscoveredLocalAccount -type Windows -subtype Domain -identifiers @{address='win-computer.cyber-ark.com'; username='admin'} -externalId "user_account_5924"
```

Checks for the existence of the specified account

### Example 2

```powershell
PS C:\> $accounts = @(
    New-DMDiscoveredAccountObject -type windows -subType loosely -identifiers @{address='win-computer.cyber-ark.com'; username='admin'} -externalId user_account_5924
    New-DMDiscoveredAccountObject -type mac -subType loosely -identifiers @{address='mac-computer.cyber-ark.com'; username='root'} -externalId user_account_1132
)
PS C:\> Test-DMDiscoveredLocalAccount -accounts $accounts
```

Uses New-DMDiscoveredAccountObject to build an array of correctly structured account objects, and checks for the existence of all of them in a single request.

### Example 3

```powershell
PS C:\> $accounts = @(
    New-DMDiscoveredAccountObject -type AWS -subType Password -identifiers @{username='someuser'} -externalId aws_account_1
)
PS C:\> Test-DMDiscoveredLocalAccount -accounts $accounts
```

Builds & checks the existence of a discovered AWS account - a Type/SubType whose identifiers are not the common address/username shape.

## PARAMETERS

### -type

The account type

```yaml
Type: String
Parameter Sets: single
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -subtype

The account subtype

```yaml
Type: String
Parameter Sets: single
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -identifiers

List of properties that define the uniqueness of the account, as a hashtable.

The required/valid keys depend on the value provided for -type/-subtype - see
Get-DMDiscoveredAccountTypeMap for reference.

```yaml
Type: Hashtable
Parameter Sets: single
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -externalId

The external id of the account

```yaml
Type: String
Parameter Sets: single
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -accounts

a collection of accounts to query.

each account must be a hashtable containing type, subType, identifiers & externalId keys, in the format expected by the API.

New-DMDiscoveredAccountObject can be used to create correctly structured account objects to pass as this parameter's value.

```yaml
Type: Hashtable[]
Parameter Sets: multiple
Aliases:

Required: True
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

[https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-discoveredaccountsservice-check.htm](https://docs.cyberark.com/identity-protection-space/latest/en/content/discovery/discovery-discoveredaccountsservice-check.htm)
