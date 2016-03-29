function IISServer
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName
		
	)
	
	$scriptBlock = {
		(Get-WindowsFeature -Name 'Web-Server').Installed
	}
	
	it "Computer [$($ComputerName)] should have the web server feature installed" {
		Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock | Should be $true
	}
}