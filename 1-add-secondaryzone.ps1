$server1="lab-dns1"
$server1IP=(Resolve-DnsName $server1).IPAddress
$server2="lab-dns2"
$server2IP=(Resolve-DnsName $server2).IPAddress

#Add-DnsServerZoneTransferPolicy -Name "Allowed Secondary Server" -Action 
$TargetZones=Get-DnsServerZone -ComputerName $server1 | Where {("Primary" -eq $_.ZoneType)-and ($False -eq $_.IsAutoCreated) -and ("TrustAnchors" -ne $_.ZoneName)} 
$TargetZones|ForEach-Object{$_|Set-DnsServerPrimaryZone   -ComputerName $server1 -Notify Notify -SecondaryServers $server2IP -SecureSecondaries TransferToSecureServers}
#Start-sleep -Seconds 5
$TargetZones|ForEach-Object{$_|Add-DnsServerSecondaryZone -ComputerName $server2 -MasterServers $server1IP -ZoneFile "$($_.ZoneName).dns"}

