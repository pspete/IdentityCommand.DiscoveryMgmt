function ConvertTo-DMFilterString {
    <#
    .SYNOPSIS
    Assembles a Discovery Management filter expression.

    .DESCRIPTION
    Formats field/value pairs into the filter expression accepted by the Discovery Management
    service. Each pair becomes an equality clause, and clauses are joined with AND.

        type eq SomeType AND recurrenceType eq SomeRecurrence

    A value containing whitespace is quoted, and a quote character within a quoted value is escaped
    with a backslash - both handled by ConvertTo-FilterClause. Callers pass raw values and never
    pre-quote. Clauses are ordered by field name.

    The expression is not url encoded - ConvertTo-QueryString encodes the query string as a whole.

    .PARAMETER Filter
    Hashtable of field names and the values to compare them against.

    .EXAMPLE
    ConvertTo-DMFilterString -Filter @{ type = 'SomeType' }

    Outputs: type eq SomeType

    .EXAMPLE
    ConvertTo-DMFilterString -Filter @{ type = 'SomeType'; lastInstanceStatus = 'Some Status' }

    Outputs: lastInstanceStatus eq "Some Status" AND type eq SomeType

    .OUTPUTS
    String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [AllowEmptyCollection()]
        [hashtable]$Filter
    )

    process {

        $Clauses = foreach ($Field in ($Filter.Keys | Sort-Object)) {

            ConvertTo-FilterClause -Field $Field -Operator eq -Value $Filter[$Field]

        }

        if (@($Clauses).Count -gt 0) {

            $Clauses -join ' AND '

        }

    }

}
