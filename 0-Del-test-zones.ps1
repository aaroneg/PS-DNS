# Nuke test data and start over.
$server1="lab-dns1"

Get-DnsServerZone -ComputerName $server1 | Remove-DnsServerZone -ComputerName $server1 -Force
Get-DnsServerZone -ComputerName $server2 | Remove-DnsServerZone -ComputerName $server2 -Force
