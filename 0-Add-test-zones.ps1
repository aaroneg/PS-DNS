$server1="lab-dns1"
$server2="lab-dns2"

$ForwardZones=import-csv $PSScriptRoot\forwardzones.csv
foreach ($item in $ForwardZones) {
	Add-DnsServerPrimaryZone -Name $item.name -ZoneFile "$($item.name).dns" -ComputerName $server1
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


