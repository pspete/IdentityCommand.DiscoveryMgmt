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

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'Mandatory Parameters' {

            $Parameters = @{Parameter = 'account' }

            It 'specifies parameter <Parameter> as mandatory for the AWS parameter set' -TestCases $Parameters {

                param($Parameter)

                (Get-Command New-DMDiscoveryScanResourceCloudObject).ParameterSets |
                    Where-Object { $_.Name -eq 'AWS' } |
                    ForEach-Object { $_.Parameters | Where-Object { $_.Name -eq $Parameter } } |
                    ForEach-Object { $_.IsMandatory } | Should -Be $true

            }

            It 'specifies parameter subscription_id as mandatory for the AZURE parameter set' {

                (Get-Command New-DMDiscoveryScanResourceCloudObject).ParameterSets |
                    Where-Object { $_.Name -eq 'AZURE' } |
                    ForEach-Object { $_.Parameters | Where-Object { $_.Name -eq 'subscription_id' } } |
                    ForEach-Object { $_.IsMandatory } | Should -Be $true

            }

        }

        Context 'AWS' {

            It 'does not throw' {

                { New-DMDiscoveryScanResourceCloudObject -account 123456789012 } | Should -Not -Throw

            }

            It 'outputs expected object type' {

                New-DMDiscoveryScanResourceCloudObject -account 123456789012 | Should -BeOfType Hashtable

            }

            It 'has expected value for account, regions, vpcs & cloud_tags' {

                $result = New-DMDiscoveryScanResourceCloudObject -account 123456789012 -regions us-east-1, eu-west-1 -vpcs vpc-0abc123, vpc-0def456 -cloud_tags 'env:prod', 'team:platform'
                $result['account'] | Should -Be '123456789012'
                $result['regions'] | Should -Be @('us-east-1', 'eu-west-1')
                $result['vpcs'] | Should -Be @('vpc-0abc123', 'vpc-0def456')
                $result['cloud_tags'] | Should -Be @('env:prod', 'team:platform')

            }

            It 'does not include AZURE-only parameters' {

                $result = New-DMDiscoveryScanResourceCloudObject -account 123456789012
                $result.ContainsKey('subscription_id') | Should -Be $false
                $result.ContainsKey('resource_groups') | Should -Be $false
                $result.ContainsKey('vnet_ids') | Should -Be $false

            }

            It 'uses the exact vendor key casing' {

                $result = New-DMDiscoveryScanResourceCloudObject -account 123456789012
                $result.Keys -ccontains 'account' | Should -Be $true
                $result.Keys -ccontains 'Account' | Should -Be $false

            }

        }

        Context 'AZURE' {

            It 'does not throw' {

                { New-DMDiscoveryScanResourceCloudObject -subscription_id aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee } | Should -Not -Throw

            }

            It 'has expected value for subscription_id, resource_groups & vnet_ids' {

                $result = New-DMDiscoveryScanResourceCloudObject -subscription_id aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee -resource_groups rg-prod-1 -vnet_ids vnet-prod -regions eastus
                $result['subscription_id'] | Should -Be 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
                $result['resource_groups'] | Should -Be 'rg-prod-1'
                $result['vnet_ids'] | Should -Be 'vnet-prod'
                $result['regions'] | Should -Be 'eastus'

            }

            It 'does not include AWS-only parameters' {

                $result = New-DMDiscoveryScanResourceCloudObject -subscription_id aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
                $result.ContainsKey('account') | Should -Be $false
                $result.ContainsKey('vpcs') | Should -Be $false

            }

        }

    }

}
