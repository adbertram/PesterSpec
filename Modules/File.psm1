function File
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Path,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Node,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$SizeInBytes,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)
	
	if ($PSBoundParameters.ContainsKey('Node')) {
		$icmParams = @{
			'ComputerName' = $Node
		}
		if ($PSBoundParameters.ContainsKey('Credential'))
		{
			$icmParams.Credential = $Credential
		}
		
		$file = Invoke-Command @icmParams -ScriptBlock { Get-Item -Path $using:Path -ErrorAction Ignore }
	}
	else
	{
		$file = Get-Item -Path $Path -ErrorAction Ignore	
	}
	
	it "The file [$($Path)] exists." {
		$file | Should not BeNullOrEmpty
	}
	
	if ($PSBoundParameters.ContainsKey('SizeInBytes'))
	{
		it "The file [$($Path)] is [$($SizeInBytes)] bytes" {
			$file.Length | Should be $SizeInBytes
		}
	}
}