function File
{
	[CmdletBinding(DefaultParameterSetName = 'None')]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Node,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Path,
		
		[Parameter(Mandatory,ParameterSetName = 'Size')]
		[ValidateNotNullOrEmpty()]
		[int]$SizeInBytes,
		
		[Parameter(Mandatory, ParameterSetName = 'Exists')]
		[ValidateNotNullOrEmpty()]
		[switch]$Exists,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)
	
	$icmParams = @{
		'ComputerName' = $Node
	}
	if ($PSBoundParameters.ContainsKey('Credential'))
	{
		$icmParams.Credential = $Credential
	}
	
	$file = Invoke-Command @icmParams -ScriptBlock { Get-Item -Path $using:Path -ErrorAction Ignore }
	
	switch ($PSCmdlet.ParameterSetName)
	{
		'Exists' {
			it "The file [$($Path)] exists" {
				$file | Should not be $null
			}
		}
		'Size' {
			it "The file [$($Path)] is [$($SizeInBytes)] bytes" {
				$file.Length | Should be $SizeInBytes
			}
		}
		default
		{
			throw "Unrecognized parameter set: [$($_)]"
		}
	}
}