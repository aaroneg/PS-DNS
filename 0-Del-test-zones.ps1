# Nuke test data and start over.

# Set the names of the origin and target servers
$server1="lab-dns1"
$server2="lab-dns2"

# Get the zones, nuke the zones.
Get-DnsServerZone -ComputerName $server1 | Remove-DnsServerZone -ComputerName $server1 -Force
Get-DnsServerZone -ComputerName $server2 | Remove-DnsServerZone -ComputerName $server2 -Force
