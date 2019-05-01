##################################
# Set the origin server
$server1="lab-dns1"
# Get the ip of the origin server
$server1IP=(Resolve-DnsName $server1).IPAddress
##################################

##################################
# Set the target server
$server2="lab-dns2"
# Get the ip of the target server
$server2IP=(Resolve-DnsName $server2).IPAddress
##################################

# Get the zones except those that are auto-created, or otherwise not acceptable zones for replication
$TargetZones=Get-DnsServerZone -ComputerName $server1 | Where {("Primary" -eq $_.ZoneType)-and ($False -eq $_.IsAutoCreated) -and ("TrustAnchors" -ne $_.ZoneName)} 

# Loop through those zones, setting the secondary server property and enabling zone transfers and notification.
$TargetZones|ForEach-Object{$_|Set-DnsServerPrimaryZone   -ComputerName $server1 -Notify Notify -SecondaryServers $server2IP -SecureSecondaries TransferToSecureServers}

# Loop through the zones again, this time adding them to the secondary server, now that they're permitted to do a zone transfer.
$TargetZones|ForEach-Object{$_|Add-DnsServerSecondaryZone -ComputerName $server2 -MasterServers $server1IP -ZoneFile "$($_.ZoneName).dns"}
