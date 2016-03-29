function AzureResourceGroup
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Name
	)

	it "an Azure resource group [$($Name)] should exist" {
		$null = Get-AzureRmResourceGroup -Name $Name -ev err -ea SilentlyContinue
		$err.exception | Should not match 'Provided resource group does not exist\.'
	}
}