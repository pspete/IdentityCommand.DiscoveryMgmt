# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Test-DMDiscoveredLocalAccount {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'single'
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
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'single'
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
        [string]$subtype,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'single'
        )]
        [hashtable]$identifiers,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'single'
        )]
        [string]$externalId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'multiple'
        )]
        [hashtable[]]$accounts

    )

    process {

        #Create URL for Request
        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts/check-existence"

        #Get Parameters to include in request
        $boundParameters = $PSBoundParameters | Get-Parameter

        switch ($PSCmdlet.ParameterSetName) {

            'single' {

                if (-not (Test-DMDiscoveredAccountIdentifier -Type $type -SubType $subtype -Identifiers $identifiers)) {

                    Write-Warning "The supplied identifiers may not match the expected identifiers for $type/$subtype - see Get-DMDiscoveredAccountTypeMap for reference."

                }

                $body = @{'account' = @($boundParameters) } | ConvertTo-Json -Depth 3

                break

            }

            'multiple' {

                foreach ($Account in $accounts) {

                    if ($Account.ContainsKey('type') -and $Account.ContainsKey('subType') -and
                        -not (Test-DMDiscoveredAccountIdentifier -Type $Account['type'] -SubType $Account['subType'] -Identifiers $Account['identifiers'])) {

                        Write-Warning "Account '$($Account['externalId'])' may not have identifiers matching the expected shape for $($Account['type'])/$($Account['subType']) - see Get-DMDiscoveredAccountTypeMap for reference."

                    }

                }

                $body = $boundParameters | ConvertTo-Json -Depth 3

                break

            }

        }

        #Send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -body $body

        if ($null -ne $Result) {

            #Return result
            $Result

        }

    }

    end {}

}
