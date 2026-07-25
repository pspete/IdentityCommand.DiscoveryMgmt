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

            $Parameters = @{Parameter = 'type' }, @{Parameter = 'name' }, @{Parameter = 'content' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command Add-DMDiscoveryScanResource).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

            It 'does not specify parameter locationType as mandatory' {

                (Get-Command Add-DMDiscoveryScanResource).Parameters['locationType'].Attributes.Mandatory | Should -Be $false

            }

        }

        Context 'Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {

                }

            }

            It 'sends request' {

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = @(@{Address = 'sampleaddress.com' }) }

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = @(@{Address = 'sampleaddress.com' }) }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.discoverymgmt_url)/api/discovery-scans/resources"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = @(@{Address = 'sampleaddress.com' }) }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected type & name in body' {

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = @(@{Address = 'sampleaddress.com' }) }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    ($Script:RequestBody.type -eq 'WIN_NIX_LIST') -and ($Script:RequestBody.name -eq 'list_scan_sample.csv')

                } -Times 1 -Exactly -Scope It

            }

            It 'sends a machine list entry built with New-DMDiscoveryScanResourceMachineObject with correctly cased keys' {

                $machineList = @(
                    New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Tags sampleTag
                )

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = $machineList }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    #-ccontains is case-sensitive, confirming the key is exactly "Address", not "address"
                    ($Script:RequestBody.content.machineList[0].Address -eq 'sampleaddress.com') -and
                    ($Script:RequestBody.content.machineList[0].PSObject.Properties.Name -ccontains 'Address')

                } -Times 1 -Exactly -Scope It

            }

            It 'serializes a single machine list entry as a JSON array, not a bare object' {

                $machineList = @(
                    New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com
                )

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = $machineList }

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    $Script:RequestBody.content.machineList -is [array]

                } -Times 1 -Exactly -Scope It

            }

            It 'sends a cloud content object built with New-DMDiscoveryScanResourceCloudObject with correctly cased keys' {

                $content = New-DMDiscoveryScanResourceCloudObject -account 123456789012 -regions us-east-1, eu-west-1 -vpcs vpc-0abc123 -cloud_tags 'env:prod'

                Add-DMDiscoveryScanResource -type INVENTORY_WIN_NIX_LIST -locationType AWS -name aws-inventory-prod -content $content

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Script:RequestBody = $Body | ConvertFrom-Json
                    #-ccontains is case-sensitive, confirming the key is exactly "account", not "Account"
                    ($Script:RequestBody.content.account -eq '123456789012') -and
                    ($Script:RequestBody.locationType -eq 'AWS') -and
                    ($Script:RequestBody.content.PSObject.Properties.Name -ccontains 'account')

                } -Times 1 -Exactly -Scope It

            }

            It 'does not send a request when WhatIf is specified' {

                Add-DMDiscoveryScanResource -type WIN_NIX_LIST -name list_scan_sample.csv -content @{machineList = @(@{Address = 'sampleaddress.com' }) } -WhatIf

                Assert-MockCalled Invoke-IDRestMethod -Times 0 -Exactly -Scope It

            }

        }

    }

}
