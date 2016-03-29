function Node
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$HostName
	)
	
	$scriptBlock = {
		$env:COMPUTERNAME
	}
	
	it "should have a hostname of [$($HostName)]" {
		Invoke-Command -ComputerName $HostName -ScriptBlock $scriptBlock | Should be $HostName
	}
}