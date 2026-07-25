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

            $InputObject = [PSCustomObject]@{

                'id'         = 'SomeID'
                'platformID' = 'SomePlatform'
                'SafeName'   = 'SomeSafe'

            }

            $response = $InputObject | Publish-DMDiscoveredLocalAccount

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq "$($Script:ISPSSSession.privilegecloud_url)/api/discovered-accounts/SomeID/Onboard"

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

        }

    }

}
