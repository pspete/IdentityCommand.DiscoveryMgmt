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

        Context 'Assembly' {

            It 'forms a single clause' {
                ConvertTo-DMFilterString -Filter @{ type = 'SomeType' } | Should -Be 'type eq SomeType'
            }

            It 'joins clauses with AND, ordered by field name' {
                ConvertTo-DMFilterString -Filter @{ type = 'SomeType'; recurrenceType = 'Daily'; lastInstanceStatus = 'Done' } |
                    Should -Be 'lastInstanceStatus eq Done AND recurrenceType eq Daily AND type eq SomeType'
            }

            It 'accepts a hashtable from the pipeline' {
                @{ type = 'SomeType' } | ConvertTo-DMFilterString | Should -Be 'type eq SomeType'
            }

            It 'outputs nothing for an empty hashtable' {
                ConvertTo-DMFilterString -Filter @{ } | Should -BeNullOrEmpty
            }

        }

        Context 'Value Quoting' {

            It 'quotes a value containing a space' {
                ConvertTo-DMFilterString -Filter @{ type = 'Some Type' } | Should -Be 'type eq "Some Type"'
            }

            It 'escapes a quote within a quoted value' {
                ConvertTo-DMFilterString -Filter @{ type = 'my "inner" value' } | Should -Be 'type eq "my \"inner\" value"'
            }

            It 'does not url encode the expression' {
                ConvertTo-DMFilterString -Filter @{ type = 'Some Type' } | Should -Not -Match '%'
            }

        }

    }

}
