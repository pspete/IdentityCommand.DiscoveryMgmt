# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Clear-DMDiscoveredLocalAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    process {

        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts/clear"

        if ($PSCmdlet.ShouldProcess('Discovered Local Account List', 'Delete')) {

            Invoke-IDRestMethod -Uri $URI -Method DELETE

        }

    }#process

    end { }#end
}
