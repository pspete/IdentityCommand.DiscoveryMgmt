# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Set-DMDiscoveryScanDefinition {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet(
            'WIN_NIX_LIST', 'WIN_NIX_DOMAIN', 'POSTGRESQL', 'MYSQL', 'ORACLE', 'SQL_SERVER', 'INVENTORY_WIN_NIX_LIST'
        )]
        [string]$type,

        [parameter(
            Mandatory = $false,
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

    begin {

        #Properties which can be sent in a PUT request, and which can be backfilled from the
        #current scan definition when not specified, so they are not cleared by the request
        #Named distinctly from the -properties parameter: PowerShell variable names are
        #case-insensitive, so a variable named $Properties here would be the same variable as
        #the -properties parameter and would silently overwrite its bound value
        $MergeableProperties = [Collections.Generic.List[String]]@('name', 'type', 'properties', 'locationType', 'credentials',
            'networkId', 'tags', 'recurrenceType', 'recurrenceData', 'state')

    }

    process {

        #Get bound parameters to include in request
        $BoundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove id

        #Get current scan definition property values
        $ExistingScanDefinition = Get-DMDiscoveryScanDefinition -id $id

        if ($null -ne $ExistingScanDefinition) {

            #For any property not included in the request, but present on the existing scan definition,
            #add the existing property value to the request unchanged, so it is not cleared by the PUT request.
            #Values are copied as-is, without flattening, since properties/credentials/recurrenceData are
            #nested objects/arrays whose shape already matches what the API expects in the request body.
            $MergeableProperties | ForEach-Object {

                if ((-not $BoundParameters.ContainsKey($PSItem)) -and ($null -ne $ExistingScanDefinition.$PSItem)) {

                    $BoundParameters[$PSItem] = $ExistingScanDefinition.$PSItem

                }

            }

        }

        if ($BoundParameters.ContainsKey('State')) {

            #PowerShell hashtables are case-insensitive, so "State" & "state" are the same key.
            #The value must be removed before being re-added, otherwise the API's expected
            #lowercase "state" property name is never actually applied to the stored key.
            $StateValue = $BoundParameters['State']
            $BoundParameters.Remove('State')
            $BoundParameters['state'] = $StateValue

        }

        #Ensure array properties are not collapsed to a single value
        'tags', 'credentials' | ForEach-Object {

            if ($BoundParameters.ContainsKey($PSItem)) {

                $BoundParameters[$PSItem] = $BoundParameters[$PSItem] -as [array]

            }

        }

        #Create URL for Request
        $URI = "$(Resolve-RequestUrl)/api/scan-definitions/$id"

        #Create Request Body
        $Body = $BoundParameters | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess($id, 'Update Scan Definition')) {

            #Send request to web service
            Invoke-IDRestMethod -Uri $URI -Method PUT -Body $Body

        }

    }

    end {}

}
