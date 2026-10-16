# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Add-DMDiscoveryScanResource {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('WIN_NIX_LIST', 'SQL_SERVER', 'ORACLE', 'MYSQL', 'POSTGRESQL', 'INVENTORY_WIN_NIX_LIST')]
        [string]$type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$content,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('AWS', 'AZURE')]
        [string]$locationType
    )

    process {

        #Create URL for Request
        $URI = "$(Resolve-RequestUrl)/api/discovery-scans/resources"

        #Get bound parameters to include in request
        $BoundParameters = $PSBoundParameters | Get-Parameter

        #Ensure a single machine list entry is not collapsed to a JSON object instead of an array
        if ($BoundParameters['content'].ContainsKey('machineList')) {

            $BoundParameters['content']['machineList'] = $BoundParameters['content']['machineList'] -as [array]

        }

        #Create Request Body
        $Body = $BoundParameters | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess($name, 'Add Discovery Scan Resource')) {

            #Send request to web service
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        }

    }

    end {}

}
