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
		[ValidateSet('VMM','HyperV','VMWare')]
		[string]$Type
	)
	
}

Export-ModuleMember -Function VirtualMachine