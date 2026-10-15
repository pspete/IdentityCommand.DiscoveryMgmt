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

                (Get-Command Get-DMDiscoveryScanResource).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                    [pscustomobject]@{
                        'id'          = 'resource-id-999'
                        'type'        = 'WIN_NIX_LIST'
                        'name'        = 'test.csv'
                        'createdAt'   = '2025-01-01T00:00:00Z'
                        'resourceUrl' = 'https://presigned_url'
                    }

                }

            }

            It 'sends request' {

                Get-DMDiscoveryScanResource -id resource-id-999

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Get-DMDiscoveryScanResource -id resource-id-999

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.tenant_url)/api/discovery-scans/resources/resource-id-999"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Get-DMDiscoveryScanResource -id resource-id-999

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'GET' } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                Get-DMDiscoveryScanResource -id resource-id-999 | Should -Not -BeNullOrEmpty

            }

            It 'returns the raw API response unmodified' {

                $result = Get-DMDiscoveryScanResource -id resource-id-999
                $result.resourceUrl | Should -Be 'https://presigned_url'

            }

        }

    }

}
