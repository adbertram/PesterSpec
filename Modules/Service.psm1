function Service
{
	[CmdletBinding(DefaultParameterSetName = 'None')]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Node,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
	
		[Parameter(Mandatory,ParameterSetName = 'State')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Stopped','Running','Disabled')]
		[string]$State,
		
		[Parameter(Mandatory,ParameterSetName = 'StartMode')]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Auto','Disabled')]
		[string]$StartMode,
	
		[Parameter(Mandatory,ParameterSetName = 'Exists')]
		[ValidateNotNullOrEmpty()]
		[switch]$Exists,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[pscredential]$Credential
	)
	
	$icmParams = @{
		'ComputerName' = $Node
	}
	if ($PSBoundParameters.ContainsKey('Credential')) {
		$icmParams.Credential = $Credential
	}
	
	$service = Invoke-Command @icmParams -ScriptBlock { Get-CimInstance -ClassName 'Win32_Service' -Filter "Name = '$using:Name'" }
	
	switch ($PSCmdlet.ParameterSetName)
	{
		'Exists' {
			it "The service [$($Name)] exists" {
				$service | Should not be $null
			}
		}
		'State' {
			it "The service [$($Name)] is [$($State)]" {
				$service.State | Should be $State
			}
		}
		'StartMode' {
			it "The service [$($Name)] is set to [$($StartMode)] start mode" {
				$service.StartMode | Should be $StartMode
			}
		}
		default
		{
			throw "Unrecognized parameter set: [$($_)]"
		}
	}
}