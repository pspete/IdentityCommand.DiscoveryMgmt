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

            $Parameters = @{Parameter = 'ID' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command Get-DMDiscoveryScanDefinition).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                }

            }

            It 'sends request - byID ParameterSet' {

                Get-DMDiscoveryScanDefinition -Id '99_9'

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request - GetAllScanDefinitions ParameterSet' {

                Get-DMDiscoveryScanDefinition

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - byID ParameterSet' {

                Get-DMDiscoveryScanDefinition -Id '99_9'

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/scan-definitions/99_9"

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - GetAllScanDefinitions ParameterSet' {

                Get-DMDiscoveryScanDefinition

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/scan-definitions"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Get-DMDiscoveryScanDefinition

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'GET' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Get-DMDiscoveryScanDefinition

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

            It 'sends expected filter' {

                Get-DMDiscoveryScanDefinition -Type SomeType

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/scan-definitions?filter=type%20eq%20SomeType"

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query' {

                Get-DMDiscoveryScanDefinition -search SomeTerm

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/scan-definitions?search=SomeTerm"

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort property and sort direction are specified' {

                Get-DMDiscoveryScanDefinition -sort name -sortDirection desc

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=name%20-%20desc'

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort direction is specified without a sort property' {

                Get-DMDiscoveryScanDefinition -sortDirection desc

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=creationTime%20-%20desc'

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort property is specified without a sort direction' {

                Get-DMDiscoveryScanDefinition -sort name

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=name%20-%20asc'

                } -Times 1 -Exactly -Scope It
            }

            It 'throws if an extended-only sort property is specified without extendedDetails' {

                { Get-DMDiscoveryScanDefinition -sort lastInstanceStatus } | Should -Throw

            }

            It 'sends expected query when an extended-only sort property is specified with extendedDetails' {

                Get-DMDiscoveryScanDefinition -sort lastInstanceStatus -extendedDetails $true

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=lastInstanceStatus%20-%20asc'

                } -Times 1 -Exactly -Scope It
            }

        }

        Context 'Output - ById' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    @{
                        'Property1' = 'Value'
                        'item'      = 'Value2'

                    }

                }

            }

            It 'provides output' {
                $response = Get-DMDiscoveryScanDefinition -id 'SomeID'
                $response | Should -Not -Be null

            }

            It 'outputs expected number of results' {

                $response = Get-DMDiscoveryScanDefinition -id 'SomeID'
                @($response).Count | Should -Be 1

            }

        }

        Context 'Output - GetAllScanDefinitions' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    @{
                        'totalCount' = 300
                        'items'      = 1..100

                    }

                }

            }

            It 'provides output' {

                $response = Get-DMDiscoveryScanDefinition
                $response | Should -Not -Be null

            }

            It 'outputs expected number of results' {

                $response = Get-DMDiscoveryScanDefinition
                $response.Count | Should -Be 100

            }

        }

    }

}
