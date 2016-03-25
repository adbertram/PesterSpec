function DnsRecord
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ZoneName,
	
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Server,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$IpV4Address,
	
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('A','CNAME')]
		[string]$Type
	)
	
	$scriptBlock = {
		Get-DnsServerResourceRecord -Name $using:Name -ZoneName $using:ZoneName
	}
	
	$record = Invoke-Command -ComputerName $Server -ScriptBlock $scriptBlock -HideComputerName
	
	if ($PSBoundParameters.ContainsKey('Type')) {
		it "DNS record [$($Name)] is in zone [$($ZoneName)] and is type [$($Type)]" {
			$record.RecordType | Should be $Type		
		}
	}
	
	if ($PSBoundParameters.ContainsKey('IpV4Address'))
	{
		it "DNS record [$($Name)] is in zone [$($ZoneName)] and has IPV4 address [$($IpV4Address)]" {
			$record.RecordData.IPv4Address.IPAddressToString | Should be $IpV4Address
		}
	}
	
}