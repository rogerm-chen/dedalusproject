
function set-proxy {
    param(
		[parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "proxy informations")]
		[hashtable[]]$proxyinfos
    )
	
	foreach ($proxyinfo in $proxyinfos){
	netsh interface portproxy add v4tov4 listenaddress=$($proxyinfo.listenaddress) `
	listenport=$($proxyinfo.listenport) connectaddress=$($proxyinfo.connectaddress) connectport=$($proxyinfo.connectport)

	}
   
}

function set-firewall {
    param(
		[parameter(ValueFromPipeline = $True, ValueFromPipelineByPropertyName = $True, HelpMessage = "proxy informations")]
		[hashtable[]]$proxyinfos
    )
	
	foreach ($proxyinfo in $proxyinfos){
		New-NetFirewallRule -DisplayName $($proxyinfo.firewallrulename) -Direction $($proxyinfo.direction) `
		-LocalPort $($proxyinfo.listenport) -Protocol $($proxyinfo.protocol) -Action $($proxyinfo.action)

	}
   
}


set-proxy $proxyinfos
set-firewall $proxyinfos