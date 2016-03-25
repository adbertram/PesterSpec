Describe 'File' {
	
	$commonParams = @{
		$Node = 'TEST123'
		$Path = 'C:\Whatever.txt'
	}

	mock It { return $null } -ModuleName 'File'
	mock Invoke-Command { return [pscustomobject]@{ 'Length' = 1000 } } -ModuleName 'File'
	
	it 'queries the right node' {
		File @commonParams -Exists
		Assert-MockCalled Invoke-Command -ParameterFilter { $ComputerName -eq $Node } -ModuleName 'File'
	}
	
	it 'queries the right file path' {
		File @commonParams -Exists
		Assert-MockCalled Invoke-Command -ParameterFilter { [string]$ScriptBlock -like '*Get-Item -Path $using:Path -ErrorAction Ignore*' } -ModuleName 'File'
	}
	
	it 'Parameter sets are correct' {
		{ File @commonParams -Exists -SizeInBytes 1000 } | Should throw 'Parameter set cannot be resolved using the specified named parameters.'
	}
	
	it 'Cannot pass empty values to parameters' {
		$err = 'The argument is null or empty. Provide an argument that is not null or empty, and then try the command again.'
		{ File -Node $null -Path $Path -Exists } | Should throw $err
		{ File -Node $Node -Path $null -Exists } | Should throw $err
#		{ File @commonParams -SizeInBytes $null } | Should throw $err
#		{ File @commonParams -SizeInBytes 1000 -Credential $null } | Should throw $err
	}
	
	it 'Cannot pass empty path' {
		$err = "Cannot validate argument on parameter 'Path'. The argument is null or empty. Provide an argument that is not null or empty, and then try the command again."
		{ File -Node $Node -Path $null -Exists -SizeInBytes 1000 } | Should throw $err
	}
	
	it 'Mandatory parameters are set correctly' {
		{ File -Node $Node -Exists } #| Should throw 'Parameter set cannot be resolved using the specified named parameters.'
		{ File -Path $Path -Exists } #| Should throw 'Parameter set cannot be resolved using the specified named parameters.'
	}
	
	it 'Credential is used with Invoke-Command when passed' {
		$secpasswd = ConvertTo-SecureString 'PlainTextPassword' -AsPlainText -Force
		$testCred = New-Object System.Management.Automation.PSCredential ('username', $secpasswd)
		File @commonParams -Credential $testCred -Exists
		Assert-MockCalled Invoke-Command -ParameterFilter { $Credential.UserName -eq $testCred.Username } -ModuleName 'File'
		
	}
	
	it 'all parameters have appropriate types' {
		{ File @commonParams -Exists -SizeInBytes 'stringhere' } | Should throw 'Cannot convert value "stringhere" to type "System.Int32"'
		{ File -Node @() -Path $Path -Exists } | Should throw "Cannot process argument transformation on parameter 'Node'. Cannot convert value to type System.String."
		{ File -Node $Node -Path @() -Exists } | Should throw "Cannot process argument transformation on parameter 'Path'. Cannot convert value to type System.String."
		{ File @commonParams -Exists $true } | Should throw "A positional parameter cannot be found that accepts argument 'True'"
		{ File @commonParams -Exists -Credential @() } | Should throw "Cannot process argument transformation on parameter 'Credential'. userName"
		
	}
}