#Describe 'Functionality 1' {
#	Service -Node DC -Name w32time -Exists	
#}
#
#Describe 'Functionality 2' {
#	Service -Node DC -Name w32time -State Running
#}
#
#Describe 'Functionality 3' {
#	Service -Node DC -Name w32time -StartMode Auto
#}
#
#Describe 'Functionality 4' {
#	File -Node DC -Path 'C:\MMASetup-AMD64.exe' -Exists
#}
#
#Describe 'Functionality 5' {
#	File -Node DC -Path 'C:\MMASetup-AMD64.exe' -SizeInBytes 28699832
#}

Describe 'AD test' {
	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local'
	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local' -Scope 'Universal'
	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local' -Type 'Security'
}