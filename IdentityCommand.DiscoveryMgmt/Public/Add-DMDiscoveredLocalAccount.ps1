# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Add-DMDiscoveredLocalAccount {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

                #Avoid PSScriptAnalyzer PSReviewUnusedParameter rule on standard ArgumentCompleter parameters.
                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

                Get-DMDiscoveredAccountTypeCompletion -Property Type -WordToComplete $wordToComplete -SubType Loosely

            })]
        [string]$type,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$identifiers,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [boolean]$isPrivileged,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [hashtable]$customProperties,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$source
    )

    process {

        #Create URL for Request
        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts/"

        #Get all parameters that will be sent in the request
        $boundParameters = $PSBoundParameters | Get-Parameter

        #Add subType key with loosely value
        $boundParameters.Add('subType', 'loosely')

        if (-not (Test-DMDiscoveredAccountIdentifier -Type $type -SubType 'loosely' -Identifiers $identifiers)) {

            Write-Warning "The supplied identifiers may not match the expected identifiers for $type/loosely - see Get-DMDiscoveredAccountTypeMap for reference."

        }

        $Body = $boundParameters | ConvertTo-Json

        #send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method PUT -Body $Body

        if ($null -ne $result) {

            #Return Results
            $result

        }

    }#process

    end { }#end

}
