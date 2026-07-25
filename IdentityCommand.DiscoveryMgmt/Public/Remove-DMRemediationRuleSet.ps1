# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Remove-DMRemediationRuleSet {
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
        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovery-rule-sets/$id"

        if ($PSCmdlet.ShouldProcess($id, 'Remove Remediation Rule Set')) {

            #Send Delete request to web service
            Invoke-IDRestMethod -Uri $URI -Method DELETE

        }

    }

    end {}

}
