# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function New-DMDiscoveryScanResourceMachineObject {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Address,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Username,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Database,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [int]$Port,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Domain,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string[]]$Tags,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$Instances
    )

    process {

        #Get bound parameters to include in the returned object
        $boundParameters = $PSBoundParameters | Get-Parameter

        if ($PSCmdlet.ShouldProcess($Address, 'Create Discovery Scan Resource Machine Object')) {

            $boundParameters

        }

    }

    end {}

}
