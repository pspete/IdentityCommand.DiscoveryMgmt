# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Remove-DMDiscoveryScanDefinition {
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
        $URI = "$(Resolve-RequestUrl)/api/scan-definitions/$id"

        if ($PSCmdlet.ShouldProcess($id, 'Remove Scan Definition')) {

            #Send Delete request to web service
            Invoke-IDRestMethod -Uri $URI -Method DELETE

        }

    }

    end {}

}
