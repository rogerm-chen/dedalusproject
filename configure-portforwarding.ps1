param(
		[parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
		$proxyinfosjson
    )
$proxyinfosjson= '{"proxyinfos": {
	"value": [
		{
			"listenaddress": "10.1.10.20",
			"listenport": "443",
			"connectaddress": "10.1.10.20",
			"connectport": "443",
			"firewallrulename": "port443",
			"direction": "Inbound",
			"action": "Allow",
			"protocol": "TCP"
		},
		{
			"listenaddress": "10.1.10.20",
			"listenport": "80",
			"connectaddress": "10.1.10.20",
			"connectport": "80",
			"firewallrulename": "port80",
			"direction": "Inbound",
			"action": "Allow",
			"protocol": "TCP"
		}
	]
}
}'



$proxyinfos= ConvertFrom-Json -InputObject $proxyinfosjson
$proxyinfos=$proxyinfos.proxyinfos.value

function set-proxy {
    param(
		[parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
		[array]$proxyinfos
    )
	
	foreach ($proxyinfo in $proxyinfos){
	netsh interface portproxy add v4tov4 listenaddress=$($proxyinfo.listenaddress) `
	listenport=$($proxyinfo.listenport) connectaddress=$($proxyinfo.connectaddress) connectport=$($proxyinfo.connectport)

	}
   
}

function set-firewall {
    param(
		[parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True)]
		[array]$proxyinfos
    )
	
	foreach ($proxyinfo in $proxyinfos){
		New-NetFirewallRule -DisplayName $($proxyinfo.firewallrulename) -Direction $($proxyinfo.direction) `
		-LocalPort $($proxyinfo.listenport) -Protocol $($proxyinfo.protocol) -Action $($proxyinfo.action)

	}
   
}

set-proxy $proxyinfos
set-firewall $proxyinfos
