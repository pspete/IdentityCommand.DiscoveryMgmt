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

        Context 'Request Input' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    Write-Output @{ }
                }

                Mock Write-Warning -MockWith {}

                $InputObject = @{
                    'type'        = 'Windows'
                    'subtype'     = 'Domain'
                    'identifiers' = @{'address' = 'someaddress'; 'username' = 'someusername' }
                    'externalId'  = 'someexternalid'
                }

            }

            It 'sends request - single parameterset' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - single parameterset' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovered-accounts/check-existence"

                }

            }

            It 'sends request using expected method' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body - single parameterset' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -ne $null } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected identifiers in body - single parameterset' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -match 'identifiers' -and $Body -match 'someaddress' -and $Body -match 'someusername' } -Times 1 -Exactly -Scope It

            }

            It 'does not warn when identifiers match the expected shape - single parameterset' {

                Test-DMDiscoveredLocalAccount @inputObject

                Assert-MockCalled Write-Warning -Times 0 -Exactly -Scope It

            }

            It 'warns when identifiers do not match the expected shape - single parameterset' {

                Test-DMDiscoveredLocalAccount -type Windows -subtype Domain -identifiers @{username = 'someusername' } -externalId someexternalid

                Assert-MockCalled Write-Warning -Times 1 -Exactly -Scope It

            }

        }

        Context 'type/subtype ArgumentCompleter' {

            It 'provides an ArgumentCompleter for the type parameter' {

                (Get-Command Test-DMDiscoveredLocalAccount).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Should -Not -BeNullOrEmpty

            }

            It 'provides an ArgumentCompleter for the subtype parameter' {

                (Get-Command Test-DMDiscoveredLocalAccount).Parameters['subtype'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Should -Not -BeNullOrEmpty

            }

            It 'completes type values' {

                $Completer = (Get-Command Test-DMDiscoveredLocalAccount).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'Test-DMDiscoveredLocalAccount' -parameterName 'type' -wordToComplete 'Win' -commandAst $null -fakeBoundParameters @{}

                $Result.CompletionText | Should -Contain 'Windows'

            }

            It 'narrows subtype completions based on the bound type value' {

                $Completer = (Get-Command Test-DMDiscoveredLocalAccount).Parameters['subtype'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'Test-DMDiscoveredLocalAccount' -parameterName 'subtype' -wordToComplete '' -commandAst $null -fakeBoundParameters @{type = 'Windows' }

                $Result.CompletionText | Should -Contain 'Domain'
                $Result.CompletionText | Should -Not -Contain 'Password'

            }

        }

        Context 'Request Input - multiple parameterset' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    Write-Output @{ }
                }

                Mock Write-Warning -MockWith {}

                $accounts = @(
                    New-DMDiscoveredAccountObject -type Windows -subType Loosely -identifiers @{address = 'win-computer.cyber-ark.com'; username = 'admin' } -externalId user_account_5924
                    New-DMDiscoveredAccountObject -type Mac -subType Loosely -identifiers @{address = 'mac-computer.cyber-ark.com'; username = 'root' } -externalId user_account_1132
                )

            }

            It 'sends request - multiple parameterset' {

                Test-DMDiscoveredLocalAccount -accounts $accounts

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint - multiple parameterset' {

                Test-DMDiscoveredLocalAccount -accounts $accounts

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovered-accounts/check-existence"

                }

            }

            It 'sends request with expected body - multiple parameterset' {

                Test-DMDiscoveredLocalAccount -accounts $accounts

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -match 'user_account_5924' -and $Body -match 'user_account_1132' } -Times 1 -Exactly -Scope It

            }

            It 'does not warn when every account matches the expected shape - multiple parameterset' {

                Test-DMDiscoveredLocalAccount -accounts $accounts

                Assert-MockCalled Write-Warning -Times 0 -Exactly -Scope It

            }

            It 'warns once, naming the mismatched account, when one account does not match the expected shape - multiple parameterset' {

                $accounts += New-DMDiscoveredAccountObject -type Windows -subType Domain -identifiers @{username = 'admin' } -externalId user_account_mismatch -WarningAction SilentlyContinue

                Test-DMDiscoveredLocalAccount -accounts $accounts

                Assert-MockCalled Write-Warning -ParameterFilter { $Message -match 'user_account_mismatch' } -Times 1 -Exactly -Scope It

            }

            It 'does not warn or throw for an account hashtable missing type/subType keys' {

                { Test-DMDiscoveredLocalAccount -accounts @(@{identifiers = @{username = 'admin' }; externalId = 'no_type' }) } | Should -Not -Throw

            }

        }

    }

}
