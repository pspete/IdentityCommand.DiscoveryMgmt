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

            $Parameters = @{Parameter = 'name' }, @{Parameter = 'type' }, @{Parameter = 'properties' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command Add-DMDiscoveryScanDefinition).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                }

                $properties = @{
                    'domain' = 'company.com'
                    'ou'     = 'cn=mygroup'
                    'targets' = @{
                        'domainController' = $true
                        'nonPrivileged'     = $true
                    }
                }

                $credentials = @(
                    @{
                        'name'       = 'DOMAIN_ADMIN'
                        'type'       = 'ACCOUNT'
                        'properties' = @{'account_id' = '111_5' }
                    }
                )

            }

            It 'sends request' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.discoverymgmt_url)/api/scan-definitions"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected name & type in body' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.name -eq 'SomeScan') -and ($Script:RequestBody.type -eq 'WIN_NIX_DOMAIN')

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected nested properties in body' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties -credentials $credentials -recurrenceType IMMEDIATE

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.properties.domain -eq 'company.com') -and
                    ($Script:RequestBody.properties.targets.domainController -eq $true) -and
                    ($Script:RequestBody.credentials[0].properties.account_id -eq '111_5') -and
                    ($Script:RequestBody.recurrenceType -eq 'IMMEDIATE')

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with a lowercase state property when State is specified' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties -State ACTIVE

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    #-contains is case-insensitive, so a case-sensitive check is required to confirm
                    #the property name is exactly lowercase "state", not "State"
                    ($Script:RequestBody.state -eq 'ACTIVE') -and ($Script:RequestBody.PSObject.Properties.Name -ccontains 'state')

                } -Times 1 -Exactly -Scope It

            }

            It 'does not send a request when WhatIf is specified' {

                Add-DMDiscoveryScanDefinition -name SomeScan -type WIN_NIX_DOMAIN -properties $properties -WhatIf

                Assert-MockCalled Invoke-IDRestMethod -Times 0 -Exactly -Scope It

            }

        }

    }

}
