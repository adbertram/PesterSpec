function Start-PesterSpecTest
{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateScript({ Test-Path -Path $_ })]
		[string]$Path,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$TestName,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string[]]$ExcludeTag = 'Disabled',
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string[]]$Tag
	)

	$pesterScrParams = @{
		'Path' = $Path
	}
	
	$invPesterParams = @{
		'Script' = $pesterScrParams
		'ExcludeTag' = $ExcludeTag
	}
	
	if ($PSBoundParameters.ContainsKey('Tag'))
	{
		$invPesterParams.Tag = $Tag
	}
	
	if ($PSBoundParameters.ContainsKey('TestName'))
	{
		$invPesterParams.TestName = $TestName
	}
	
	Invoke-Pester @invPesterParams
}