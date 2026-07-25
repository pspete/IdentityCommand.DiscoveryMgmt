# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function New-DMDiscoveredAccountObject {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

                #Avoid PSScriptAnalyzer PSReviewUnusedParameter rule on standard ArgumentCompleter parameters.
                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

                Get-DMDiscoveredAccountTypeCompletion -Property Type -WordToComplete $wordToComplete

            })]
        [string]$type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

                #Avoid PSScriptAnalyzer PSReviewUnusedParameter rule on standard ArgumentCompleter parameters.
                $null = $commandName, $parameterName, $commandAst

                if ($fakeBoundParameters['type']) {

                    Get-DMDiscoveredAccountTypeCompletion -Property SubType -WordToComplete $wordToComplete -Type $fakeBoundParameters['type']

                } else {

                    Get-DMDiscoveredAccountTypeCompletion -Property SubType -WordToComplete $wordToComplete

                }

            })]
        [string]$subType,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$identifiers,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$externalId
    )

    process {

        #Get all parameters that will be used to build the object
        $boundParameters = $PSBoundParameters | Get-Parameter

        if (-not (Test-DMDiscoveredAccountIdentifier -Type $type -SubType $subType -Identifiers $identifiers)) {

            Write-Warning "The supplied identifiers may not match the expected identifiers for $type/$subType - see Get-DMDiscoveredAccountTypeMap for reference."

        }

        if ($PSCmdlet.ShouldProcess($externalId, 'Create Discovered Account Object Definition')) {

            $boundParameters

        }

    }#process

    end {}

}
