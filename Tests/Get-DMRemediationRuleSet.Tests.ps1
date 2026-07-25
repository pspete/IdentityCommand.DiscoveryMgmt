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
            discoverymgmt_url  = 'https://sometenant.discoverymgmt.cyberark.cloud'
            privilegecloud_url = 'https://sometenant.privilegecloud.cyberark.cloud'
            User               = $null
            WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            StartTime          = $null
            ElapsedTime        = $null
            LastCommand        = $null
            LastCommandTime    = $null
            LastCommandResults = $null
        }

        New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

    }


    AfterAll {

        $Script:RequestBody = $null

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'Mandatory Parameters' {

            $Parameters = @{Parameter = 'ID' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command Get-DMRemediationRuleSet).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }



        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                }

                $InputObj = [pscustomobject]@{
                    'ID' = '99_9'

                }


            }

            It 'sends request - byID ParameterSet' {

                Get-DMRemediationRuleSet -Id '99_9'

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request - GetAllRemediationRuleSets ParameterSet' {

                Get-DMRemediationRuleSet

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - byID ParameterSet' {

                Get-DMRemediationRuleSet -Id '99_9'

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovery-rule-sets/99_9"

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - GetAllRemediationRuleSets ParameterSet' {

                Get-DMRemediationRuleSet

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovery-rule-sets?Limit=50"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Get-DMRemediationRuleSet

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'GET' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Get-DMRemediationRuleSet

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

            It 'sends expected query' {

                Get-DMRemediationRuleSet -search SomeTerm

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'search=SomeTerm' -and $URI -match 'Limit=50'

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort direction is specified' {

                Get-DMRemediationRuleSet -sort name -sortDirection desc

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=name%20-%20desc'

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort direction is specified without a sort property' {

                Get-DMRemediationRuleSet -sortDirection desc

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=id%20-%20desc'

                } -Times 1 -Exactly -Scope It
            }

            It 'sends expected query when sort property is specified without a sort direction' {

                Get-DMRemediationRuleSet -sort name

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'sort=name%20-%20asc'

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
                $response = Get-DMRemediationRuleSet -id 'SomeID'
                $response | Should -Not -Be null

            }

            It 'outputs expected number of results' {

                $response = Get-DMRemediationRuleSet -id 'SomeID'
                @($response).Count | Should -Be 1

            }

        }

        Context 'Output - GetAllRemediationRuleSets' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    1..100 | ForEach-Object {
                        [pscustomobject]@{
                            'Property' = "Value$_"
                            'item'     = "Value2_$_"

                        }


                    }

                }

            }

            It 'provides output' {

                $response = Get-DMRemediationRuleSet
                $response | Should -Not -Be null

            }

            It 'outputs expected number of results' {

                $response = Get-DMRemediationRuleSet
                $response.Count | Should -Be 200

            }

        }

    }

}
