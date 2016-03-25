#region Helper functions

function New-ValidationDynamicParam
{
	[CmdletBinding()]
	[OutputType('System.Management.Automation.RuntimeDefinedParameter')]
	param (
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[ValidateNotNullOrEmpty()]
		[Parameter()]
		[array]$ValidateSetOptions,
		
		[Parameter()]
		[switch]$Mandatory = $false,
		
		[Parameter()]
		[string]$ParameterSetName = '__AllParameterSets',
		
		[Parameter()]
		[switch]$ValueFromPipeline = $false,
		
		[Parameter()]
		[switch]$ValueFromPipelineByPropertyName = $false
	)
	
	$AttribColl = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
	$ParamAttrib = New-Object System.Management.Automation.ParameterAttribute
	$ParamAttrib.Mandatory = $Mandatory.IsPresent
	$ParamAttrib.ParameterSetName = $ParameterSetName
	$ParamAttrib.ValueFromPipeline = $ValueFromPipeline.IsPresent
	$ParamAttrib.ValueFromPipelineByPropertyName = $ValueFromPipelineByPropertyName.IsPresent
	$AttribColl.Add($ParamAttrib)
	if ($PSBoundParameters.ContainsKey('ValidateSetOptions')) {
		$AttribColl.Add((New-Object System.Management.Automation.ValidateSetAttribute($ValidateSetOptions)))
	}
	$RuntimeParam = New-Object System.Management.Automation.RuntimeDefinedParameter($Name, [string], $AttribColl)
	$RuntimeParam
	
}

#endregion

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