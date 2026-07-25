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

        BeforeEach {

            Mock Invoke-IDRestMethod -MockWith {
                [PSCustomObject]@{'Prop1' = 'Val1'; 'Prop2' = 'Val2' }
            }

            Mock Write-Warning -MockWith {}

            $InputObject = [PSCustomObject]@{

                'type'        = 'windows'
                'identifiers' = @{'address' = 'somemachine.pspete.dev'; 'username' = 'administrator' }

            }

            $response = $InputObject | Add-DMDiscoveredLocalAccount

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovered-accounts/"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'PUT' } -Times 1 -Exactly -Scope It

            }

        }

        Context 'type ArgumentCompleter' {

            It 'provides an ArgumentCompleter for the type parameter' {

                (Get-Command Add-DMDiscoveredLocalAccount).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Should -Not -BeNullOrEmpty

            }

            It 'completes type values restricted to Loosely-subtype types' {

                $Completer = (Get-Command Add-DMDiscoveredLocalAccount).Parameters['type'].Attributes |
                    Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] } |
                    Select-Object -ExpandProperty ScriptBlock

                $Result = & $Completer -commandName 'Add-DMDiscoveredLocalAccount' -parameterName 'type' -wordToComplete '' -commandAst $null -fakeBoundParameters @{}

                $Result.CompletionText | Should -Be @('Mac', 'Unix', 'Windows')

            }

        }

        Context 'Identifiers validation' {

            It 'does not warn when identifiers match the expected shape for the given type' {

                #BeforeEach already invoked Add-DMDiscoveredLocalAccount with matching Address/Username identifiers
                Assert-MockCalled Write-Warning -Times 0 -Exactly -Scope It

            }

            It 'warns when identifiers do not match the expected shape for the given type' {

                #BeforeEach's own call used matching identifiers (0 warnings) - this call is the only mismatched one
                [PSCustomObject]@{
                    'type'        = 'windows'
                    'identifiers' = @{'SomeProperty' = 'SomeValue' }
                } | Add-DMDiscoveredLocalAccount

                Assert-MockCalled Write-Warning -Times 1 -Exactly -Scope It

            }

        }

    }

}
