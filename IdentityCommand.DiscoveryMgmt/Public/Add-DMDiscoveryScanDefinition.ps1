# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Add-DMDiscoveryScanDefinition {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet(
            'WIN_NIX_LIST', 'WIN_NIX_DOMAIN', 'POSTGRESQL', 'MYSQL', 'ORACLE', 'SQL_SERVER', 'INVENTORY_WIN_NIX_LIST'
        )]
        [string]$type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$properties,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE', 'ON_PREM')]
        [string]$locationType,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable[]]$credentials,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$networkId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string[]]$tags,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('IMMEDIATE', 'SCHEDULED', 'RECURRING')]
        [string]$recurrenceType,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$recurrenceData,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ACTIVE', 'INACTIVE')]
        [string]$State

    )

    process {

        #Create URL for Request
        $URI = "$(Resolve-RequestUrl)/api/scan-definitions"

        #Get bound parameters to include in request
        $BoundParameters = $PSBoundParameters | Get-Parameter

        if ($BoundParameters.ContainsKey('State')) {

            #PowerShell hashtables are case-insensitive, so "State" & "state" are the same key.
            #The value must be removed before being re-added, otherwise the API's expected
            #lowercase "state" property name is never actually applied to the stored key.
            $StateValue = $BoundParameters['State']
            $BoundParameters.Remove('State')
            $BoundParameters['state'] = $StateValue

        }

        #Create Request Body
        $Body = $BoundParameters | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess($name, 'Add Scan Definition')) {

            #Send request to web service
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        }

    }

    end {}

}
