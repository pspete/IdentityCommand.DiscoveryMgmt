# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Get-DMDiscoveredLocalAccountActivity {
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
        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts/$id/activities"

        #Send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $Result) {

            #Return result
            $Result

        }

    }

    end {}

}
