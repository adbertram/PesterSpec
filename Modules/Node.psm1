function Node
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$HostName,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ipaddress]$IpAddress
	)
	
}