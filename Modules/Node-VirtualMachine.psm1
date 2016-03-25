function VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$VMHost,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('VMM', 'HyperV', 'VMWare')]
		[string]$Type,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Running', 'PoweredOff')]
		[string]$State,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$Memory
	)
	
	DynamicParam
	{
		switch ($Type)
		{
			'VMM'
			{
				$ParamOptions = @(
				@{
					'Name' = 'VMCPath'
				}
				)
				$RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
				foreach ($Param in $ParamOptions)
				{
					$RuntimeParam = New-ValidationDynamicParam @Param
					$RuntimeParamDic.Add($Param.Name, $RuntimeParam)
				}
				
				return $RuntimeParamDic
			}
			'HyperV'
			{
				#<code>
			}
			'VMWare'
			{
				#<code>
			}
			default
			{
				throw "Unrecognized virtual machine type: [$($Type)]"
			}
		}
	}
	
	begin
	{
		$PsBoundParameters.GetEnumerator() | foreach { New-Variable -Name $_.Key -Value $_.Value -ea 'SilentlyContinue' }
	}
	
	process
	{
		switch ($Type)
		{
			'VMM' {
				Import-Module -Name 'Node-VirtualMachine-VirtualMachineManager'
				
				VirtualMachine-VirtualMachineManager -Parameters $PSBoundParameters
			}
			'HyperV' {
				#<code>
			}
			'VMWare' {
				#<code>
			}
			default
			{
				throw "Unrecognized VirtualMachine type: [$($_)]"
			}
		}
	}
}