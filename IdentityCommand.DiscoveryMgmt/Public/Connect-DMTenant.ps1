Function Connect-DMTenant {

    [CmdletBinding()]
    param(

        #The tenant subdomain shared by the discoverymgmt & privilegecloud hosts
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$subdomain

    )

    BEGIN {

        $IDSession = Get-IDSession
        if ($null -eq $IDSession.tenant_url) {
            throw 'Authenticate with New-IDSession or New-IDPlatformToken and try again'
        }

    }#begin

    PROCESS {

        #Ensure subdomain is in expected format
        #Remove trailing space if provided
        $subdomain = $subdomain -replace '/$', ''

        #Make the CyberArk Identity Session available in the IdentityCommand.DiscoveryMgmt scope
        foreach ($key in $IDSession.keys) {
            if ($null -ne $IDSession[$key]) {
                $ISPSSSession[$key] = $IDSession[$key]
            }
        }

        #Set the DiscoveryMgmt & PrivilegeCloud URLs in the session data
        $ISPSSSession.discoverymgmt_url = "https://$subdomain.discoverymgmt.cyberark.cloud"
        $ISPSSSession.privilegecloud_url = "https://$subdomain.privilegecloud.cyberark.cloud"

    }#process

    END { }#end

}
