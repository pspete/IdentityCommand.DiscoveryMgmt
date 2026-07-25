# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function New-DMDiscoveryScanResourceCloudObject {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'AWS')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string]$account,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [string[]]$vpcs,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [string]$subscription_id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [string[]]$resource_groups,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [string[]]$vnet_ids,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [string[]]$regions,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AWS'
        )]
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'AZURE'
        )]
        [string[]]$cloud_tags
    )

    process {

        #Get bound parameters to include in the returned object
        $boundParameters = $PSBoundParameters | Get-Parameter

        if ($PSCmdlet.ParameterSetName -eq 'AWS') {
            $ShouldProcessTarget = $account
        } else {
            $ShouldProcessTarget = $subscription_id
        }

        if ($PSCmdlet.ShouldProcess($ShouldProcessTarget, 'Create Discovery Scan Resource Cloud Object')) {

            $boundParameters

        }

    }

    end {}

}
