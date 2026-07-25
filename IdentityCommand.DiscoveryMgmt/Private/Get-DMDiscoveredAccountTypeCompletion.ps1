function Get-DMDiscoveredAccountTypeCompletion {
    <#
    .SYNOPSIS
    Returns ArgumentCompleter CompletionResult objects for discovered-account Type/SubType parameters.

    .DESCRIPTION
    Shared completion logic for the [ArgumentCompleter] attributes on the -type/-subType parameters
    of New-DMDiscoveredAccountObject, Test-DMDiscoveredLocalAccount & Add-DMDiscoveredLocalAccount.
    Reads reference data from Get-DMDiscoveredAccountTypeMap.

    .PARAMETER Property
    Which property of the type map to return completions for - Type or SubType.

    .PARAMETER WordToComplete
    The partial value currently being typed.

    .PARAMETER Type
    Restricts SubType completions to those valid for a specific Type. Ignored when -Property is Type.

    .PARAMETER SubType
    Restricts Type completions to those valid for a specific SubType. Ignored when -Property is SubType.

    .EXAMPLE
    Get-DMDiscoveredAccountTypeCompletion -Property Type -WordToComplete 'Win'

    Returns a CompletionResult for 'Windows'.

    .EXAMPLE
    Get-DMDiscoveredAccountTypeCompletion -Property SubType -WordToComplete '' -Type Windows

    Returns CompletionResults for 'Local', 'Domain' & 'Loosely'.

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Type', 'SubType')]
        [string]$Property,

        [Parameter(Mandatory = $false)]
        [string]$WordToComplete,

        [Parameter(Mandatory = $false)]
        [string]$Type,

        [Parameter(Mandatory = $false)]
        [string]$SubType
    )

    $Rows = if ($Type) { Get-DMDiscoveredAccountTypeMap -Type $Type } else { Get-DMDiscoveredAccountTypeMap }

    if ($SubType) {

        $Rows = $Rows | Where-Object { $PSItem.SubType -eq $SubType }

    }

    $Rows |
        Select-Object -ExpandProperty $Property -Unique |
        Where-Object { $PSItem -like "$WordToComplete*" } |
        Sort-Object |
        ForEach-Object { [System.Management.Automation.CompletionResult]::new($PSItem, $PSItem, 'ParameterValue', $PSItem) }

}
