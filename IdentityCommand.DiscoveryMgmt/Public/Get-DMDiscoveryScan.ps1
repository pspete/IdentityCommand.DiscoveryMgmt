# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Get-DMDiscoveryScan {
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
        $URI = "$(Resolve-RequestUrl)/api/scan-instances/$id"

        #Send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $Result) {

            $Result

        }

    }

    end {}

}
