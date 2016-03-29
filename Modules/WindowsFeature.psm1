function WindowsFeature
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$ComputerName,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Installed','NotInstalled')]
		[string]$Status
	)
	
	$scriptBlock = {
		Get-WindowsFeature -Name $using:Name
	}
	
	it "Computer [$($ComputerName)] has the feature [$($feature.Name)] [$($Status)]" {
		switch ($Status) {
			'Installed' {
				$feature.Installed | Should be $true
			}
			'NotInstalled' {
				$feature.Installed | Should be $false
			}
			default {
				#<code>
			}
		}
	}
}