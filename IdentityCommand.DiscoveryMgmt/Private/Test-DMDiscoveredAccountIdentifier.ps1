function Test-DMDiscoveredAccountIdentifier {
    <#
    .SYNOPSIS
    Tests whether a set of discovered account identifiers matches the expected shape for a Type/SubType.

    .DESCRIPTION
    Returns $true if the Type/SubType combination is not recognised by Get-DMDiscoveredAccountTypeMap
    (nothing to validate against), or if every mandatory identifier for a recognised Type/SubType is
    present in Identifiers. Returns $false otherwise.

    Does not validate optional identifiers, and does not reject extra/unrecognised keys.

    .PARAMETER Type
    The account Type to validate against.

    .PARAMETER SubType
    The account SubType to validate against.

    .PARAMETER Identifiers
    The identifiers hashtable to validate.

    .EXAMPLE
    Test-DMDiscoveredAccountIdentifier -Type Windows -SubType Domain -Identifiers @{address='x';username='y'}

    Returns $true

    .EXAMPLE
    Test-DMDiscoveredAccountIdentifier -Type Windows -SubType Domain -Identifiers @{username='y'}

    Returns $false - missing the mandatory 'Address' identifier

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Type,

        [Parameter(Mandatory = $true)]
        [string]$SubType,

        [Parameter(Mandatory = $true)]
        [AllowNull()]
        [hashtable]$Identifiers
    )

    $Row = Get-DMDiscoveredAccountTypeMap -Type $Type -SubType $SubType | Select-Object -First 1

    if ($null -eq $Row) {

        #Unrecognised Type/SubType combination - nothing to validate against
        return $true

    }

    if ($null -eq $Identifiers) {

        return ($Row.Identifiers.Count -eq 0)

    }

    foreach ($Key in $Row.Identifiers) {

        if (-not $Identifiers.ContainsKey($Key)) {

            return $false

        }

    }

    return $true

}
