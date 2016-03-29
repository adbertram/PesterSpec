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
#
#Describe 'AD test' {
#	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local'
#	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local' -Scope 'Universal'
#	ActiveDirectoryGroup -Name 'Group 1' -DomainName 'mylab.local' -Type 'Security'
#}
#
#describe 'DNS record test' {
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -Type 'CNAME'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -Type 'A'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -IPV4Address '192.168.1.33'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -IPV4Address '192.168.0.120'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -IPV4Address '192.168.0.120' -Type 'A'
#	DNSRecord -Name 'DC' -Server 'DC' -ZoneName 'mylab.local' -IPV4Address '192.168.0.120' -Type ''
#}
#
#describe 'DNS zone test' {
#	DnsZone -Name 'mylab.local' -Server 'DC'
#	DnsZone -Name 'mylab.local' -Server 'DC' -Type 'Primary'
#	DnsZone -Name 'myladdb.local' -Server 'DC'
#}

#Describe 'node test' {
#	Node -HostName 'DC'	
#}

#describe 'VMM test no host' {
#	VirtualMachine -Type VMM -Name 'BAPP85LSS02'
#}
#
#describe 'VMM test with host' {
#	VirtualMachine -Type VMM -Name 'BAPP85LSS02' -VMHost 'RWC1BINF04VIR06.genomichealth.com'
#}
#
#describe 'Azure VM test' {
#	VirtualMachine -Type Azure -Name 'PesterTest-01' -ResourceGroupName 'PesterTesting'
#}

#describe 'IIS test' {
#	IISServer -ComputerName 'BAPP85LSS02.bdt085.local'
#}
#
#describe 'Windows feature test' {
#	WindowsFeature -ComputerName '' -Name 'Web-Server'	
#}

describe 'AzureResourceGroup test' {
	AzureResourceGroup -Name 'PesterTesting'	
}