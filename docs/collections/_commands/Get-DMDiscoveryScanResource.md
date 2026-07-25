---
external help file: IdentityCommand.DiscoveryMgmt-help.xml
Module Name: IdentityCommand.DiscoveryMgmt
online version:
schema: 2.0.0
---

# Get-DMDiscoveryScanResource

## SYNOPSIS

Get scan resource details.

## SYNTAX

```
Get-DMDiscoveryScanResource [-id] <String> [<CommonParameters>]
```

## DESCRIPTION

Retrieves the details of a discovery scan resource, including a pre-signed URL to download the resource file, which is valid for 15 minutes.

A scan resource is created with Add-DMDiscoveryScanResource, and its id is referenced from the properties of a scan definition created with Add-DMDiscoveryScanDefinition/Set-DMDiscoveryScanDefinition.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-DMDiscoveryScanResource -id 6eaec82a-ba0d-44ac-ac6b-41a932282a52
```

Returns the details of the specified scan resource.

## PARAMETERS

### -id

The unique identifier of the scan resource to retrieve.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-getresourceid.htm](https://docs.cyberark.com/manage/latest/en/content/discovery/discovery-apis/discovery-getresourceid.htm)
