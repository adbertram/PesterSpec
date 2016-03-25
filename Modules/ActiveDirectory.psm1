#region Helper functions

function ConvertTo-DistinguishedName
{
<#
	.SYNOPSIS
		This function converts a canonical name to a distinguished name

	.PARAMETER DomainName
		The domain name in FQDN format.

	.PARAMETER OUPath
		The organization unit path as a canonical name.  Canonical names sepaarate OUs by a forward flash.

	.EXAMPLE
		PS> ConvertTo-DistinguishedName -DomainName bdt007.local -OUPath Users/Admin Users

		This will output the string OU=Users,OU=Admin Users,DC=bdt007,DC=local
#>
	
	[CmdletBinding()]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^\w+\.\w+$')]
		[string]$DomainName,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$OUPath
	)
	
	$domainSplit = $DomainName.Split('.')
	
	if ($PSBoundParameters.ContainsKey('OUPath'))
	{
		$OUPath = $OUPath.Replace('\', '/')
		$ouSplit = $OUPath.Split('/')
		"OU=$($ouSplit -join ',OU='),DC=$($domainSplit -join ',DC=')"
	}
	else
	{
		"DC=$($domainSplit -join ',DC=')"
	}
}

#endregion

function ActiveDirectoryGroup
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[string]$Name,
		
		[Parameter(Mandatory)]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^\w+\.\w+$')]
		[string]$DomainName,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$OrganizationalUnit,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Distribution', 'Security')]
		[string]$Type,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidateSet('Universal', 'Global', 'DomainLocal')]
		[string]$Scope,
		
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$Description
	)
	
	$dnParams = @{
		'DomainName' = $DomainName
	}
	
	if ($PSBoundParameters.ContainsKey('OrganizationalUnit'))
	{
		$dnParams.OrganizationalUnit = $OrganizationalUnit
	}
	
	$dn = ConvertTo-DistinguishedName @dnParams
	$searchRoot = "LDAP://$dn"
	
	$scriptBlock = {
		$searcher = [adsisearcher]"(&(objectCategory=Group)(name=$using:Name))"
		$searcher.SearchRoot = $using:searchRoot
		$searcher.FindOne().Properties
	}
	
	$group = Invoke-Command -ComputerName $DomainName -ScriptBlock $scriptBlock
	
	if (-not $PSBoundParameters.ContainsKey('Type') -and -not $PSBoundParameters.ContainsKey('Scope'))
	{
		it "group [$($Name)] exists in domain [$($DomainName)]" {
			$group | Should not be $null
		}
	}
	
	if ($PSBoundParameters.ContainsKey('Type')) {
		it "group [$($Name)] should have type of [$($Type)]" {
			switch ($group.grouptype)
			{
				{ $_ -in @(2, 4, 8) } {
					$groupType = 'Distribution'
				}
				{ $_ -in @(-2147483644, -2147483646, -2147483640) } {
					$groupType = 'Security'
				}
				default {
					throw "Unknown group type [$($_)]"
				}
			}
			$groupType | Should be $Type
		}
	}
	
	if ($PSBoundParameters.ContainsKey('Scope')) {
		it "group [$($Name)] should have scope of [$($Scope)]" {
			switch ($group.grouptype)
			{
				{ $_ -in @(2,-2147483646) } {
					$groupScope = 'Global'
				}
				{ $_ -in @(4,-2147483644) } {
					$groupScope = 'DomainLocal'
				}
				{ $_ -in @(8,-2147483640) } {
					$groupScope = 'Universal'
				}
				default
				{
					throw "Unknown group scope [$($_)]"
				}
			}
			$groupScope | Should be $Scope
		}
	}
}

function ActiveDirectoryUser
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$MemberOf
			
	)
	
	$Group = [ADSI]"LDAP://cn=Domain Admins,cn=Users,dc=Contoso,dc=Com"
	$Members = $Group.Member | ForEach-Object { [ADSI]"LDAP://$_" }
	
}

function ActiveDirectoryDomain
{
	[CmdletBinding()]
	param
	(
		
	)
	
}

function ActiveDirectoryForest
{
	[CmdletBinding()]
	param
	(
		
	)
	
}

Export-ModuleMember -Function 'ActiveDirectory*'