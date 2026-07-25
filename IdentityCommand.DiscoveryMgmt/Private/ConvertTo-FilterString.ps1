function ConvertTo-FilterString {
	<#
.SYNOPSIS
Converts Hashtable Key-Value pairs to a string for use as a Filter value

.DESCRIPTION
When given a hashtable as input, converts key value pairs to filter string.
Returns single key hashtable, with string as value of the "filter" key.

.PARAMETER Parameters
Hashtable containing parameter names and values to include in output

.PARAMETER QuoteValue
Specify this switch to enclose the value of a key value pair in quotes when converting to a filter string

.PARAMETER LogicalOperator
The logical operator to join multiple filter key/value pairs with. Defaults to 'AND'.

.EXAMPLE
$input | ConvertTo-FilterString

Joins Key & Value with "eq"
Joins Multiple Key Value pairs with ' AND '
Output: @{"filter" = "Key eq Value AND Key eq Value"}

.EXAMPLE
$ht | ConvertTo-FilterString -QuoteValue

Name                           Value
----                           -----
filter                         Some eq "Value"

Encloses value of the key/value pair in quotes.

#>
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'FilterList', Justification = 'False Positive')]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'False Positive')]
	[CmdletBinding()]
	[OutputType('System.Hashtable')]
	param(
		[parameter(
			Mandatory = $false,
			ValueFromPipeline = $true
		)]
		[hashtable]$Parameters,

		[parameter(
			Mandatory = $false,
			ValueFromPipeline = $false
		)]
		[switch]$QuoteValue,

		[parameter(
			Mandatory = $false,
			ValueFromPipeline = $false
		)]
		[string]$LogicalOperator = 'AND'
	)

	begin { }

	process {

		if ($Parameters) {

			$Parameters.Keys | ForEach-Object {

				$FilterList = [Collections.Generic.List[Object]]@()

			} {

				$value = $($Parameters[$PSItem])

				#Always use modern (API 14.6+) quoting behavior - this module only ever targets SaaS.
				if ($QuoteValue -or ($value -match '\s')) { $value = """$value""" }

				$null = $FilterList.Add("$PSItem eq $value")

			} {

				if ($FilterList.count -gt 0) {

					@{'filter' = $FilterList -join " $LogicalOperator " }

				}
			}

		}

	}

	end { }

}
