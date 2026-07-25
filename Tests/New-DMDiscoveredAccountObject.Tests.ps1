Describe $($PSCommandPath -Replace '.Tests.ps1') {

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

            $Parameters = @{Parameter = 'type' }, @{Parameter = 'subType' }, @{Parameter = 'identifiers' }, @{Parameter = 'externalId' }

            It 'specifies parameter <Parameter> as mandatory' -TestCases $Parameters {

                param($Parameter)

                (Get-Command New-DMDiscoveredAccountObject).Parameters["$Parameter"].Attributes.Mandatory | Should -Be $true

            }

        }

        Context 'General' {

            BeforeEach {

                Mock Write-Warning -MockWith {}

                $InputObj = [PSCustomObject]@{
                    'type'        = 'Windows'
                    'subType'     = 'Domain'
                    'identifiers' = @{'address' = 'win-computer.cyber-ark.com'; 'username' = 'admin' }
                    'externalId'  = 'user_account_5924'
                }

            }

            It 'does not throw' {

                { $InputObj | New-DMDiscoveredAccountObject } | Should -Not -Throw

            }

            It 'outputs expected object type' {
                $InputObj | New-DMDiscoveredAccountObject | Should -BeOfType Hashtable
            }

            It 'has output with expected number of keys' {
                $result = $InputObj | New-DMDiscoveredAccountObject
                $result.keys.count | Should -Be 4
            }

            It 'has expected value for type' {
                $result = $InputObj | New-DMDiscoveredAccountObject
                $result['type'] | Should -Be 'Windows'
            }

            It 'has expected value for subType' {
                $result = $InputObj | New-DMDiscoveredAccountObject
                $result['subType'] | Should -Be 'Domain'
            }

            It 'has expected value for externalId' {
                $result = $InputObj | New-DMDiscoveredAccountObject
                $result['externalId'] | Should -Be 'user_account_5924'
            }

            It 'has expected value for identifiers' {
                $result = $InputObj | New-DMDiscoveredAccountObject
                $result['identifiers']['address'] | Should -Be 'win-computer.cyber-ark.com'
                $result['identifiers']['username'] | Should -Be 'admin'
            }

            It 'does not warn when identifiers match the expected shape' {

                $InputObj | New-DMDiscoveredAccountObject
                Assert-MockCalled Write-Warning -Times 0 -Exactly -Scope It

            }

            It 'warns when identifiers do not match the expected shape' {

                [PSCustomObject]@{
                    'type'        = 'Windows'
                    'subType'     = 'Domain'
                    'identifiers' = @{'username' = 'admin' }
                    'externalId'  = 'user_account_5924'
                } | New-DMDiscoveredAccountObject

                Assert-MockCalled Write-Warning -Times 1 -Exactly -Scope It

            }

            It 'builds a non-address/username shaped object, e.g. AWS' {

                $result = New-DMDiscoveredAccountObject -type AWS -subType Password -identifiers @{username = 'someuser' } -externalId aws_account_1
                $result['identifiers']['username'] | Should -Be 'someuser'

            }

        }

        Context 'type/subType ArgumentCompleter' {

            It 'provides an ArgumentCompleter for the type parameter' {

                (Get-Command New-DMDiscoveredAccountObject).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Should -Not -BeNullOrEmpty

            }

            It 'provides an ArgumentCompleter for the subType parameter' {

                (Get-Command New-DMDiscoveredAccountObject).Parameters['subType'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Should -Not -BeNullOrEmpty

            }

            It 'completes type values' {

                $Completer = (Get-Command New-DMDiscoveredAccountObject).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'New-DMDiscoveredAccountObject' -parameterName 'type' -wordToComplete 'Win' -commandAst $null -fakeBoundParameters @{}

                $Result.CompletionText | Should -Contain 'Windows'

            }

            It 'narrows subType completions based on the bound type value' {

                $Completer = (Get-Command New-DMDiscoveredAccountObject).Parameters['subType'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'New-DMDiscoveredAccountObject' -parameterName 'subType' -wordToComplete '' -commandAst $null -fakeBoundParameters @{type = 'Windows' }

                $Result.CompletionText | Should -Contain 'Domain'
                $Result.CompletionText | Should -Not -Contain 'Password'

            }

            It 'returns every subType when type has not been typed yet' {

                $Completer = (Get-Command New-DMDiscoveredAccountObject).Parameters['subType'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'New-DMDiscoveredAccountObject' -parameterName 'subType' -wordToComplete '' -commandAst $null -fakeBoundParameters @{}

                $Result.CompletionText | Should -Contain 'Domain'
                $Result.CompletionText | Should -Contain 'Password'

            }

        }

    }

}
