# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Get-DMDiscoveredAccountTypeMap {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$SubType
    )

    process {

        $Map = @(
            [pscustomobject]@{ Type = 'Windows'; SubType = 'Local'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Windows'; SubType = 'Domain'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Windows'; SubType = 'Loosely'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Mac'; SubType = 'Loosely'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Unix'; SubType = 'Loosely'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Unix'; SubType = 'Password'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Unix'; SubType = 'SSHkey'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'AWS'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @(); Notes = "Vendor doc also lists 'AWS Account ID' as an identifier, but does not give its literal field name - not enforced here. Add it to -identifiers yourself if you know the real key." }
            [pscustomobject]@{ Type = 'AWS'; SubType = 'Access key'; Identifiers = @('Username'); OptionalIdentifiers = @(); Notes = "Vendor doc also lists 'AWS Account ID' & 'AWS Account ID Number' as identifiers, but does not give their literal field names - not enforced here. Add them to -identifiers yourself if you know the real keys." }
            [pscustomobject]@{ Type = 'GCP'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'GCP'; SubType = 'ServiceAccount'; Identifiers = @('Username'); OptionalIdentifiers = @(); Notes = "Vendor doc also lists 'Key ID' as an identifier, but does not give its literal field name - not enforced here. Add it to -identifiers yourself if you know the real key." }
            [pscustomobject]@{ Type = 'Azure'; SubType = 'Password'; Identifiers = @('Username', 'ActiveDirectoryID'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Azure'; SubType = 'ApplicationKey'; Identifiers = @('ApplicationID', 'ApplicationObjectID', 'KeyID', 'ActiveDirectoryID'); OptionalIdentifiers = @('KeyDescription'); Notes = 'KeyDescription is used only when KeyID is not available.' }
            [pscustomobject]@{ Type = 'Kubernetes'; SubType = 'SSHKeys'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'DB2onUnixviaSSH'; SubType = 'Password'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'SQLServer'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = $null }
            [pscustomobject]@{ Type = 'PostgreSQL'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = $null }
            [pscustomobject]@{ Type = 'MariaDB'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = $null }
            [pscustomobject]@{ Type = 'OracleDatabase'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = $null }
            [pscustomobject]@{ Type = 'SybaseASE'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = $null }
            [pscustomobject]@{ Type = 'MongoDB'; SubType = 'Password'; Identifiers = @('Username', 'Address', 'Database'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'Snowflake'; SubType = 'Password'; Identifiers = @('Username', 'Address'); OptionalIdentifiers = @('Database', 'Port'); Notes = $null }
            [pscustomobject]@{ Type = 'SAPHANA'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('DSN', 'Address', 'Port', 'Database', 'ReconcilesWinAccount'); Notes = $null }
            [pscustomobject]@{ Type = 'InformixUnixSSH'; SubType = 'Password'; Identifiers = @('Username', 'Address'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'CheckPointGAiA'; SubType = 'Password'; Identifiers = @('Address', 'Username', 'Type'); OptionalIdentifiers = @('Port'); Notes = $null }
            [pscustomobject]@{ Type = 'CiscoRouter'; SubType = 'Password'; Identifiers = @('Type'); OptionalIdentifiers = @('Username', 'Address', 'Port', 'Vty'); Notes = $null }
            [pscustomobject]@{ Type = 'CyberArkPTA'; SubType = 'Password'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @('Port'); Notes = $null }
            [pscustomobject]@{ Type = 'CyberArkVault'; SubType = 'Password'; Identifiers = @('Username', 'Address'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'MySQL'; SubType = 'Password'; Identifiers = @('Username'); OptionalIdentifiers = @('Address', 'Database', 'DSN'); Notes = 'Vendor doc requires (Address & Database) or DSN - relaxed to optional rather than enforcing the OR condition.' }
            [pscustomobject]@{ Type = 'NovelleDirectory'; SubType = 'Password'; Identifiers = @('Address', 'UserDN'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'OS390'; SubType = 'Password'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'RSAAuthenticationManager'; SubType = 'RSA'; Identifiers = @('Username', 'Address'); OptionalIdentifiers = @(); Notes = "Vendor doc also lists 'RSA User Type' as an identifier, but does not give its literal field name - not enforced here. Add it to -identifiers yourself if you know the real key." }
            [pscustomobject]@{ Type = 'SunOneDirectory'; SubType = 'Password'; Identifiers = @('Address', 'UserDN'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'CheckPointFireWall-1'; SubType = 'Password'; Identifiers = @('Address', 'Username', 'ClientDN', 'ServerDN'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'ConjureHost'; SubType = 'Password'; Identifiers = @('HostName', 'ApplianceURL'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'WebSite'; SubType = 'Password'; Identifiers = @('ItemName'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'PSMSecureConnect'; SubType = 'Password'; Identifiers = @('Address', 'Username'); OptionalIdentifiers = @(); Notes = $null }
            [pscustomobject]@{ Type = 'SAP'; SubType = 'NetWeaver'; Identifiers = @('Username', 'Address'); OptionalIdentifiers = @('UserType'); Notes = "Vendor doc also lists 'SAP System Number' as an optional identifier, but does not give its literal field name - not enforced here. Add it to -identifiers yourself if you know the real key." }
        )

        if ($PSBoundParameters.ContainsKey('Type')) {

            $Map = $Map | Where-Object { $PSItem.Type -eq $Type }

            if ($PSBoundParameters.ContainsKey('SubType')) {

                $Map = $Map | Where-Object { $PSItem.SubType -eq $SubType }

            }

        }

        $Map

    }

}
