function VirtualMachine
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('VMM', 'HyperV', 'VMWare','Azure')]
		[string]$Type,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$VMHost,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Running', 'PoweredOff')]
		[string]$Status,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[int]$MemoryMB
	)
	
	DynamicParam
	{
		$ParamOptions = @()
		switch ($Type)
		{
			'VMM'
			{
				$ParamOptions += @{ 'Name' = 'VMCPath' }

				$RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
				foreach ($Param in $ParamOptions)
				{
					$RuntimeParam = New-ValidationDynamicParam @Param
					$RuntimeParamDic.Add($Param.Name, $RuntimeParam)
				}
			}
			'HyperV'
			{
				#<code>
			}
			'VMWare'
			{
				#<code>
			}
			'Azure' {
				$ParamOptions += @{
					'Name' = 'ResourceGroupName'
					'Mandatory' = $true
				}
			}
			default
			{
				throw "Unrecognized virtual machine type: [$($Type)]"
			}
		}
		$RuntimeParamDic = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
		foreach ($Param in $ParamOptions)
		{
			$RuntimeParam = New-ValidationDynamicParam @Param
			$RuntimeParamDic.Add($Param.Name, $RuntimeParam)
		}
		return $RuntimeParamDic
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
				$vm = Get-SCVirtualMachine -Name $Name
			}
			'HyperV' {
				throw 'Hyper-V support not added yet'
			}
			'VMWare' {
				throw 'VMware support not added yet'
			}
			'Azure' {
				$vm = Get-AzureRmVM -Name $Name -ResourceGroupName $ResourceGroupName -ErrorAction SilentlyContinue
			}
			default
			{
				throw "Unrecognized VirtualMachine type: [$($_)]"
			}
		}
		
		it "the VM [$($Name)] should exist" {
			$vm | Should not be $null
		}
		
		if ($PSBoundParameters.ContainsKey('VMHost')) {
			it "the VM [$($Name)] should be on the VM host [$($VMHost)]" {
				$vm.VMHost | Should be $VMHost
			}
		}
		
		if ($PSBoundParameters.ContainsKey('Status'))
		{
			it "the VM [$($Name)] should be in the state [$($Status)]" {
				$vm.Status | Should be $Status
			}
		}
		
		if ($PSBoundParameters.ContainsKey('MemoryMB'))
		{
			it "the VM [$($Name)] should have [$($MemoryMB)] MB of memory" {
				$vm.Memory | Should be $MemoryMB
			}
		}
		
	}
}