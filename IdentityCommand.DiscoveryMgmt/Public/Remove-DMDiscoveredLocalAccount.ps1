# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Remove-DMDiscoveredLocalAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$id
    )

    process {

        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts/$id"

        if ($PSCmdlet.ShouldProcess("Discovered Local Account: $id", 'Delete')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE

        }

    }#process

    end { }#end
}
