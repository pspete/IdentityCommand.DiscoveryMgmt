# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Start-DMDiscoveryScan {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$id
    )

    process {

        #Create URL for Request
        $URI = "$($ISPSSSession.discoverymgmt_url)/api/scan-instances"

        $Body = $PSBoundParameters | Get-Parameter | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($id, 'Start Discovery Scan')) {

            #Send Delete request to web service
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        }

    }

    end {}

}
