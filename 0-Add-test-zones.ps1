# Set the names of the origin and target servers
$server1="lab-dns1"
$server2="lab-dns2"

# Import a CSV of sample data
$ForwardZones=import-csv $PSScriptRoot\forwardzones.csv

# Loop through the sample zones
foreach ($item in $ForwardZones) {
	# Create the zone on the origin server
	Add-DnsServerPrimaryZone -Name $item.name -ZoneFile "$($item.name).dns" -ComputerName $server1
	
	# Add various kinds of sample records to each to simulate a small business ( or maybe a CCDC lab ;) ) 
	# See this link for documentation and browse around a bit:
	# https://docs.microsoft.com/en-us/powershell/module/dnsserver/add-dnsserverresourcerecord?view=win10-ps
	Add-DnsServerResourceRecord -ZoneName $item.name -Passthru -A -Name "mailserver0" -ipv4address "172.16.0.71" -ComputerName $server1
	Add-DnsServerResourceRecordMX -ZoneName $item.name -Passthru -MailExchange "mailserver0.$($item.name)" -TimeToLive 01:00:00 -Preference 10 -Name "." -ComputerName $server1
	Add-DnsServerResourceRecordCName -Name "mail" -HostNameAlias "mailserver0.$($item.name)" -ZoneName $($item.name) -Passthru -ComputerName $server1
	Add-DnsServerResourceRecordCName -Name "webmail" -HostNameAlias "mailserver0.$($item.name)" -ZoneName $($item.name) -Passthru -ComputerName $server1
	Add-DnsServerResourceRecord -ZoneName $item.name -Passthru -A -Name "ns1" -ipv4address "172.16.0.66" -ComputerName $server1
	Add-DnsServerResourceRecord -ZoneName $item.name -Passthru -A -Name "host0" -ipv4address "172.16.0.70" -ComputerName $server1
	Add-DnsServerResourceRecord -ZoneName $item.name -Passthru -A -Name "host1" -ipv4address "172.16.0.69" -ComputerName $server1
	Add-DnsServerResourceRecordCName -Name "www" -HostNameAlias "host0.$($item.name)" -ZoneName $item.name -Passthru -ComputerName $server1
	Add-DnsServerZoneDelegation -ComputerName $server1 -Name "$($item.name)" -ChildZoneName "ad" -NameServer "ns1.$($item.name)" -IPAddress 172.16.0.66
}


