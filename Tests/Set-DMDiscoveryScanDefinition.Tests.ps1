Describe $($PSCommandPath -replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Assume ModuleName from Repository Root folder
        $ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

        $Script:RequestBody = $null
        $ISPSSSession = [ordered]@{
            tenant_url         = 'https://sometenant.discoverymgmt.cyberark.cloud'
            User               = $null
            WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            StartTime          = $null
            ElapsedTime        = $null
            LastCommand        = $null
            LastCommandTime    = $null
            LastCommandResults = $null
        }

        InModuleScope $ModuleName -Parameters @{ Session = $ISPSSSession } {
            param($Session)
            New-Variable -Name ISPSSSession -Value $Session -Scope Script -Force
        }

    }


    AfterAll {

        $Script:RequestBody = $null

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'Mandatory Parameters' {

            $Parameters = @{Parameter = 'id' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command Set-DMDiscoveryScanDefinition).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                }

                Mock Get-DMDiscoveryScanDefinition -MockWith {

                    [pscustomobject]@{
                        'id'             = 'sd_1'
                        'name'           = 'ExistingName'
                        'type'           = 'WIN_NIX_LIST'
                        'properties'     = [pscustomobject]@{
                            'domain'   = 'existing.com'
                            'resource' = [pscustomobject]@{
                                'id'   = 'resource-id-999'
                                'name' = 'test.csv'
                            }
                        }
                        'credentials'    = @([pscustomobject]@{
                                'name'       = 'DOMAIN_ADMIN'
                                'type'       = 'ACCOUNT'
                                'properties' = [pscustomobject]@{'account_id' = '10_3' }
                            })
                        'networkId'      = 'net-1'
                        'tags'           = @('tag1')
                        'recurrenceType' = 'RECURRING'
                        'recurrenceData' = [pscustomobject]@{
                            'date'          = '2025-12-15'
                            'times'         = @('13:30')
                            'timeZone'      = 'US'
                            'repeatPattern' = 'DAILY'
                        }
                        'state'          = 'ACTIVE'
                        'creationTime'   = '2025-01-01T00:00:00Z'
                        'updateTime'     = '2025-01-01T00:00:00Z'
                        'isMigrated'     = $false
                    }

                }

            }

            It 'sends request' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'gets the existing scan definition' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Get-DMDiscoveryScanDefinition -ParameterFilter { $id -eq 'sd_1' } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/scan-definitions/sd_1"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'PUT' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with the overridden value' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    $Script:RequestBody.networkId -eq 'net-2'

                } -Times 1 -Exactly -Scope It

            }

            It 'backfills the existing nested properties object unchanged when not specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.properties.domain -eq 'existing.com') -and
                    ($Script:RequestBody.properties.resource.id -eq 'resource-id-999')

                } -Times 1 -Exactly -Scope It

            }

            It 'does not leak a nested id value to the top level of the request body' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    -not ($Script:RequestBody.PSObject.Properties.Name -contains 'id')

                } -Times 1 -Exactly -Scope It

            }

            It 'backfills the existing recurrenceData object unchanged when not specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.recurrenceData.repeatPattern -eq 'DAILY') -and
                    ($Script:RequestBody.recurrenceType -eq 'RECURRING')

                } -Times 1 -Exactly -Scope It

            }

            It 'backfills existing credentials unchanged when not specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    $Script:RequestBody.credentials[0].properties.account_id -eq '10_3'

                } -Times 1 -Exactly -Scope It

            }

            It 'fully replaces properties instead of merging when specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -properties @{'domain' = 'new.com' }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.properties.domain -eq 'new.com') -and
                    (-not ($Script:RequestBody.properties.PSObject.Properties.Name -contains 'resource'))

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with a lowercase state property when State is specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -State INACTIVE

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    #-contains is case-insensitive, so a case-sensitive check is required to confirm
                    #the property name is exactly lowercase "state", not "State"
                    ($Script:RequestBody.state -eq 'INACTIVE') -and ($Script:RequestBody.PSObject.Properties.Name -ccontains 'state')

                } -Times 1 -Exactly -Scope It

            }

            It 'backfills the existing state value when State is not specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    $Script:RequestBody.state -eq 'ACTIVE'

                } -Times 1 -Exactly -Scope It

            }

            It 'does not send a request when WhatIf is specified' {

                Set-DMDiscoveryScanDefinition -id sd_1 -networkId net-2 -WhatIf

                Assert-MockCalled Invoke-IDRestMethod -Times 0 -Exactly -Scope It

            }

        }

    }

}
