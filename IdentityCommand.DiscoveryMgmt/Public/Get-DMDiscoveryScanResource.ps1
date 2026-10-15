# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Get-DMDiscoveryScanResource {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$id
    )

    process {

        #Create URL for Request
        $URI = "$(Resolve-RequestUrl)/api/discovery-scans/resources/$id"

        #Send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $Result) {

            $Result

        }

    }

    end {}

}
