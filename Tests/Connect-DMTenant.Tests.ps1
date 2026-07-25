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

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        BeforeEach {

            $ISPSSSession = [ordered]@{
                discoverymgmt_url  = $null
                privilegecloud_url = $null
                User               = $null
                TenantId           = $null
                SessionId          = $null
                WebSession         = $null
                StartTime          = $null
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = $null
                LastCommandResults = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Get-IDSession -MockWith {
                [ordered]@{
                    tenant_url = 'https://somedomain.id.cyberark.cloud'
                    User       = $null
                    TenantId   = 'SomeTenant'
                    SessionId  = 'SomeSession'
                }
            }


            Connect-DMTenant -subdomain 'sometenant'

        }

        Context 'Input' {

            It 'calls Get-IDSession' {

                Assert-MockCalled Get-IDSession -Times 1 -Exactly -Scope It

            }

            It 'throws if Get-IDSesion does not return tenant_url' {

                Mock Get-IDSession -MockWith {
                    [ordered]@{
                        tenant_url = $null
                        User       = $null
                        TenantId   = 'SomeTenant'
                        SessionId  = 'SomeSession'
                    }
                }

                { Connect-DMTenant -subdomain 'sometenant' } | Should -Throw 'Authenticate with New-IDSession or New-IDPlatformToken and try again'

            }

        }

        Context 'Output' {

            It 'provides output with expected values' {
                $ISPSSSession.discoverymgmt_url | Should -Be 'https://sometenant.discoverymgmt.cyberark.cloud'
                $ISPSSSession.privilegecloud_url | Should -Be 'https://sometenant.privilegecloud.cyberark.cloud'
                $ISPSSSession.User | Should -BeNullOrEmpty
                $ISPSSSession.TenantId | Should -Be 'SomeTenant'
                $ISPSSSession.SessionId | Should -Be 'SomeSession'

            }

            It 'removes trailing space from provided subdomain' {
                Connect-DMTenant -subdomain 'sometenant/'
                $ISPSSSession.discoverymgmt_url | Should -Be 'https://sometenant.discoverymgmt.cyberark.cloud'
            }

        }

    }

}
