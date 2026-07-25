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

            $Parameters = @{Parameter = 'Address' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command New-DMDiscoveryScanResourceMachineObject).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'General' {

            It 'does not throw' {

                { New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com } | Should -Not -Throw

            }

            It 'outputs expected object type' {

                New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com | Should -BeOfType Hashtable

            }

            It 'has expected value for Address' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com
                $result['Address'] | Should -Be 'sampleaddress.com'

            }

            It 'has expected value for Port as an integer' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Port 1433
                $result['Port'] | Should -Be 1433
                $result['Port'] | Should -BeOfType Int32

            }

            It 'has expected value for Tags' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Tags sampleTag
                $result['Tags'] | Should -Be 'sampleTag'

            }

            It 'has expected value for Username, Database, Domain & Instances' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address address1.com -Username domainUserName -Database DatabaseName1 -Domain Domain.com -Instances '*'
                $result['Username'] | Should -Be 'domainUserName'
                $result['Database'] | Should -Be 'DatabaseName1'
                $result['Domain'] | Should -Be 'Domain.com'
                $result['Instances'] | Should -Be '*'

            }

            It 'uses the exact vendor key casing' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com -Username sampleUserName -Database sampleDatabaseName -Port 1433 -Domain Domain.com -Tags sampleTag -Instances '*'
                $result.Keys | Should -Contain 'Address'
                $result.Keys -ccontains 'Address' | Should -Be $true
                $result.Keys -ccontains 'address' | Should -Be $false

            }

            It 'does not include unspecified optional parameters in the returned object' {

                $result = New-DMDiscoveryScanResourceMachineObject -Address sampleaddress.com
                $result.ContainsKey('Username') | Should -Be $false
                $result.ContainsKey('Database') | Should -Be $false
                $result.ContainsKey('Port') | Should -Be $false
                $result.ContainsKey('Domain') | Should -Be $false
                $result.ContainsKey('Tags') | Should -Be $false
                $result.ContainsKey('Instances') | Should -Be $false

            }

        }

    }

}
