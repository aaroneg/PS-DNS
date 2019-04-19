$server1="lab-dns1"

Get-DnsServerZone -ComputerName $server1 | Remove-DnsServerZone -ComputerName $server1 -Force