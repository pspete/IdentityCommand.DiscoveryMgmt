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

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'General' {

            It 'does not throw' {

                { Get-DMDiscoveredAccountTypeMap } | Should -Not -Throw

            }

            It 'returns objects with the expected properties' {

                $result = Get-DMDiscoveredAccountTypeMap | Select-Object -First 1
                $result.PSObject.Properties.Name | Should -Contain 'Type'
                $result.PSObject.Properties.Name | Should -Contain 'SubType'
                $result.PSObject.Properties.Name | Should -Contain 'Identifiers'
                $result.PSObject.Properties.Name | Should -Contain 'OptionalIdentifiers'
                $result.PSObject.Properties.Name | Should -Contain 'Notes'

            }

            It 'returns more than one row' {

                (Get-DMDiscoveredAccountTypeMap).Count | Should -BeGreaterThan 1

            }

            It 'filters by Type' {

                $result = Get-DMDiscoveredAccountTypeMap -Type Windows
                $result.Count | Should -BeGreaterThan 1
                ($result.Type | Select-Object -Unique) | Should -Be 'Windows'

            }

            It 'filters by Type & SubType to a single row' {

                $result = Get-DMDiscoveredAccountTypeMap -Type Windows -SubType Domain
                @($result).Count | Should -Be 1

            }

            It 'ignores SubType when Type is not specified' {

                (Get-DMDiscoveredAccountTypeMap -SubType Domain).Count | Should -BeGreaterThan 1

            }

            It 'has DSN as an optional identifier for SQLServer/Password' {

                $result = Get-DMDiscoveredAccountTypeMap -Type SQLServer -SubType Password
                $result.OptionalIdentifiers | Should -Contain 'DSN'

            }

            It 'has UserDN, not Username, as an identifier for NovelleDirectory/Password' {

                $result = Get-DMDiscoveredAccountTypeMap -Type NovelleDirectory -SubType Password
                $result.Identifiers | Should -Contain 'UserDN'
                $result.Identifiers | Should -Not -Contain 'Username'

            }

            It 'does not enforce the prose-only AWS Account ID identifier for AWS/Password' {

                $result = Get-DMDiscoveredAccountTypeMap -Type AWS -SubType Password
                $result.Identifiers | Should -Be @('Username')
                $result.Notes | Should -Not -BeNullOrEmpty

            }

        }

    }

}
