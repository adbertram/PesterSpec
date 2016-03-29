function VirtualMachine-VirtualMachineManager
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(Mandatory)]
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
	
	$vm = Get-SCVirtualMachine -VMHost $VMHost -Name $Name
	it "the VM [$($Name)] should exist on the VM host [$($VMHost)]" {
		$vm | Should not be $null
	}
	
	if ($PSBoundParameters.ContainsKey('Status')) {
		it "the VM [$($Name)] should be in the state [$($Status)]" {
			$vm.Status | Should be $Status	
		}
	}
	
	if ($PSBoundParameters.ContainsKey('MemoryMB')) {
		it "the VM [$($Name)] should have [$($MemoryMB)] MB of memory" {
			$vm.Memory | Should be $MemoryMB
		}
	}
	
}