# .ExternalHelp IdentityCommand.DiscoveryMgmt-help.xml
function Get-DMDiscoveredLocalAccount {
    [CmdletBinding(DefaultParameterSetName = 'byQuery')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byID'
        )]
        [string]$id,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [string]$search,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [boolean]$searchOnAllFields,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [string]$type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [string]$subtype,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [boolean]$isPrivileged,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [string]$lastDiscoveryRulesStatus,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [boolean]$extendedDetails,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [string]$sort,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byQuery'
        )]
        [int]$limit

    )

    begin {

        #Parameter to include as filter value in url
        $Parameters = [Collections.Generic.List[String]]@('type', 'subtype', 'isPrivileged', 'lastDiscoveryRulesStatus')

    }

    process {

        #Create URL for Request
        $URI = "$($ISPSSSession.privilegecloud_url)/api/discovered-accounts"

        switch ($PSCmdlet.ParameterSetName) {

            'byID' {

                $URI = "$URI/$id"

                break

            }

            'byQuery' {

                #Get Parameters to include in request
                $boundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove $Parameters
                $filterParameters = $PSBoundParameters | Get-Parameter -ParametersToKeep $Parameters
                $FilterString = $filterParameters | ConvertTo-FilterString

                if ($null -ne $FilterString) {

                    $boundParameters = $boundParameters + $FilterString

                }

                #Create Query String, escaped for inclusion in request URL
                $queryString = $boundParameters | ConvertTo-QueryString

                if ($null -ne $queryString) {

                    #Build URL from base URL
                    $URI = "$URI`?$queryString"

                }

                break

            }

        }

        #Send request to web service
        $result = Invoke-IDRestMethod -Uri $URI -Method GET

        if ($null -ne $Result) {

            if ($PSCmdlet.ParameterSetName -eq 'byQuery') {

                #Process nextlink if querying
                $Result = $Result | Get-NextLink -BaseURI $ISPSSSession.privilegecloud_url

            }

            #Return result
            $Result

        }

    }

    end {}

}
