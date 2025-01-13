L.ui.view.extend({

    title: L.tr('Network Configuration'),
      RunUdev:L.rpc.declare({
        object:'command',
        method:'exec',
        params : ['command','args'],
    }),
    
    
     fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
        params: [ 'config', 'type']  
       
    }),
    
      updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-updatewanconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('sysconfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'sysconfig', {
            caption:L.tr('Network')
        });
        
        
//#################################################################################################################
 // 
 // 					Ethernet Settings
 //
 // ##################################################################################################################                
 //=======================================================================================================================================
	//	Port 1 Eth0.1 LAN  settings
//=========================================================================================================================================		
	  
        s.tab({
            id: 'ethernetconfig',
            caption: L.tr('Ethernet Settings')
        });
        
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port1settings', {
	caption: L.tr(''),
		}).depends({'ethernetconfig':'1'})
		.ucivalue=function()
			{
			var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPort 1 settings </b> </h3>";
			return id;
			};   

	s.taboption('ethernetconfig',L.cbi.ListValue,'port1mode',{          
		caption:L.tr('Port 1 mode'),                    
		}).depends({'port':'port1'})
			.value("none", L.tr('choose option'))
			.value("LAN1", L.tr('LAN1'))
			.value("SW_LAN", L.tr('SW_LAN'))
			.value("EWAN1", L.tr('EWAN1'));  
		
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port1lanifname', {
		caption: L.tr('Port 1 ifname'),
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1'})
		.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1'}); 

	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port1laninterfacename', {
		caption: L.tr('Port 1 Interface Name'),
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1'}); 
					
	s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort1lan', {
		caption: L.tr('Port 1 Ethernet Protocol '),
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1'})
			.value("dhcp",L.tr("DHCP Server"))
			.value("static",L.tr("STATIC"));

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPPort1lan', {
		caption: L.tr('Port 1 DHCP Server IP'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskPort1lan', {
		caption: L.tr('Port 1 DHCP Netmask'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangePort1lan', {
		caption: L.tr('Port 1 DHCP Start Address'), 
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitPort1lan', {
		caption: L.tr('Port 1 DHCP Limit'), 
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'dhcp'}); 


	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPPort1lan', {
		caption: L.tr('Port 1 Static IP'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskPort1lan', {
		caption: L.tr('Port 1 Netmask'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1','EthernetProtocolPort1lan':'static'}); 

		s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer1', {
		   caption: L.tr('DNS Server'), 
		}).depends({'ethernetconfig' : '1','port':'port1','port1mode' : 'LAN1'})
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer1No1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer1':'1','port1mode' : 'LAN1'})   
		  .depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer1':'2','port1mode' : 'LAN1'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer1No2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer1':'2','port1mode' : 'LAN1'}); 

	s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'port1internetoverlan', {
		caption: L.tr('Port 1 Internet Over LAN'),
		optional: true
		}).depends({'ethernetconfig' : '1','port':'port1','port1mode' : 'LAN1'}); 
		
//////=======================================================================================================================================
	//////	Port 1 Eth0.2  WAN settings
//////=========================================================================================================================================		

		  //s.taboption('ethernetconfig',L.cbi.DummyValue, 'port1lanifname', {
           //caption: L.tr('Port 1 ifname'),
        //}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1'}); 
        
          s.taboption('ethernetconfig',L.cbi.DummyValue, 'port1waninterfacename', {
           caption: L.tr('Port 1 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1'});  
        
          //s.taboption('ethernetconfig',L.cbi.InputValue, 'port1macid', {
           //caption: L.tr('Port 1 MAC Address'), 
        //}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'LAN1'})
		  //.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1'});  
       
		  s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort1wan', {
           caption: L.tr('Port 1 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1'})
          .value("dhcp",L.tr("DHCP Client"))
          .value("static",L.tr("Static"))
	  .value("pppoe",L.tr("PPPoE"));
	  //.value("pptp",L.tr("PPTP"))
	  //.value("l2tp",L.tr("L2TP"));
          
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientDHCPGatewayPort1wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',           
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'dhcp'});

          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientStaticIPPort1wan', {
           caption: L.tr('Static IP'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientnetmaskPort1wan', {
           caption: L.tr('Netmask'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientStaticGatewayPort1wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport1Username' , {
           caption: L.tr('Username'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pppoe'});

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport1Password' , {                                                       
           caption: L.tr('Password'),                                                                                                         
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pppoe'}); 
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport1AccessConcentrator' , {                                                       
           caption: L.tr('Access Concentrator'),   
	   optional: true                                                                                                      
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pppoe'}); 
        
	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport1ServiceName' , {
           caption: L.tr('Service Name'),
	   optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pppoe'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport1ServerAddress' , {
           caption: L.tr('Server Address'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport1Username' , {
           caption: L.tr('User Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport1Password' , {
           caption: L.tr('Password'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue,'EthernetClientPptpport1MppeEncryption' , {
           caption: L.tr('MPPE Encryption'),
           optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp'});
        
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport1DNSServerSource', {
           caption: L.tr('DNS Server Source'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp'})  
        .value("0",L.tr("Get dynamic from ISP"))
        .value("1",L.tr("Use these DNS Servers"));        
  
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport1NumberOfDNSServer', {
           caption: L.tr('Number of DNS Server'),
        }).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp','EthernetClientPptpport1DNSServerSource':'1'})
	.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp','EthernetClientPptpport1DNSServerSource':'1'})  
        .value("1",L.tr("1"))
        .value("2",L.tr("2"));
     
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport1DnsServerNo1', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'1'})  
		.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'2'})
		.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'1'})
		.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'2'}); 
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport1DnsServerNo2', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'pptp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'2'}) 
		.depends({'ethernetconfig':'1','port':'port1','port1mode' : 'EWAN1','EthernetProtocolPort1wan':'l2tp','EthernetClientPptpport1DNSServerSource' : '1','EthernetClientPptpport1NumberOfDNSServer':'2'});

////=======================================================================================================================================
	////	Port 2 Eth0.1  LAN settings
////=========================================================================================================================================		          
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port2settings', {
	caption: L.tr(''),
		}).depends({'ethernetconfig':'1'})
		.ucivalue=function()
			{
			var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPort 2 settings </b> </h3>";
			return id;
			};   

	s.taboption('ethernetconfig',L.cbi.ListValue,'port2mode',{          
		caption:L.tr('Port 2 mode'),                    
		}).depends({'port':'port1'})
			.value("none", L.tr('choose option'))
			.value("LAN2", L.tr('LAN2'))
			.value("SW_LAN", L.tr('SW_LAN'))
			.value("EWAN2", L.tr('EWAN2')); 
		 
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port2lanifname', {
		caption: L.tr('Port 2 ifname'),
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2'})
		.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2'}); 

	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port2laninterfacename', {
		caption: L.tr('Port 2 Interface Name'),
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2'}); 
					  


	s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort2lan', {
		caption: L.tr('Port 2 Ethernet Protocol '),
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2'})
			.value("dhcp",L.tr("DHCP Server"))
			.value("static",L.tr("STATIC"));

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPPort2lan', {
		caption: L.tr('Port 2 DHCP Server IP'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskPort2lan', {
		caption: L.tr('Port 2 DHCP Netmask'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangePort2lan', {
		caption: L.tr('Port 2 DHCP Start Address'), 
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitPort2lan', {
		caption: L.tr('Port 2 DHCP Limit'), 
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'dhcp'}); 


	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPPort2lan', {
		caption: L.tr('Port 2 Static IP'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskPort2lan', {
		caption: L.tr('Port 2 Netmask'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2','EthernetProtocolPort2lan':'static'}); 

		s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer2', {
		   caption: L.tr('DNS Server'), 
		}).depends({'ethernetconfig' : '1','port':'port1','port2mode' : 'LAN2'})  
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer2No1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer2':'1','port2mode' : 'LAN2'})   
		  .depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer2':'2','port2mode' : 'LAN2'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer2No2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer2':'2','port2mode' : 'LAN2'}); 

	s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'port2internetoverlan', {
		caption: L.tr('Port 2 Internet Over LAN'),
		optional: true
		}).depends({'ethernetconfig' : '1','port':'port1','port2mode' : 'LAN2'}); 
		
////=======================================================================================================================================
	////	Port 2 Eth0.2  WAN settings
////=========================================================================================================================================		

		  //s.taboption('ethernetconfig',L.cbi.DummyValue, 'port2lanifname', {
           //caption: L.tr('Port 2 ifname'),
        //}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2'}); 
        
          s.taboption('ethernetconfig',L.cbi.DummyValue, 'port2waninterfacename', {
           caption: L.tr('Port 2 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2'});  
        
          //s.taboption('ethernetconfig',L.cbi.InputValue, 'port2macid', {
           //caption: L.tr('Port 2 MAC Address'), 
        //}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'LAN2'})
		  //.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2'});  
       
		  s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort2wan', {
           caption: L.tr('Port 2 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2'})
          .value("dhcp",L.tr("DHCP Client"))
          .value("static",L.tr("Static"))
	  .value("pppoe",L.tr("PPPoE"));
	  //.value("pptp",L.tr("PPTP"))
	  //.value("l2tp",L.tr("L2TP"));
          
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientDHCPGatewayPort2wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',           
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'dhcp'});

          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientStaticIPPort2wan', {
           caption: L.tr('Static IP'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientnetmaskPort2wan', {
           caption: L.tr('Netmask'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientStaticGatewayPort2wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport2Username' , {
           caption: L.tr('Username'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pppoe'});

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport2Password' , {                                                       
           caption: L.tr('Password'),                                                                                                         
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pppoe'}); 
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport2AccessConcentrator' , {                                                       
           caption: L.tr('Access Concentrator'),   
	   optional: true                                                                                                      
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pppoe'}); 
        
	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport2ServiceName' , {
           caption: L.tr('Service Name'),
	   optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pppoe'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport2ServerAddress' , {
           caption: L.tr('Server Address'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport2Username' , {
           caption: L.tr('User Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport2Password' , {
           caption: L.tr('Password'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue,'EthernetClientPptpport2MppeEncryption' , {
           caption: L.tr('MPPE Encryption'),
           optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp'});
        
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport2DNSServerSource', {
           caption: L.tr('DNS Server Source'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp'})  
        .value("0",L.tr("Get dynamic from ISP"))
        .value("1",L.tr("Use these DNS Servers"));        
  
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport2NumberOfDNSServer', {
           caption: L.tr('Number of DNS Server'),
        }).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp','EthernetClientPptpDNSServerSource':'1'})
	.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp','EthernetClientPptpDNSServerSource':'1'})  
        .value("1",L.tr("1"))
        .value("2",L.tr("2"));
     
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport2DnsServerNo1', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'1'})  
		.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'2'})
		.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'1'})
		.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'2'}); 

		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport2DnsServerNo2', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'pptp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'2'}) 
		.depends({'ethernetconfig':'1','port':'port1','port2mode' : 'EWAN2','EthernetProtocolPort2wan':'l2tp','EthernetClientPptpport2DNSServerSource' : '1','EthernetClientPptpport2NumberOfDNSServer':'2'});

//////=======================================================================================================================================
	//////	Port 3 Eth0.1  LAN settings
//////=========================================================================================================================================		     
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port3settings', {
	caption: L.tr(''),
		}).depends({'ethernetconfig':'1'})
		.ucivalue=function()
			{
			var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPort 3 settings </b> </h3>";
			return id;
			};   

	s.taboption('ethernetconfig',L.cbi.ListValue,'port3mode',{          
		caption:L.tr('Port 3 mode'),                    
		}).depends({'port':'port1'})
			.value("none", L.tr('choose option'))
			.value("LAN3", L.tr('LAN3'))
			.value("SW_LAN", L.tr('SW_LAN'))
			.value("EWAN3", L.tr('EWAN3')); 
		
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port3lanifname', {
		caption: L.tr('Port 3 ifname'),
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3'})
		.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3'}); 

	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port3laninterfacename', {
		caption: L.tr('Port 3 Interface Name'),
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3'}); 
					  


	s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort3lan', {
		caption: L.tr('Port 3 Ethernet Protocol '),
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3'})
			.value("dhcp",L.tr("DHCP Server"))
			.value("static",L.tr("STATIC"));

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPPort3lan', {
		caption: L.tr('Port 3 DHCP Server IP'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskPort3lan', {
		caption: L.tr('Port 3 DHCP Netmask'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangePort3lan', {
		caption: L.tr('Port 3 DHCP Start Address'), 
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitPort3lan', {
		caption: L.tr('Port 3 DHCP Limit'), 
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'dhcp'});  


	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPPort3lan', {
		caption: L.tr('Port 3 Static IP'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskPort3lan', {
		caption: L.tr('Port 3 Netmask'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3','EthernetProtocolPort3lan':'static'}); 

		s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer3', {
		   caption: L.tr('DNS Server'), 
		}).depends({'ethernetconfig' : '1','port':'port1','port3mode' : 'LAN3'})  
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer3No1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer3':'1','port3mode' : 'LAN3'})   
		  .depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer3':'2','port3mode' : 'LAN3'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer3No2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer3':'2','port3mode' : 'LAN3'}); 

	s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'port3internetoverlan', {
		caption: L.tr('Port 3 Internet Over LAN'),
		optional: true
		}).depends({'ethernetconfig' : '1','port':'port1','port3mode' : 'LAN3'}); 
   
////=======================================================================================================================================
	////	Port 3 Eth0.2  WAN settings
////=========================================================================================================================================		

		  //s.taboption('ethernetconfig',L.cbi.DummyValue, 'port3lanifname', {
           //caption: L.tr('Port 3 ifname'),
        //}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3'}); 
        
          s.taboption('ethernetconfig',L.cbi.DummyValue, 'port3waninterfacename', {
           caption: L.tr('Port 3 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3'});  
        
          //s.taboption('ethernetconfig',L.cbi.InputValue, 'port3macid', {
           //caption: L.tr('Port 3 MAC Address'), 
        //}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'LAN3'})
		  //.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3'});  
       
		  s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort3wan', {
           caption: L.tr('Port 3 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3'})
          .value("dhcp",L.tr("DHCP Client"))
          .value("static",L.tr("Static"))
	  .value("pppoe",L.tr("PPPoE"));
	  //.value("pptp",L.tr("PPTP"))
	  //.value("l2tp",L.tr("L2TP"));
          
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientDHCPGatewayPort3wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',           
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'dhcp'});

          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientStaticIPPort3wan', {
           caption: L.tr('Static IP'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientnetmaskPort3wan', {
           caption: L.tr('Netmask'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientStaticGatewayPort3wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'static'});
 s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport3Username' , {
           caption: L.tr('Username'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pppoe'});

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport3Password' , {                                                       
           caption: L.tr('Password'),                                                                                                         
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pppoe'}); 
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport3AccessConcentrator' , {                                                       
           caption: L.tr('Access Concentrator'),   
	   optional: true                                                                                                      
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pppoe'}); 
        
	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport3ServiceName' , {
           caption: L.tr('Service Name'),
	   optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pppoe'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport3ServerAddress' , {
           caption: L.tr('Server Address'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp'})
	      .depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport3Username' , {
           caption: L.tr('User Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport3Password' , {
           caption: L.tr('Password'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue,'EthernetClientPptpport3MppeEncryption' , {
           caption: L.tr('MPPE Encryption'),
           optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp'});
        
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport3DNSServerSource', {
           caption: L.tr('DNS Server Source'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp'})  
        .value("0",L.tr("Get dynamic from ISP"))
        .value("1",L.tr("Use these DNS Servers"));        
  
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport3NumberOfDNSServer', {
           caption: L.tr('Number of DNS Server'),
        }).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp','EthernetClientPptpDNSServerSource':'1'})
	.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp','EthernetClientPptpDNSServerSource':'1'})  
        .value("1",L.tr("1"))
        .value("2",L.tr("2"));
     
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport3DnsServerNo1', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'1'})  
		.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'2'})
		.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'1'})
		.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'2'}); 

		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport3DnsServerNo2', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'pptp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'2'}) 
		.depends({'ethernetconfig':'1','port':'port1','port3mode' : 'EWAN3','EthernetProtocolPort3wan':'l2tp','EthernetClientPptpport3DNSServerSource' : '1','EthernetClientPptpport3NumberOfDNSServer':'2'});

                
//////=======================================================================================================================================
	//////	Port 4 Eth0.1  LAN settings
//////=========================================================================================================================================		
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port4settings', {
	caption: L.tr(''),
		}).depends({'ethernetconfig':'1'})
		.ucivalue=function()
			{
			var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPort 4 settings </b> </h3>";
			return id;
			};   

	s.taboption('ethernetconfig',L.cbi.ListValue,'port4mode',{          
		caption:L.tr('Port 4 mode'),                    
		}).depends({'port':'port1'})
			.value("none", L.tr('choose option'))
			.value("LAN4", L.tr('LAN4'))
			.value("SW_LAN", L.tr('SW_LAN'))
			.value("EWAN4", L.tr('EWAN4')); 
		 
		
	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port4lanifname', {
		caption: L.tr('Port 4 ifname'),
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4'})
		.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4'}); 

	s.taboption('ethernetconfig',L.cbi.DummyValue, 'port4laninterfacename', {
		caption: L.tr('Port 4 Interface Name'),
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4'}); 
					  


	s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort4lan', {
		caption: L.tr('Port 4 Ethernet Protocol '),
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4'})
			.value("dhcp",L.tr("DHCP Server"))
			.value("static",L.tr("STATIC"));

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPPort4lan', {
		caption: L.tr('Port 4 DHCP Server IP'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'dhcp'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskPort4lan', {
		caption: L.tr('Port 4 DHCP Netmask'), 
		datatype: 'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'dhcp'});

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangePort4lan', {
		caption: L.tr('Port 4 DHCP Start Address'), 
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'dhcp'});

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitPort4lan', {
		caption: L.tr('Port 4 DHCP Limit'), 
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'dhcp'});  


	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPPort4lan', {
		caption: L.tr('Port 4 Static IP'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskPort4lan', {
		caption: L.tr('Port 4 Netmask'), 
		datatype:    'ip4addr',
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4','EthernetProtocolPort4lan':'static'});

		s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer4', {
		   caption: L.tr('DNS Server'), 
		}).depends({'ethernetconfig' : '1','port':'port1','port4mode' : 'LAN4'})  
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer4No1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer4':'1','port4mode' : 'LAN4'})   
		  .depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer4':'2','port4mode' : 'LAN4'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer4No2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer4':'2','port4mode' : 'LAN4'}); 

	s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'port4internetoverlan', {
		caption: L.tr('Port 4 Internet Over LAN'),
		optional: true
		}).depends({'ethernetconfig' : '1','port':'port1','port4mode' : 'LAN4'}); 

   
////=======================================================================================================================================
	////	Port 4 Eth0.2  WAN settings
////=========================================================================================================================================		

		  //s.taboption('ethernetconfig',L.cbi.DummyValue, 'port4lanifname', {
           //caption: L.tr('Port 4 ifname'),
        //}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4'}); 
        
          s.taboption('ethernetconfig',L.cbi.DummyValue, 'port4waninterfacename', {
           caption: L.tr('Port 4 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4'});  
        
          //s.taboption('ethernetconfig',L.cbi.InputValue, 'port4macid', {
           //caption: L.tr('Port 4 MAC Address'), 
        //}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'LAN4'})
		  //.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4'});  
       
		  s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort4wan', {
           caption: L.tr('Port 4 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4'})
          .value("dhcp",L.tr("DHCP Client"))
          .value("static",L.tr("Static"))
	  .value("pppoe",L.tr("PPPoE"));
	  //.value("pptp",L.tr("PPTP"))
	  //.value("l2tp",L.tr("L2TP"));
          
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientDHCPGatewayPort4wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',           
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'dhcp'});

          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientStaticIPPort4wan', {
           caption: L.tr('Static IP'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientnetmaskPort4wan', {
           caption: L.tr('Netmask'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'static'});
            
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientStaticGatewayPort4wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport4Username' , {
           caption: L.tr('Username'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pppoe'});

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport4Password' , {                                                       
           caption: L.tr('Password'),                                                                                                         
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pppoe'}); 
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport4AccessConcentrator' , {                                                       
           caption: L.tr('Access Concentrator'),   
	   optional: true                                                                                                      
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pppoe'}); 
        
	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport4ServiceName' , {
           caption: L.tr('Service Name'),
	   optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pppoe'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport4ServerAddress' , {
           caption: L.tr('Server Address'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport4Username' , {
           caption: L.tr('User Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport4Password' , {
           caption: L.tr('Password'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue,'EthernetClientPptpport4MppeEncryption' , {
           caption: L.tr('MPPE Encryption'),
           optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp'});
        
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport4DNSServerSource', {
           caption: L.tr('DNS Server Source'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp'})  
        .value("0",L.tr("Get dynamic from ISP"))
        .value("1",L.tr("Use these DNS Servers"));        
  
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport4NumberOfDNSServer', {
           caption: L.tr('Number of DNS Server'),
        }).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp','EthernetClientPptpDNSServerSource':'1'})
	.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp','EthernetClientPptpDNSServerSource':'1'})  
        .value("1",L.tr("1"))
        .value("2",L.tr("2"));
     
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport4DnsServerNo1', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'1'})  
		.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'2'})
		.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'1'})
		.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'2'}); 

		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport4DnsServerNo2', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'pptp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'2'}) 
		.depends({'ethernetconfig':'1','port':'port1','port4mode' : 'EWAN4','EthernetProtocolPort4wan':'l2tp','EthernetClientPptpport4DNSServerSource' : '1','EthernetClientPptpport4NumberOfDNSServer':'2'});

                
        
////=======================================================================================================================================
	////	Port 5 Eth0.1  LAN settings
////=========================================================================================================================================	         
                s.taboption('ethernetconfig',L.cbi.DummyValue, 'port5settings', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).depends({'ethernetconfig':'1'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPort 5 settings </b> </h3>";
            return id;
          };   
          
         s.taboption('ethernetconfig',L.cbi.ListValue,'port5mode',{          
                        caption:L.tr('Port 5 mode'),                    
                }).depends({'port':'port1'})
                .value("none", L.tr('choose option'))
                .value("LAN5", L.tr('LAN5'))
                .value("SW_LAN", L.tr('SW_LAN'))
                 .value("EWAN5", L.tr('EWAN5')); 
                 
         //s.taboption('ethernetconfig',L.cbi.InputValue, 'port5macid', {
           //caption: L.tr('Port 5 MAC Address'), 
        //}).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5'})
        //.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5'}); 
                
        s.taboption('ethernetconfig',L.cbi.DummyValue, 'port5lanifname', {
           caption: L.tr('Port 5 ifname'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5'}); 
        
           s.taboption('ethernetconfig',L.cbi.DummyValue, 'port5laninterfacename', {
           caption: L.tr('Port 5 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5'});
                              
        
          
          s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort5lan', {
           caption: L.tr('Port 5 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5'})
          .value("dhcp",L.tr("DHCP Server"))
          .value("static",L.tr("STATIC"));
          
           s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPPort5lan', {
           caption: L.tr('Port 5 DHCP Server IP'), 
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'dhcp'}); 
        
         s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskPort5lan', {
           caption: L.tr('Port 5 DHCP Netmask'), 
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'dhcp'}); 
        
           s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangePort5lan', {
           caption: L.tr('Port 5 DHCP Start Address'), 
          // datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'dhcp'}); 
        
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitPort5lan', {
           caption: L.tr('Port 5 DHCP Limit'), 
          // datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'dhcp'}); 
        
       
        s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPPort5lan', {
           caption: L.tr('Port 5 Static IP'), 
           datatype:    'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'static'}); 
        
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskPort5lan', {
           caption: L.tr('Port 5 Netmask'), 
           datatype:    'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'LAN5','EthernetProtocolPort5lan':'static'}); 
     
     	s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer5', {
		   caption: L.tr('DNS Server'), 
		}).depends({'ethernetconfig' : '1','port':'port1','port5mode' : 'LAN5'})  
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer5No1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer5':'1','port5mode' : 'LAN5'})   
		  .depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer5':'2','port5mode' : 'LAN5'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServer5No2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'ethernetconfig':'1','port':'port1','EthernetServerStaticDnsServer5':'2','port5mode' : 'LAN5'});    
        
          s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'port5internetoverlan', {
         caption: L.tr('Port 5 Internet Over LAN'),
         optional: true
         }).depends({'ethernetconfig' : '1','port':'port1','port5mode' : 'LAN5'}); 
          
////=======================================================================================================================================
	////	Port 5 Eth0.3  WAN settings
////=========================================================================================================================================                   
                  s.taboption('ethernetconfig',L.cbi.DummyValue, 'port5waninterfacename', {
           caption: L.tr('Port 5 Interface Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5'});
        
       s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolPort5wan', {
           caption: L.tr('Port 5 Ethernet Protocol '),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5'})
          .value("dhcp",L.tr("DHCP Client"))
          .value("static",L.tr("Static"))
	  .value("pppoe",L.tr("PPPoE"))
	  .value("pptp",L.tr("PPTP"))
	  .value("l2tp",L.tr("L2TP"));
          
      s.taboption('ethernetconfig',L.cbi.ListValue, 'port5IPType', {
           caption: L.tr('WAN IP Type'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp'})
          .value("dynamic",L.tr("Dynamic"))
          .value("static",L.tr("Static"));
                
          s.taboption('ethernetconfig',L.cbi.InputValue,'port5IPaddr' , {
           caption: L.tr('WAN IP Address'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'l2tp'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'pptp'});
        
                  
          s.taboption('ethernetconfig',L.cbi.InputValue,'port5Gateway' , {
           caption: L.tr('WAN Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'l2tp'})     
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'dynamic','EthernetProtocolPort5wan':'l2tp'})       
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'pptp'})     
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'dynamic','EthernetProtocolPort5wan':'pptp'});        
                  
          s.taboption('ethernetconfig',L.cbi.InputValue,'port5Netmask' , {
           caption: L.tr('WAN Netmask'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'l2tp'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','port5IPType':'static','EthernetProtocolPort5wan':'pptp'});        
        
        
            
          
          
          
          s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientDHCPGatewayPort5wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'dhcp'});
                   
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientStaticIPPort5wan', {
           caption: L.tr('Static IP'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'static'});
        
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientnetmaskPort5wan', {
           caption: L.tr('Netmask'), 
           datatype:'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'static'});
        
         s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientStaticGatewayPort5wan' , {
           caption: L.tr('Gateway'),
           datatype: 'ip4addr',
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'static'}); 

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport5Username' , {
           caption: L.tr('Username'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pppoe'});

	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport5Password' , {                                                       
           caption: L.tr('Password'),                                                                                                         
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pppoe'}); 
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport5AccessConcentrator' , {                                                       
           caption: L.tr('Access Concentrator'),   
	   optional: true                                                                                                      
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pppoe'}); 
        
	s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPppoeport5ServiceName' , {
           caption: L.tr('Service Name'),
	   optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pppoe'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport5ServerAddress' , {
           caption: L.tr('Server Address'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport5Username' , {
           caption: L.tr('User Name'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.InputValue,'EthernetClientPptpport5Password' , {
           caption: L.tr('Password'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'})
        .depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp'});
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue,'EthernetClientPptpport5MppeEncryption' , {
           caption: L.tr('MPPE Encryption'),
           optional: true
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'});
        
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport5DNSServerSource', {
           caption: L.tr('DNS Server Source'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp'})
	.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp'})  
        .value("0",L.tr("Get dynamic from ISP"))
        .value("1",L.tr("Use these DNS Servers"));        
  
        s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetClientPptpport5NumberOfDNSServer', {
           caption: L.tr('Number of DNS Server'),
        }).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp','EthernetClientPptpDNSServerSource':'1'})
	.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp','EthernetClientPptpDNSServerSource':'1'})  
        .value("1",L.tr("1"))
        .value("2",L.tr("2"));
     
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport5DnsServerNo1', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'1'})  
		.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'2'})
		.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'1'})
		.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'2'}); 

		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetClientPptpport5DnsServerNo2', {
		caption: L.tr('DNS Server Address'),
		optional: true
		}).depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'pptp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'2'}) 
		.depends({'ethernetconfig':'1','port':'port1','port5mode' : 'EWAN5','EthernetProtocolPort5wan':'l2tp','EthernetClientPptpport5DNSServerSource' : '1','EthernetClientPptpport5NumberOfDNSServer':'2'});




        
 //##################################################################################################################
 
 // SW_LAN Settings
 
 //####################################################################################################################
 
	        s.taboption('ethernetconfig',L.cbi.DummyValue, 'swlansettings', {
		  caption: L.tr(''),
		//  caption: L.tr(a),
        }).depends({'port1mode' : 'SW_LAN'})
        .depends({'port2mode' : 'SW_LAN'})
        .depends({'port3mode' : 'SW_LAN'})
        .depends({'port4mode' : 'SW_LAN'})
        .depends({'port5mode' : 'SW_LAN'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspSW_LAN settings </b> </h3>";
            return id;
          };   
 
    s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetProtocolswlan', {
           caption: L.tr('SW_LAN Ethernet Protocol'),
        }).depends({'port1mode' : 'SW_LAN'})
        .depends({'port2mode' : 'SW_LAN'})
        .depends({'port3mode' : 'SW_LAN'})
        .depends({'port4mode' : 'SW_LAN'})
        .depends({'port5mode' : 'SW_LAN'})
          .value("dhcp",L.tr("DHCP Server"))
          .value("static",L.tr("STATIC"));
          
           s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPIPswlan', {
           caption: L.tr('SW_LAN DHCP Server IP'), 
           datatype: 'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'}); 
        
         s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPNetmaskswlan', {
           caption: L.tr('SW_LAN DHCP Netmask'), 
           datatype: 'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        
           s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPrangeswlan', {
           caption: L.tr('SW_LAN DHCP Start Address'), 
          // datatype: 'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'}); 
        
          s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerDHCPlimitswlan', {
           caption: L.tr('SW_LAN DHCP Limit'), 
          // datatype: 'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'dhcp'}); 
        
       
        s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticIPswlan', {
           caption: L.tr('SW_LAN Static IP'), 
           datatype:    'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'static'}); 
        
         s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticNetmaskswlan', {
           caption: L.tr('SW_LAN Netmask'), 
           datatype:    'ip4addr',
        }).depends({'port1mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port2mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port3mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port4mode' : 'SW_LAN','EthernetProtocolswlan':'static'})
        .depends({'port5mode' : 'SW_LAN','EthernetProtocolswlan':'static'}); 
                 
		s.taboption('ethernetconfig',L.cbi.ListValue, 'EthernetServerStaticDnsServer', {
		   caption: L.tr('DNS Server'), 
		}).depends({'port1mode' : 'SW_LAN'})
        .depends({'port2mode' : 'SW_LAN'})
        .depends({'port3mode' : 'SW_LAN'})
        .depends({'port4mode' : 'SW_LAN'})
        .depends({'port5mode' : 'SW_LAN'})
		  .value("0",L.tr("Please choose no of DNS servers"))
		  .value("1",L.tr("1"))
		  .value("2",L.tr("2"));
		  
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServerNo1', {
			caption: L.tr('DNS Server Address'),
		}).depends({'port1mode' : 'SW_LAN','EthernetServerStaticDnsServer':'1'})
        .depends({'port2mode' : 'SW_LAN','EthernetServerStaticDnsServer':'1'})
        .depends({'port3mode' : 'SW_LAN','EthernetServerStaticDnsServer':'1'})
        .depends({'port4mode' : 'SW_LAN','EthernetServerStaticDnsServer':'1'})
        .depends({'port5mode' : 'SW_LAN','EthernetServerStaticDnsServer':'1'})
		.depends({'port1mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port2mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port3mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port4mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port5mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'}); 
		
		s.taboption('ethernetconfig',L.cbi.InputValue, 'EthernetServerStaticDnsServerNo2', {
			caption: L.tr('DNS Server Address'),
		}).depends({'port1mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port2mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port3mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port4mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'})
        .depends({'port5mode' : 'SW_LAN','EthernetServerStaticDnsServer':'2'}); 
        
        s.taboption('ethernetconfig',L.cbi.CheckboxValue, 'internetoverswlan', {
         caption: L.tr('Internet Over SW_LAN'),
         optional: true
         }).depends({'port1mode' : 'SW_LAN'})
        .depends({'port2mode' : 'SW_LAN'})
        .depends({'port3mode' : 'SW_LAN'})
        .depends({'port4mode' : 'SW_LAN'})
        .depends({'port5mode' : 'SW_LAN'}); 
    
//#################################################################################################################
 // 
 //					Cellular Settings
 //
 // ##################################################################################################################                        

       //s.tab({
            //id: 'cellularconfig',
            //caption: L.tr('Cellular Settings')
        //});        
             //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'enablecellular', {
                        //caption: L.tr('Cellular Enable'),
                        //optional: true
              //}).depends({'cellularconfig' : '1'});
              
        
        //s.taboption('cellularconfig',L.cbi.ListValue, 'CellularOperationMode', {
           //caption: L.tr('Cellular Operation Mode'),
        //}).depends({'cellularconfig':'1','enablecellular':'1'})
          //// .value("none",L.tr("Choose Option"))
            //.value("singlecellulardualsim",L.tr("Single Cellular With Dual SIM"))
          //.value("dualcellularsinglesim",L.tr("Dual Cellular each With Single SIM"))
          //.value("singlecellularsinglesim",L.tr("Single Cellular With Single SIM"));
         
          	//s.taboption('cellularconfig',L.cbi.DummyValue, 'modem1', {
			//caption: L.tr(''),
				//}).depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularconfig':'1','enablecellular':'1'})
				//.ucivalue=function()
					//{
					//var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 1 </b> </h3>";
					//return id;
					//};  
           ////============================General settings ==============================================
           
                //s.taboption('cellularconfig',L.cbi.DummyValue, 'cellularmodem1', {
                        //caption: L.tr('Cellular Modem 1'),
                //}).depends({'cellularconfig':'1'})
               //// .depends({'enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});
                
//5G Network Configuration===================================================
         
               //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'autoconfigsim1', {
                //caption: L.tr('5G Auto Configuration'),
                //optional: true
               //}).depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularmodem1':'QuectelRM500Q','cellularconfig':'1','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','cellularmodem1':'QuectelRM500Q','cellularconfig':'1','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','cellularmodem1':'QuectelRM500Q','cellularconfig':'1','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularmodem1':'QuectelRM500U','cellularconfig':'1','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','cellularmodem1':'QuectelRM500U','cellularconfig':'1','enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','cellularmodem1':'QuectelRM500U','cellularconfig':'1','enablecellular':'1'})
                //.depends({'enablecellular':'1'})
                  
                ////s.taboption('cellularconfig',L.cbi.ListValue, 'networkingmode1', {
				////caption: L.tr('5G Networking Mode'),
                ////}).depends({'cellularconfig':'1'})
                  ////.depends({'enablecellular':'1','autoconfigsim1':'0'})
                ////.value('2', L.tr('SA'))
                ////.value('1', L.tr('NSA'))
                ////.value('0', L.tr('SA/NSA')); 

                //s.taboption('cellularconfig',L.cbi.ListValue, 'rattype1', {
				//caption: L.tr('RAT Type'),
                //}).depends({'cellularconfig':'1'})
                  //.depends({'enablecellular':'1','autoconfigsim1':'0'})
                //.value('AUTO', L.tr('NR 5G/LTE/WCDMA (AUTO)'))               
                //.value('LTE:NR5G', L.tr('LTE/NR 5G'))
                //.value('NR5G', L.tr('NR 5G'))
                //.value('LTE', L.tr('LTE'))
                //.value('WCDMA', L.tr('WCDMA')); 
                
				//s.taboption('cellularconfig',L.cbi.InputValue, 'nsa_bands1', {
                        //caption: L.tr('NSA BANDs')
                //}).depends({'enablecellular':'1','autoconfigsim1':'0'})
 
				//s.taboption('cellularconfig',L.cbi.InputValue, 'sa_bands1', {
                        //caption: L.tr('SA BANDs'),
                //}).depends({'enablecellular':'1','autoconfigsim1':'0'})

//=====================================================================				
				
			/*	 s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsresponseserverenable1', {
                        caption: L.tr('SMS Response To Server Enable 1'),
                        optional: true
              }).depends({'cellularconfig' : '1'})
				.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'smsservernumber1', {
                        caption: L.tr('SMS Server Number 1'),
                }).depends({'cellularconfig' : '1'})
				  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','smsresponseserverenable1': '1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','smsresponseserverenable1': '1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','smsresponseserverenable1': '1'})  ;
                
                 s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsresponsesenderenable1', {
                        caption: L.tr('SMS Response To Sender Enable 1'),
                        optional: true
              }).depends({'cellularconfig' : '1'})
				.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;*/

                /*************Custom settings for module 1 ****************************/
                
              /*   s.taboption('cellularconfig',L.cbi.InputValue, 'Manufacturer1', {
                        caption: L.tr('Manufacturer 1'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'});
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'model1', {
                        caption: L.tr('Model 1'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'});
                           
                     
               
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype1', {
                caption: L.tr('Port Type 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  
                .value("none",L.tr("Choose Option"))
                .value("ttyUSB",L.tr("USB"))
                .value("ttyACM",L.tr("ACM"))
                .value("serail",L.tr("SERIAL"));
          
              s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid1', {
                        caption: L.tr('Vendor ID 1'),
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  ; 
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid1', {
                        caption: L.tr('Product ID 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  ;
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'dataport1', {
                        caption: L.tr('Data Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  ;  
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport1', {
                        caption: L.tr('Communication Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  ; 
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'smsport1', {
                        caption: L.tr('SMS Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'custom'})  ;*/
                
                
                /****************************Display Preconfigured Quectel:EC200-T Modem 1 configurations ************************************/
                
         /*  s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200TManufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tmodel1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tporttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tvendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tproductid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});       
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tdataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});  
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tcomport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});  
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tsmsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC200T'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC200T'});  
           */
           
          
        
                /****************************Display Preconfigured Quectel:EC25-E Modem 1 configurations ************************************/
                
        /*   s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25EManufacturer1', {
           caption: L.tr('Manufacturer 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});   
                
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Emodel1', {
           caption: L.tr('Model 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eporttype1', {
           caption: L.tr('Port type 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Evendorid1', {
           caption: L.tr('Vendor ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});   
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eproductid1', {
           caption: L.tr('Product ID 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});       
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Edataport1', {
           caption: L.tr('Data Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});  
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Ecomport1', {
           caption: L.tr('Communication Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});  
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Esmsport1', {
           caption: L.tr('SMS Port 1'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem1':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem1':'QuectelEC25E'});  */                 
            
                       
             
              /*  s.taboption('cellularconfig',L.cbi.ComboBox, 'Manufacturer1', {
                        caption: L.tr('Manufacturer 1'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})
                .value("Quectel",L.tr("Quectel"));        

                
                s.taboption('cellularconfig',L.cbi.ComboBox, 'model1', {
                        caption: L.tr('Model 1'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'}) 
                 .value("EC200-T",L.tr("EC200-T"));                 
                     
               
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype1', {
                caption: L.tr('Port Type 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  
                .value("none",L.tr("Choose Option"))
                .value("ttyUSB",L.tr("USB"))
                .value("ttyACM",L.tr("ACM"))
                .value("serail",L.tr("SERIAL"));
          
              s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid1', {
                        caption: L.tr('Vendor ID 1'),
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ; 
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid1', {
                        caption: L.tr('Product ID 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ; 
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'dataport1', {
                        caption: L.tr('Data Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;  
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport1', {
                        caption: L.tr('Communication Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ; 
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'smsport1', {
                        caption: L.tr('SMS Port 1'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;  */
                
               /*  s.taboption('cellularconfig',L.cbi.InputValue, 'smsenable1', {
                        caption: L.tr('SMS Enbale 1'),
                }).depends({'cellularconfig' : '1'}); */
                
             /*  s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsenable1', {
                        caption: L.tr('SMS Enable 1'),
                        optional: true
              }).depends({'cellularconfig' : '1'})
				.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'smscenternumber1', {
                        caption: L.tr('SMS Center Number 1'),
                }).depends({'cellularconfig' : '1'})
				  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;
                
                 
               s.taboption('cellularconfig',L.cbi.InputValue, 'deviceid1', {
                        caption: L.tr('Device ID 1'),                       
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'apikey1', {
                        caption: L.tr('API KEY 1'),                       
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});*/
                
                //==================================Module 2 config=================================
                
               /*  s.taboption('cellularconfig',L.cbi.ComboBox, 'Manufacturer2', {
                        caption: L.tr('Manufacturer 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .value("Quectel",L.tr("Quectel"));
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
               // .depends({'CellularOperationMode' : 'singlecellulardualsim'}); 
                
                
                s.taboption('cellularconfig',L.cbi.ComboBox, 'model2', {
                        caption: L.tr('Model 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                 .value("EC200-T",L.tr("EC200-T"));
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim'}); 
                
             // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
             //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
             //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype2', {
               caption: L.tr('Port Type 2'),
             }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
				.value("none",L.tr("Choose Option"))
				.value("ttyUSB",L.tr("USB"))
				.value("ttyACM",L.tr("ACM"))
				.value("serail",L.tr("SERIAL"));
                
                    s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid2', {
                        caption: L.tr('Vendor ID 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});  
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid2', {
                        caption: L.tr('Product ID 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'dataport2', {
                        caption: L.tr('Data Port 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'}); 
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport2', {
                        caption: L.tr('Communication Port 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'}); 
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'smsport2', {
                        caption: L.tr('SMS Port 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});*/
                
                /* s.taboption('cellularconfig',L.cbi.InputValue, 'smsenable2', {
                        caption: L.tr('SMS Enbale 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim'}); */
                
                
                
                                     
            /* s.taboption('cellularconfig',L.cbi.ListValue, 'cellularmodem2', {
                        caption: L.tr('Cellular Modem 2'),
                }).depends({'cellularconfig':'1'})
               .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .value("QuectelEC200T",L.tr("Quectel:EC200-T"))
                .value("QuectelEC25E",L.tr("Quectel:EC25-E"))
                .value("custom",L.tr("Custom"));   */
                
          /*        s.taboption('cellularconfig',L.cbi.DummyValue, 'usbbuspath2', {
                        caption: L.tr('USB Bus Path 2'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});*/
               
               //s.taboption('cellularconfig',L.cbi.ListValue, 'protocol2', {
                        //caption: L.tr('Protocol 2'),
                //}).depends({'cellularconfig':'1'})
               //// .depends({'enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
               //// .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})
                //.value("none",L.tr("Choose Option"))
				//.value("cdcether",L.tr("CDC-ETHER"))
				//.value("ppp",L.tr("PPP"));
				
				
			/*	 s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsresponseserverenable2', {
                        caption: L.tr('SMS Response To Server Enable 2'),
                        optional: true
              }).depends({'cellularconfig' : '1'})
				.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'smsservernumber2', {
                        caption: L.tr('SMS Server Number 2'),
                }).depends({'cellularconfig' : '1'})
				  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','smsresponseserverenable2': '1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','smsresponseserverenable2': '1'})  ;
				
				 s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsresponsesenderenable2', {
                        caption: L.tr('SMS Response To Sender Enable 2'),
                        optional: true
              }).depends({'cellularconfig' : '1'})
				.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'})  ;*/
				                
                
             /*   s.taboption('cellularconfig',L.cbi.InputValue, 'Manufacturer2', {
                        caption: L.tr('Manufacturer 2'),
                }).depends({'cellularconfig':'1'})
               // .depends({'enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'});
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'model2', {
                        caption: L.tr('Model 2'),
                }).depends({'cellularconfig' : '1'})
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                 .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'});
                           
                     
               
                s.taboption('cellularconfig',L.cbi.ListValue, 'porttype2', {
                caption: L.tr('Port Type 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  
                .value("none",L.tr("Choose Option"))
                .value("ttyUSB",L.tr("USB"))
                .value("ttyACM",L.tr("ACM"))
                .value("serail",L.tr("SERIAL"));
          
              s.taboption('cellularconfig',L.cbi.InputValue, 'vendorid2', {
                        caption: L.tr('Vendor ID 2'),
                }).depends({'cellularconfig' : '1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  ; 
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'productid2', {
                        caption: L.tr('Product ID 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  ;
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'dataport2', {
                        caption: L.tr('Data Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  ;  
                
                 s.taboption('cellularconfig',L.cbi.InputValue, 'comport2', {
                        caption: L.tr('Communication Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  ; 
                
                  s.taboption('cellularconfig',L.cbi.InputValue, 'smsport2', {
                        caption: L.tr('SMS Port 2'),
                }).depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'custom'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'custom'})  ;*/
                
                /****************Display Preconfigured MOdem 2 - EC200 -T Configuration*****************************/        
       
          /*  s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200TManufacturer2', {
           caption: L.tr('Manufacturer 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tmodel2', {
           caption: L.tr('Model 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tporttype2', {
           caption: L.tr('Port type 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tvendorid2', {
           caption: L.tr('Vendor ID 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tproductid2', {
           caption: L.tr('Product ID 2'),
           }).depends({'cellularconfig':'1'})
          .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tdataport2', {
           caption: L.tr('Data Port 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tcomport2', {
           caption: L.tr('Communication Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC200Tsmsport2', {
           caption: L.tr('SMS Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC200T'});*/
           
             
           /***********************Display Preconfigured MOdem 2 EC25E configuration**********************************************************************/
           
         /*    s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25EManufacturer2', {
           caption: L.tr('Manufacturer 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Emodel2', {
           caption: L.tr('Model 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eporttype2', {
           caption: L.tr('Port type 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Evendorid2', {
           caption: L.tr('Vendor ID 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Eproductid2', {
           caption: L.tr('Product ID 2'),
           }).depends({'cellularconfig':'1'})
          .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
           s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Edataport2', {
           caption: L.tr('Data Port 2'),
           }).depends({'cellularconfig':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
            s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Ecomport2', {
           caption: L.tr('Communication Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});
           
          s.taboption('cellularconfig',L.cbi.DummyValue, 'QuectelEC25Esmsport2', {
           caption: L.tr('SMS Port 2'),
           }).depends({'cellularconfig':'1'})
           // .depends({'enablecellular':'1'})
           .depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','cellularmodem2':'QuectelEC25E'})
           .depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','cellularmodem2':'QuectelEC25E'});  */                 
          
                   
			/*  s.taboption('cellularconfig',L.cbi.CheckboxValue, 'smsenable2', {
                        caption: L.tr('SMS Enable 2'),
                        optional: true
              }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});
                
                s.taboption('cellularconfig',L.cbi.InputValue, 'smscenternumber2', {
                        caption: L.tr('SMS Center Number 2'),
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});            
                  
                 

               s.taboption('cellularconfig',L.cbi.InputValue, 'deviceid2', {
                        caption: L.tr('Device ID 2'),
                       
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});
                
               s.taboption('cellularconfig',L.cbi.InputValue, 'apikey2', {
                        caption: L.tr('API KEY 2'),                       
                }).depends({'cellularconfig' : '1','CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'});*/
                //=============================================================================               
                       
                
			/*  s.taboption('cellularconfig',L.cbi.CheckboxValue, 'actionmanagerenable', {
                        caption: L.tr('Action Manager Enable'),
                        optional: true
              }).depends({'cellularconfig':'1','CellularOperationMode':'singlecellularsinglesim','CellularOperationMode':'singlecellulardualsim'});*/
             
                //==================================Monitoring settings ==========================================    
          
                /*s.taboption('cellularconfig',L.cbi.CheckboxValue, 'monitorenable1', {
                        caption: L.tr('Monitor 1'),
                        optional: true
                }) .depends({'cellularconfig':'1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'});

                  s.taboption('cellularconfig',L.cbi.InputValue, 'actioninterval1', {
                        caption: L.tr('Action Interval 1 (In Seconds)'),
                        datatype : 'uinteger',
                  }).depends({'cellularconfig':'1'})
                 // .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1'});
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'});

                 
               
                s.taboption('cellularconfig',L.cbi.CheckboxValue, 'querymodematanalytics1', {
                        caption: L.tr('Modem Analytics 1'),
                        optional: true
                }).depends({'cellularconfig':'1'})
                 // .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1'});
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                 .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'});
                 
                
                s.taboption('cellularconfig',L.cbi.CheckboxValue, 'datatestenable1', {
                        caption: L.tr('Data Test 1'),
                        optional: true
                }).depends({'cellularconfig':'1'})
                 // .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1'});
                 .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'});
                
                 s.taboption('cellularconfig',L.cbi.CheckboxValue, 'pingtestenable1', {
                        caption: L.tr('Ping Test 1'),
                        optional: true
                }).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1'});
                    .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                    .depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'});
                 
                s.taboption('cellularconfig',L.cbi.InputValue, 'pingip1', {
                        caption: L.tr('Ping IP 1'),
                        optional: true
                }).depends({'cellularconfig':'1'})
                 // .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1','pingtestenable1' : '1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1','pingtestenable1' : '1'});
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','pingtestenable1' : '1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellularsinglesim','pingtestenable1' : '1','enablecellular':'1'});*/
                
               // =================================Monitoring for sencod module================================== 
                
                 //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'monitorenable2', {
                        //caption: L.tr('Monitor 2'),
                        //optional: true
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'});

                 //s.taboption('cellularconfig',L.cbi.InputValue, 'actioninterval2', {
                        //caption: L.tr('Action Interval 2 (In Seconds)'),
                        //datatype : 'uinteger',
                //}).depends({'cellularconfig':'1'})
                 //// .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','monitorenable1':'1'})
                 //// .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable1':'1'});
                //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'});
           
                //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'querymodematanalytics2', {
                        //caption: L.tr('Modem Analytics 2'),
                        //optional: true
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellularsinglesim','monitorenable2':'1'})
                 // .depends({'CellularOperationMode' : 'singlecellulardualsim','monitorenable2':'1'});
                
                //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'datatestenable2', {
                        //caption: L.tr('Data Test 2'),
                        //caption: L.tr('Data Test 2'),
                        //optional: true
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                 //// .depends({'CellularOperationMode' : 'singlecellularsinglesim'})
                ////  .depends({'CellularOperationMode' : 'singlecellulardualsim'});    
                
                 //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'pingtestenable2', {
                        //caption: L.tr('Ping Test 2'),
                        //optional: true
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                
                //s.taboption('cellularconfig',L.cbi.InputValue, 'pingip2', {
                        //caption: L.tr('Ping IP 2'),
                        //optional: true
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','pingtestenable2' : '1','enablecellular':'1'}) 
                 
                //===================Data /SIM settings===============================
                 //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'dataenable', {
                        //caption: L.tr('Data Service 1'),
                        //optional: true
                //}) .depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});  
                
      /*  s.taboption('cellularconfig',L.cbi.InputValue,'cellular',{          
                        caption:L.tr('Cellular Module'),                    
                }).depends({'cellularconfig':'1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});  */                    
         
         //========================SIM1 Settings ==============================
         
         /* s.taboption('cellularconfig',L.cbi.ListValue, 'service', {         
                        caption: L.tr('Network Mode'),                    
                }).depends({'cellularconfig':'1'})
                  .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})                                
                .value('auto', L.tr('AUTOMATIC'))                             
                .value('lte', L.tr('LTE only')); */                             
                                     
          //s.taboption('cellularconfig',L.cbi.InputValue, 'apn', {
                        //caption: L.tr('SIM 1 Access Point Name')
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'}) ;
                          
          //s.taboption('cellularconfig',L.cbi.ListValue, 'sim1type', {
                        //caption: L.tr('SIM 1 Stack Type')
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                //.value('singlestack', L.tr('IPV6'))                        
                //.value('dualstack', L.tr('IPV4/IPV6'));       
                
          //s.taboption('cellularconfig',L.cbi.ListValue, 'pdp', {
                        //caption: L.tr('SIM 1 PDP Type')
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                //.value('1', L.tr('IPV4'))                        
                //.value('2', L.tr('IPV6'))                        
                //.value('3', L.tr('IPV4V6')); 
                
		//s.taboption('cellularconfig',L.cbi.CheckboxValue, 'Enable464xlatSim1', {
				//caption: L.tr('Enable 464xlat for Sim1')
		//}).depends({'cellularconfig':'1'})
		  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
		  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
		  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});

 
                
         ///* s.taboption('cellularconfig',L.cbi.InputValue, 'pincode', {
                        //caption: L.tr('SIM 1 PIN Code'),
                        //optional: true 
                //}).depends({'cellularconfig' : '1','modemenable':'1','dataenable':'1'});*/
                
                //s.taboption('cellularconfig',L.cbi.InputValue, 'username', {
                        //caption: L.tr('SIM 1 Username'),
                        //optional: true 
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});
                
                //s.taboption('cellularconfig',L.cbi.PasswordValue,'password',{
                        //caption: L.tr('SIM 1 Password'),
                        //optional: true 
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});
                
                //s.taboption('cellularconfig',L.cbi.ListValue, 'auth', {
                        //caption: L.tr('SIM 1 Authentication Protocol'),
                   //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
                //.value('0', L.tr('None'))
                //.value('1', L.tr('PAP'))
                //.value('2', L.tr('CHAP')) 
                //.value('3', L.tr('PAP/CHAP')); 
                
            	//s.taboption('cellularconfig',L.cbi.DummyValue, 'modem2', {
			//caption: L.tr(''),
				//}).depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularconfig':'1','enablecellular':'1'})
				//.ucivalue=function()
					//{
					//var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 2 </b> </h3>";
					//return id;
					//}; 
                 //s.taboption('cellularconfig',L.cbi.DummyValue, 'cellularmodem2', {
                        //caption: L.tr('Cellular Modem 2'),
                //}).depends({'cellularconfig':'1'})
               //// .depends({'enablecellular':'1'})
                //.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
                                
            ////=========================== SIM 2 Settings ====================================
            
			 //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'dataenable2', {
                        //caption: L.tr('Data Service2'),
                        //optional: true
                //}) .depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});  
                 
			

            /*   s.taboption('cellularconfig',L.cbi.ListValue, 'sim2service', {         
                        caption: L.tr('SIM 2 Service'),                    
                })
                //.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' :'dualcellularsinglesim','modemenable':'1','dataenable':'1'})                                
                .depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1','enablecellular':'1'})
                .value('auto', L.tr('AUTOMATIC'))               
                .value('2g', L.tr('2G only'))                           
                .value('lte', L.tr('LTE only')); */                             
                                     
          //s.taboption('cellularconfig',L.cbi.InputValue, 'sim2apn', {
                        //caption: L.tr('SIM 2 Access Point Name')
                //})
                ////.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' :'dualcellularsinglesim','modemenable':'1','dataenable':'1'});
                 //.depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;
                
                
           //s.taboption('cellularconfig',L.cbi.ListValue, 'sim2type', {
					//caption: L.tr('SIM 2 Stack Type')
			//}).depends({'cellularconfig':'1'})		
            //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})
            //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) 
			//.value('singlestack', L.tr('IPV6'))                        
			//.value('dualstack', L.tr('IPV4/IPV6'));       
			
          //s.taboption('cellularconfig',L.cbi.ListValue, 'sim2pdp', {
                        //caption: L.tr('SIM 2 PDP Type')
                //})
                ////.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' :'dualcellularsinglesim','modemenable':'1','dataenable':'1'})
                //.depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) 
                //.value('1', L.tr('IPV4'))                        
                //.value('2', L.tr('IPV6'))                        
                //.value('3', L.tr('IPV4V6')); 
         
			 //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'Enable464xlatSim2', {
				//caption: L.tr('Enable 464xlat for Sim2')
		//}).depends({'cellularconfig':'1'})
		  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
		  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});
			   
         /* s.taboption('cellularconfig',L.cbi.InputValue, 'sim2pincode', {
                        caption: L.tr('SIM 2 PIN Code'),
                        optional: true 
                })
                //.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1'});
                                .depends({'cellularconfig' : '1'})
                .depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1'})
                .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1'});*/
                
                
                //s.taboption('cellularconfig',L.cbi.InputValue, 'sim2username', {
                        //caption: L.tr('SIM 2 Username'),
                        //optional: true 
                //})
               //.depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;
                         
                //s.taboption('cellularconfig',L.cbi.PasswordValue,'sim2password',{
                        //caption: L.tr('SIM 2 Password'),
                        //optional: true 
                //})
               //.depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;
                  
                //s.taboption('cellularconfig',L.cbi.ListValue, 'sim2auth', {
                        //caption: L.tr('SIM 2 Authentication Protocol'),
                //})
                ////.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1'})
              //.depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) 
                //.value('0', L.tr('None'))
                //.value('1', L.tr('PAP'))
                //.value('2', L.tr('CHAP')) 
                //.value('3', L.tr('PAP/CHAP')); 
                
                   //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'primarysimswitchbackenable', {
                        //caption: L.tr('Primary SIM Switchback Enable'),
                        //optional: true
                //}) .depends({'cellularconfig':'1'})
                   //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1'});   
                
                
                  //s.taboption('cellularconfig',L.cbi.InputValue, 'primarysimswitchbacktime', {
                        //caption: L.tr('Primary SIM Switchback Time (In Minutes)'),
                        //optional: true 
                //})
                //.depends({'cellularconfig' : '1'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','primarysimswitchbackenable': '1','enablecellular':'1'});
                
               
                //=================================GPS settings ========================================
                
               /* s.taboption('cellularconfig',L.cbi.CheckboxValue,'gps',{
                        caption:L.tr('GPS Enable'),
                }).depends({'cellularconfig' : '1','modemenable':'1','dataenable':'1'});*/
                
                          
                                                          
                   
       //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'mode2', {
                        //caption: L.tr('Mode2'),
                        //optional: true
                //});
                
       //s.taboption('cellularconfig',L.cbi.CheckboxValue, 'mode3', {
                        //caption: L.tr('Mode3'),
                        //optional: true
                //});
                
         ////=========================Band Lock==========================       
                      //s.tab({
            //id: 'band',
            //caption: L.tr('Band Lock')
        //});
		
      
         ////s.taboption('band',L.cbi.CheckboxValue, 'bandselectenable', {
			////caption:	L.tr('Enable Bandselect')
		////}).depends({'cellularconfig':'1','enablecellular':'1'});
		 
		 
		  //s.taboption('band',L.cbi.ListValue, 'bandselectenable', {         
                        //caption: L.tr('Band Lock Selection'), 
                        //optional: true                   
                //}).depends({'cellularconfig':'1'})
                  //.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1','band':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1','band':'1'})
                  //.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1','band':'1'})                                
                //.value('auto', L.tr('AUTOMATIC'))
                //.value('2g3g', L.tr('2G/3G'))                              
                //.value('lte', L.tr('LTE only'));   
                
              //s.taboption('band',L.cbi.CheckboxValue, 'gsm900', {
                        //caption: L.tr('GSM 900'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : '2g3g'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : '2g3g'});
                
                //s.taboption('band',L.cbi.CheckboxValue, 'gsm1800', {
                        //caption: L.tr('GSM 1800'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : '2g3g'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : '2g3g'});
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'wcdma2100', {
                        //caption: L.tr('WCDMA 2100'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : '2g3g'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : '2g3g'});
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'wcdma850', {
                        //caption: L.tr('WCDMA 850'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : '2g3g'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : '2g3g'});
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'wcdma900', {
                        //caption: L.tr('WCDMA 900'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : '2g3g'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : '2g3g'});
                
                //s.taboption('band',L.cbi.CheckboxValue, 'lteb1', {
                        //caption: L.tr('LTE B1'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb3', {
                        //caption: L.tr('LTE B3'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb5', {
                        //caption: L.tr('LTE B5'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb8', {
                        //caption: L.tr('LTE B8'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb34', {
                        //caption: L.tr('LTE B34'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb38', {
                        //caption: L.tr('LTE B38'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb39', {
                        //caption: L.tr('LTE B39'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb40', {
                        //caption: L.tr('LTE B40'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                 //s.taboption('band',L.cbi.CheckboxValue, 'lteb41', {
                        //caption: L.tr('LTE B41'),
                        //optional: true
                //}).depends({'cellularconfig':'1','enablecellular':'1','dataenable':'1','bandselectenable':'1'})
                //.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1','bandselectenable' : 'lte'})
                //.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1','bandselectenable' : 'lte'});  
                
                                
                        
 //=================================wificonfig settings ========================================
     //WIFI 5 Settings
        //s.tab({
            //id: 'wificonfig',
            //caption: L.tr('WIFI Settings')
        //});
       //s.taboption('wificonfig',L.cbi.CheckboxValue, 'wifi1enable', {
		//caption: L.tr('Enable Wifi Settings'),
		//optional: true
		//}).depends({'wificonfig' : '1'}); 
		
        //s.taboption('wificonfig',L.cbi.DummyValue, 'generalsettings', {
		  //caption: L.tr(''),
        //}).depends({'wificonfig':'1','wifi1enable':'1'})
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp2.4Ghz WIFI Settings</b> </h3>";
            //return id;
          //};  
          
        ////Wifi Devices
        
        //s.taboption('wificonfig', L.cbi.ListValue, 'wifi1protocol', {
		//caption:	L.tr('WirelessMode'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('0', L.tr('B/G mixed'))
		//.value('1', L.tr('B only'))
		//.value('4', L.tr('G only'))
		//.value('9', L.tr('B/G/GN mode'))
		//.value('6', L.tr('N_in_2G mode", --HE Wireless Mode'));
        
          
         //s.taboption('wificonfig', L.cbi.ListValue, 'CountryCode', {
		//caption:	L.tr('Country Code'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('none', L.tr('Please choose'))
		//.value('AF', L.tr('Afghanistan'))
        //.value('AX', L.tr('Åland Islands'))
        //.value('AL', L.tr('ALBANIA'))    
        //.value('AS', L.tr('American Samoa'))  
        //.value('AD', L.tr('Andorra'))  
        //.value('AO', L.tr('Angola'))  
        //.value('AI', L.tr('Anguilla')) 
        //.value('AQ', L.tr('Antarctica')) 
        //.value('AG', L.tr('Antigua and Barbuda')) 
        //.value('AR', L.tr('ARGENTINA'))  
        //.value('AM', L.tr('ARMENIA'))  
        //.value('AW', L.tr('Aruba'))  
        //.value('AU', L.tr('AUSTRALIA'))  
        //.value('AT', L.tr('AUSTRIA'))  
        //.value('AZ', L.tr('AZERBAIJAN'))  
        //.value('BH', L.tr('BAHRAIN'))  
        //.value('BD', L.tr('Bangladesh'))  
        //.value('BB', L.tr('Barbados'))  
        //.value('BY', L.tr('BELARUS'))  
        //.value('BE', L.tr('BELGIUM'))  
        //.value('BZ', L.tr('BELIZE'))  
        //.value('BJ', L.tr('Benin'))  
        //.value('BM', L.tr('Bermuda'))  
        //.value('BT', L.tr('Bhutan'))  
        //.value('BO', L.tr('BOLIVIA'))  
        //.value('BQ', L.tr('Bonaire'))  
        //.value('BQ', L.tr('Sint Eustatius'))  
        //.value('BQ', L.tr('Saba'))  
        //.value('BA', L.tr('Bosnia and Herzegovina'))  
        //.value('BW', L.tr('Botswana'))  
        //.value('BV', L.tr('Bouvet Island'))  
        //.value('BR', L.tr('BRAZIL'))  
        //.value('IO', L.tr('British Indian Ocean Territory'))  
        //.value('BN', L.tr('BRUNEI DARUSSALAM'))  
        //.value('BG', L.tr('BULGARIA'))  
        //.value('BF', L.tr('Burkina Faso'))  
        //.value('BI', L.tr('Burundi'))  
        //.value('CV', L.tr('Cabo Verde'))  
        //.value('KH', L.tr('Cambodia'))  
        //.value('CM', L.tr('Cameroon'))  
        //.value('CA', L.tr('CANADA'))  
        //.value('KY', L.tr('Cayman Islands '))  
        //.value('CF', L.tr('Central African Republic'))  
        //.value('TD', L.tr('Chad'))  
        //.value('CL', L.tr('CHILE'))  
        //.value('CN', L.tr('CHINA'))  
        //.value('CX', L.tr('Christmas Island'))  
        //.value('CC', L.tr('Cocos (Keeling) Islands (the)'))  
        //.value('CO', L.tr('COLOMBIA'))  
        //.value('KM', L.tr('Comoros'))  
        //.value('CD', L.tr('Congo(the Democratic Republic of the)'))  
        //.value('CG', L.tr('Congo'))  
        //.value('CK', L.tr('Cook Islands'))    
        //.value('CR', L.tr('COSTA RICA'))  
        //.value('CI', L.tr('Côte dIvoire'))  
        //.value('HR', L.tr('CROATIA'))  
        //.value('CU', L.tr('Cuba'))  
        //.value('CW', L.tr('Curaçao'))  
        //.value('CY', L.tr('CYPRUS'))  
        //.value('CZ', L.tr('CZECH REPUBLIC'))  
        //.value('DK', L.tr('DENMARK'))  
        //.value('DJ', L.tr('Djibouti'))  
        //.value('DM', L.tr('Dominica'))  
        //.value('DO', L.tr('DOMINICAN REPUBLIC'))  
        //.value('EC', L.tr('ECUADOR'))  
        //.value('EG', L.tr('EGYPT'))  
        //.value('SV', L.tr('EL SALVADOR'))  
        //.value('GQ', L.tr('Equatorial Guinea'))  
        //.value('ER', L.tr('Eritrea'))  
        //.value('EE', L.tr('ESTONIA'))  
        //.value('ET', L.tr('Ethiopia'))  
        //.value('FK', L.tr('Falkland Islands'))  
        //.value('FO', L.tr('Faroe Islands'))  
        //.value('FJ', L.tr('Fiji'))  
        //.value('FI', L.tr('FINLAND'))  
        //.value('FR', L.tr('FRANCE'))  
        //.value('GF', L.tr('French Guiana'))  
        //.value('PF', L.tr('French Polynesia'))  
        //.value('TF', L.tr('French Southern Territories'))  
        //.value('GA', L.tr('Gabon'))  
        //.value('GM', L.tr('Gambia'))  
        //.value('GE', L.tr('GEORGIA'))  
        //.value('DE', L.tr('GERMANY'))  
        //.value('GH', L.tr('Ghana'))  
        //.value('GI', L.tr('Gibraltar'))  
        //.value('GR', L.tr('GREECE'))  
        //.value('GL', L.tr('Greenland'))  
        //.value('GD', L.tr('Grenada'))  
        //.value('GP', L.tr('Guadeloupe'))  
        //.value('GU', L.tr('Guam'))  
        //.value('GT', L.tr('GUATEMALA'))  
        //.value('GG', L.tr('Guernsey'))  
        //.value('GW', L.tr('Guinea-Bissau'))  
        //.value('GY', L.tr('Guyana'))  
        //.value('HT', L.tr('Haiti'))  
        //.value('HM', L.tr('Heard Island and McDonald Islands'))  
        //.value('VA', L.tr('Holy See'))  
        //.value('HN', L.tr('HONDURAS'))  
        //.value('HK', L.tr('HONG KONG'))  
        //.value('HU', L.tr('HUNGARY'))  
        //.value('IS', L.tr('ICELAND'))  
        //.value('IN', L.tr('INDIA'))  
        //.value('ID', L.tr('INDONESIA'))  
        //.value('IR', L.tr('IRAN'))  
        //.value('IQ', L.tr('Iraq'))  
        //.value('IE', L.tr('IRELAND'))  
        //.value('IL', L.tr('ISRAEL'))  
        //.value('IT', L.tr('ITALY'))  
        //.value('JM', L.tr('Jamaica'))  
        //.value('JP', L.tr('JAPAN'))  
        //.value('JE', L.tr('Jersey'))  
        //.value('JO', L.tr('JORDAN'))  
        //.value('KZ', L.tr('KAZAKHSTAN'))  
        //.value('KE', L.tr('Kenya'))  
        //.value('KI', L.tr('Kiribati'))  
        //.value('KP', L.tr('KOREA DEMOCRATIC'))  
        //.value('KR', L.tr('REPUBLIC OF KOREA '))  
        //.value('KW', L.tr('KUWAIT'))  
        //.value('KG', L.tr('Kyrgyzstan'))  
        //.value('LA', L.tr('Lao People Democratic Republic'))  
        //.value('LV', L.tr('LATVIA'))  
        //.value('LB', L.tr('LEBANON'))  
        //.value('LS', L.tr('Lesotho'))  
        //.value('LR', L.tr('Liberia'))  
        //.value('LY', L.tr('Libya'))  
        //.value('LI', L.tr('LIECHTENSTEIN'))  
        //.value('LT', L.tr('LITHUANIA'))  
        //.value('LU', L.tr('LUXEMBOURG'))  
        //.value('MO', L.tr('MACAO'))  
        //.value('MK', L.tr('MACEDONIA'))  
        //.value('MG', L.tr('Madagascar'))  
        //.value('MW', L.tr('Malawi'))  
        //.value('MY', L.tr('MALAYSIA'))  
        //.value('MV', L.tr('Maldives'))  
        //.value('ML', L.tr('Mali'))  
        //.value('MT', L.tr('Malta'))  
        //.value('MH', L.tr('Marshall Islands'))  
        //.value('MQ', L.tr('Martinique'))  
        //.value('MR', L.tr('Mauritania'))  
        //.value('MU', L.tr('Mauritius'))  
        //.value('YT', L.tr('Mayotte'))  
        //.value('MX', L.tr('MEXICO'))  
        //.value('FM', L.tr('Micronesia'))  
        //.value('MD', L.tr('Moldova'))  
        //.value('MC', L.tr('MONACO'))  
        //.value('MN', L.tr('Mongolia'))  
        //.value('ME', L.tr('Montenegro'))  
        //.value('MS', L.tr('Montserrat'))  
        //.value('MA', L.tr('MOROCCO'))  
        //.value('MZ', L.tr('Mozambique'))  
        //.value('MM', L.tr('Myanmar'))  
        //.value('NA', L.tr('Namibia'))  
        //.value('NR', L.tr('Nauru'))  
        //.value('NP', L.tr('Nepal'))  
        //.value('NL', L.tr('NETHERLANDS'))  
        //.value('NC', L.tr('New Caledonia '))  
        //.value('NZ', L.tr('NEW ZEALAND'))   
        //.value('NI', L.tr('Nicaragua'))  
        //.value('NE', L.tr('Niger'))  
        //.value('NG', L.tr('Nigeria'))  
        //.value('NU', L.tr('Niue'))  
        //.value('NF', L.tr('Norfolk Island'))  
        //.value('MP', L.tr('Northern Mariana Islands'))  
        //.value('NO', L.tr('NORWAY')) 
        //.value('OM', L.tr('OMAN'))  
        //.value('PK', L.tr('PAKISTAN'))  
        //.value('PW', L.tr('Palau'))  
        //.value('PS', L.tr('Palestine'))  
        //.value('PA', L.tr('PANAMA'))  
        //.value('PG', L.tr('Papua New Guinea'))  
        //.value('PY', L.tr('Paraguay'))  
        //.value('PE', L.tr('PERU'))  
        //.value('PH', L.tr('PHILIPPINES'))  
        //.value('PN', L.tr('Pitcairn'))  
        //.value('PL', L.tr('POLAND'))  
        //.value('PT', L.tr('PORTUGAL'))  
        //.value('PR', L.tr('PUERTO RICO'))  
        //.value('QA', L.tr('QATAR'))  
        //.value('RE', L.tr('Réunion'))  
        //.value('RO', L.tr('ROMANIA'))  
        //.value('RU', L.tr('RUSSIA FEDERATION'))  
        //.value('RW', L.tr('Rwanda'))  
        //.value('BL', L.tr('Saint Barthélemy'))  
        //.value('SH', L.tr('Saint Helena'))  
        //.value('SH', L.tr('Ascension Island'))  
        //.value('SH', L.tr('Tristan da Cunha'))  
        //.value('KN', L.tr('Saint Kitts and Nevis'))  
        //.value('LC', L.tr('Saint Lucia'))  
        //.value('MF', L.tr('Saint Martin '))  
        //.value('PM', L.tr('Saint Pierre and Miquelon'))  
        //.value('VC', L.tr('Saint Vincent and the Grenadines'))  
        //.value('WS', L.tr('Samoa'))  
        //.value('SM', L.tr('San Marino'))  
        //.value('ST', L.tr('Sao Tome and Principe'))  
        //.value('SA', L.tr('SAUDI ARABIA'))  
        //.value('SN', L.tr('Senegal'))  
        //.value('RS', L.tr('Serbia'))  
        //.value('SC', L.tr('Seychelles'))  
        //.value('SL', L.tr('Sierra Leone'))  
        //.value('SG', L.tr('SINGAPORE'))  
        //.value('SX', L.tr('Sint Maarten'))  
        //.value('SK', L.tr('SLOVAKIA'))  
        //.value('SI', L.tr('SLOVENIA'))  
        //.value('SB', L.tr('Solomon Islands'))  
        //.value('SO', L.tr('Somalia'))  
        //.value('ZA', L.tr('SOUTH AFRICA'))  
        //.value('GS', L.tr('South Georgia and the South Sandwich Islands'))  
        //.value('SS', L.tr('South Sudan'))  
        //.value('ES', L.tr('SPAIN'))  
        //.value('LK', L.tr('Sri Lanka'))  
        //.value('SD', L.tr('Sudan'))  
        //.value('SR', L.tr('Suriname'))  
        //.value('SJ', L.tr('Svalbard'))  
        //.value('SJ', L.tr('Jan Mayen'))  
        //.value('SE', L.tr('SWEDEN'))  
        //.value('CH', L.tr('SWITZERLAND'))  
        //.value('SY', L.tr('SYRIAN ARAB REPUBLIC'))  
        //.value('TW', L.tr('TAIWAN'))  
        //.value('TJ', L.tr('Tajikistan'))  
        //.value('TZ', L.tr('Tanzania'))  
        //.value('TH', L.tr('THAILAND'))  
        //.value('TL', L.tr('Timor-Leste'))  
        //.value('TG', L.tr('Togo'))  
        //.value('TK', L.tr('Tokelau'))  
        //.value('TO', L.tr('Tonga'))  
        //.value('TT', L.tr('TRINIDAD AND TOBAGO'))  
        //.value('TN', L.tr('TUNISIA'))  
        //.value('TR', L.tr('TURKEY'))  
        //.value('TM', L.tr('Turkmenistan'))  
        //.value('TC', L.tr('Turks and Caicos Islands'))  
        //.value('TV', L.tr('Tuvalu'))  
        //.value('UG', L.tr('Uganda'))  
        //.value('UA', L.tr('UKRAINE'))  
        //.value('AE', L.tr('UNITED ARAB EMIRATES'))  
        //.value('GB', L.tr('UNITED KINGDOM'))  
        //.value('US', L.tr('UNITED STATES'))  
        //.value('UY', L.tr('URUGUAY'))  
        //.value('UZ', L.tr('UZBEKISTAN'))  
        //.value('VU', L.tr('Vanuatu'))  
        //.value('VE', L.tr('VENEZUELA'))  
        //.value('VN', L.tr('VIET NAM'))  
        //.value('VG', L.tr('Virgin Islands'))  
        //.value('WF', L.tr('Wallis and Futuna'))  
        //.value('EH', L.tr('Western Sahara '))  
        //.value('YE', L.tr('YEMEN'))  
        //.value('ZM', L.tr('Zambia'))  
        //.value('ZW', L.tr('ZIMBABWE')); 
        
        //s.taboption('wificonfig', L.cbi.ListValue, 'wifi1CountryRegion', {
			//caption:	L.tr('CountryRegion'),
			//initial:	'none'
		//}).depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'ap'})
		//.value('0', L.tr('0: Ch1-11'))
		//.value('1', L.tr('1: Ch1-13'))
		//.value('2', L.tr('2: Ch10-11'))
		//.value('3', L.tr('3: Ch10-13'))
		//.value('4', L.tr('4: Ch14'))
		//.value('5', L.tr('5: Ch1-14'))
		//.value('6', L.tr('6: Ch3-9'))
		//.value('7', L.tr('7: Ch5-13'))
		//.value('31', L.tr('31: Ch1-11,Ch12-14'))
		//.value('32', L.tr('32: Ch1-11,Ch12-13'))
		//.value('33', L.tr('33: Ch1-14'));
        
         //s.taboption('wificonfig',L.cbi.ListValue, 'wifideviceschannel', {
			//caption:	L.tr('Channel'),
			//description: L.tr('Select Channel depending on CountryRegion')
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('1', L.tr('1'))
		//.value('2', L.tr('2'))
		//.value('3', L.tr('3'))
		//.value('4', L.tr('4'))
		//.value('5', L.tr('5'))
		//.value('6', L.tr('6'))
		//.value('7', L.tr('7'))
		//.value('8', L.tr('8'))
		//.value('9', L.tr('9'))
		//.value('10', L.tr('10'))
		//.value('11', L.tr('11'))
		//.value('12', L.tr('12'))
		//.value('13', L.tr('13'))
		//.value('14', L.tr('14'))
		//.value('auto', L.tr('auto'));
         
		//s.taboption('wificonfig', L.cbi.ListValue, 'channelwidth', {
		//caption:	L.tr('Channel BandWidth'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('0', L.tr('20 MHz'))
		//.value('1', L.tr('20/40 MHz')); 
				
	    //s.taboption('wificonfig', L.cbi.InputValue, 'TxPower', {
		//caption:	L.tr('TX Power'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'});
					       
        //s.taboption('wificonfig', L.cbi.InputValue, 'wifi1ssid', {
			//caption:	'Radio SSID'
		//}).depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'ap'})
		  //.depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
		//s.taboption('wificonfig', L.cbi.PasswordValue, 'wifi1key', {
			//caption:	L.tr('Radio Passphrase'),
			//datatype:'rangelength(8,11)',
			//optional:	true
		//}).depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'ap'})
		  //.depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
	
	            //s.taboption('wificonfig', L.cbi.ListValue, 'wifi1mode', {
                        //caption:        L.tr('Radio Mode'),
                //}).depends({'wificonfig':'1','wifi1enable':'1'})
                //.value('ap', L.tr('Access Point'));
        ////      .value('sta', L.tr('Client only'))
        ////      .value('apsta', L.tr('Access Point and Client'));

                //s.taboption('wificonfig', L.cbi.ListValue, 'wifi1encryption', {
                        //caption:        L.tr('Radio Encryption'),
                        //initial:        'none'
                //}).depends({'wificonfig':'1','wifi1enable':'1'})
                //.value('NONE', L.tr('NONE'))
                //.value('TKIP', L.tr('TKIP'))
                //.value('AES', L.tr('AES'));

                         //s.taboption('wificonfig',L.cbi.InputValue, 'radio0dhcpip', {
           //caption: L.tr('Radio DHCP Server IP'), 
           //datatype: 'ip4addr',
                //}).depends({'wificonfig':'1','wifi1enable':'1'});
        
                
           //s.taboption('wificonfig',L.cbi.InputValue, 'Radio0DHCPrange', {
           //caption: L.tr('Radio DHCP Start Address'), 
                //}).depends({'wificonfig':'1','wifi1enable':'1'});
        
          //s.taboption('wificonfig',L.cbi.InputValue, 'Radio0DHCPlimit', {
           //caption: L.tr('Radio DHCP Limit'), 
                //}).depends({'wificonfig':'1','wifi1enable':'1'});

      ////5Ghz WIFI Settings		
      //s.taboption('wificonfig',L.cbi.DummyValue, 'WIFI5Settings', {
		  //caption: L.tr(''),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp5Ghz WIFI Settings</b> </h3>";
            //return id;
          //};  
          
        ////
        //s.taboption('wificonfig', L.cbi.ListValue, 'wifi51protocol', {
		//caption:	L.tr('WirelessMode'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('5g', L.tr('mixed'));
        
          
         //s.taboption('wificonfig', L.cbi.ListValue, 'wifi5CountryCode', {
		//caption:	L.tr('Country Code'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('none', L.tr('Please choose'))
		//.value('AF', L.tr('Afghanistan'))
        //.value('AX', L.tr('Åland Islands'))
        //.value('AL', L.tr('ALBANIA'))    
        //.value('AS', L.tr('American Samoa'))  
        //.value('AD', L.tr('Andorra'))  
        //.value('AO', L.tr('Angola'))  
        //.value('AI', L.tr('Anguilla')) 
        //.value('AQ', L.tr('Antarctica')) 
        //.value('AG', L.tr('Antigua and Barbuda')) 
        //.value('AR', L.tr('ARGENTINA'))  
        //.value('AM', L.tr('ARMENIA'))  
        //.value('AW', L.tr('Aruba'))  
        //.value('AU', L.tr('AUSTRALIA'))  
        //.value('AT', L.tr('AUSTRIA'))  
        //.value('AZ', L.tr('AZERBAIJAN'))  
        //.value('BH', L.tr('BAHRAIN'))  
        //.value('BD', L.tr('Bangladesh'))  
        //.value('BB', L.tr('Barbados'))  
        //.value('BY', L.tr('BELARUS'))  
        //.value('BE', L.tr('BELGIUM'))  
        //.value('BZ', L.tr('BELIZE'))  
        //.value('BJ', L.tr('Benin'))  
        //.value('BM', L.tr('Bermuda'))  
        //.value('BT', L.tr('Bhutan'))  
        //.value('BO', L.tr('BOLIVIA'))  
        //.value('BQ', L.tr('Bonaire'))  
        //.value('BQ', L.tr('Sint Eustatius'))  
        //.value('BQ', L.tr('Saba'))  
        //.value('BA', L.tr('Bosnia and Herzegovina'))  
        //.value('BW', L.tr('Botswana'))  
        //.value('BV', L.tr('Bouvet Island'))  
        //.value('BR', L.tr('BRAZIL'))  
        //.value('IO', L.tr('British Indian Ocean Territory'))  
        //.value('BN', L.tr('BRUNEI DARUSSALAM'))  
        //.value('BG', L.tr('BULGARIA'))  
        //.value('BF', L.tr('Burkina Faso'))  
        //.value('BI', L.tr('Burundi'))  
        //.value('CV', L.tr('Cabo Verde'))  
        //.value('KH', L.tr('Cambodia'))  
        //.value('CM', L.tr('Cameroon'))  
        //.value('CA', L.tr('CANADA'))  
        //.value('KY', L.tr('Cayman Islands '))  
        //.value('CF', L.tr('Central African Republic'))  
        //.value('TD', L.tr('Chad'))  
        //.value('CL', L.tr('CHILE'))  
        //.value('CN', L.tr('CHINA'))  
        //.value('CX', L.tr('Christmas Island'))  
        //.value('CC', L.tr('Cocos (Keeling) Islands (the)'))  
        //.value('CO', L.tr('COLOMBIA'))  
        //.value('KM', L.tr('Comoros'))  
        //.value('CD', L.tr('Congo(the Democratic Republic of the)'))  
        //.value('CG', L.tr('Congo'))  
        //.value('CK', L.tr('Cook Islands'))    
        //.value('CR', L.tr('COSTA RICA'))  
        //.value('CI', L.tr('Côte dIvoire'))  
        //.value('HR', L.tr('CROATIA'))  
        //.value('CU', L.tr('Cuba'))  
        //.value('CW', L.tr('Curaçao'))  
        //.value('CY', L.tr('CYPRUS'))  
        //.value('CZ', L.tr('CZECH REPUBLIC'))  
        //.value('DK', L.tr('DENMARK'))  
        //.value('DJ', L.tr('Djibouti'))  
        //.value('DM', L.tr('Dominica'))  
        //.value('DO', L.tr('DOMINICAN REPUBLIC'))  
        //.value('EC', L.tr('ECUADOR'))  
        //.value('EG', L.tr('EGYPT'))  
        //.value('SV', L.tr('EL SALVADOR'))  
        //.value('GQ', L.tr('Equatorial Guinea'))  
        //.value('ER', L.tr('Eritrea'))  
        //.value('EE', L.tr('ESTONIA'))  
        //.value('ET', L.tr('Ethiopia'))  
        //.value('FK', L.tr('Falkland Islands'))  
        //.value('FO', L.tr('Faroe Islands'))  
        //.value('FJ', L.tr('Fiji'))  
        //.value('FI', L.tr('FINLAND'))  
        //.value('FR', L.tr('FRANCE'))  
        //.value('GF', L.tr('French Guiana'))  
        //.value('PF', L.tr('French Polynesia'))  
        //.value('TF', L.tr('French Southern Territories'))  
        //.value('GA', L.tr('Gabon'))  
        //.value('GM', L.tr('Gambia'))  
        //.value('GE', L.tr('GEORGIA'))  
        //.value('DE', L.tr('GERMANY'))  
        //.value('GH', L.tr('Ghana'))  
        //.value('GI', L.tr('Gibraltar'))  
        //.value('GR', L.tr('GREECE'))  
        //.value('GL', L.tr('Greenland'))  
        //.value('GD', L.tr('Grenada'))  
        //.value('GP', L.tr('Guadeloupe'))  
        //.value('GU', L.tr('Guam'))  
        //.value('GT', L.tr('GUATEMALA'))  
        //.value('GG', L.tr('Guernsey'))  
        //.value('GW', L.tr('Guinea-Bissau'))  
        //.value('GY', L.tr('Guyana'))  
        //.value('HT', L.tr('Haiti'))  
        //.value('HM', L.tr('Heard Island and McDonald Islands'))  
        //.value('VA', L.tr('Holy See'))  
        //.value('HN', L.tr('HONDURAS'))  
        //.value('HK', L.tr('HONG KONG'))  
        //.value('HU', L.tr('HUNGARY'))  
        //.value('IS', L.tr('ICELAND'))  
        //.value('IN', L.tr('INDIA'))  
        //.value('ID', L.tr('INDONESIA'))  
        //.value('IR', L.tr('IRAN'))  
        //.value('IQ', L.tr('Iraq'))  
        //.value('IE', L.tr('IRELAND'))  
        //.value('IL', L.tr('ISRAEL'))  
        //.value('IT', L.tr('ITALY'))  
        //.value('JM', L.tr('Jamaica'))  
        //.value('JP', L.tr('JAPAN'))  
        //.value('JE', L.tr('Jersey'))  
        //.value('JO', L.tr('JORDAN'))  
        //.value('KZ', L.tr('KAZAKHSTAN'))  
        //.value('KE', L.tr('Kenya'))  
        //.value('KI', L.tr('Kiribati'))  
        //.value('KP', L.tr('KOREA DEMOCRATIC'))  
        //.value('KR', L.tr('REPUBLIC OF KOREA '))  
        //.value('KW', L.tr('KUWAIT'))  
        //.value('KG', L.tr('Kyrgyzstan'))  
        //.value('LA', L.tr('Lao People Democratic Republic'))  
        //.value('LV', L.tr('LATVIA'))  
        //.value('LB', L.tr('LEBANON'))  
        //.value('LS', L.tr('Lesotho'))  
        //.value('LR', L.tr('Liberia'))  
        //.value('LY', L.tr('Libya'))  
        //.value('LI', L.tr('LIECHTENSTEIN'))  
        //.value('LT', L.tr('LITHUANIA'))  
        //.value('LU', L.tr('LUXEMBOURG'))  
        //.value('MO', L.tr('MACAO'))  
        //.value('MK', L.tr('MACEDONIA'))  
        //.value('MG', L.tr('Madagascar'))  
        //.value('MW', L.tr('Malawi'))  
        //.value('MY', L.tr('MALAYSIA'))  
        //.value('MV', L.tr('Maldives'))  
        //.value('ML', L.tr('Mali'))  
        //.value('MT', L.tr('Malta'))  
        //.value('MH', L.tr('Marshall Islands'))  
        //.value('MQ', L.tr('Martinique'))  
        //.value('MR', L.tr('Mauritania'))  
        //.value('MU', L.tr('Mauritius'))  
        //.value('YT', L.tr('Mayotte'))  
        //.value('MX', L.tr('MEXICO'))  
        //.value('FM', L.tr('Micronesia'))  
        //.value('MD', L.tr('Moldova'))  
        //.value('MC', L.tr('MONACO'))  
        //.value('MN', L.tr('Mongolia'))  
        //.value('ME', L.tr('Montenegro'))  
        //.value('MS', L.tr('Montserrat'))  
        //.value('MA', L.tr('MOROCCO'))  
        //.value('MZ', L.tr('Mozambique'))  
        //.value('MM', L.tr('Myanmar'))  
        //.value('NA', L.tr('Namibia'))  
        //.value('NR', L.tr('Nauru'))  
        //.value('NP', L.tr('Nepal'))  
        //.value('NL', L.tr('NETHERLANDS'))  
        //.value('NC', L.tr('New Caledonia '))  
        //.value('NZ', L.tr('NEW ZEALAND'))   
        //.value('NI', L.tr('Nicaragua'))  
        //.value('NE', L.tr('Niger'))  
        //.value('NG', L.tr('Nigeria'))  
        //.value('NU', L.tr('Niue'))  
        //.value('NF', L.tr('Norfolk Island'))  
        //.value('MP', L.tr('Northern Mariana Islands'))  
        //.value('NO', L.tr('NORWAY')) 
        //.value('OM', L.tr('OMAN'))  
        //.value('PK', L.tr('PAKISTAN'))  
        //.value('PW', L.tr('Palau'))  
        //.value('PS', L.tr('Palestine'))  
        //.value('PA', L.tr('PANAMA'))  
        //.value('PG', L.tr('Papua New Guinea'))  
        //.value('PY', L.tr('Paraguay'))  
        //.value('PE', L.tr('PERU'))  
        //.value('PH', L.tr('PHILIPPINES'))  
        //.value('PN', L.tr('Pitcairn'))  
        //.value('PL', L.tr('POLAND'))  
        //.value('PT', L.tr('PORTUGAL'))  
        //.value('PR', L.tr('PUERTO RICO'))  
        //.value('QA', L.tr('QATAR'))  
        //.value('RE', L.tr('Réunion'))  
        //.value('RO', L.tr('ROMANIA'))  
        //.value('RU', L.tr('RUSSIA FEDERATION'))  
        //.value('RW', L.tr('Rwanda'))  
        //.value('BL', L.tr('Saint Barthélemy'))  
        //.value('SH', L.tr('Saint Helena'))  
        //.value('SH', L.tr('Ascension Island'))  
        //.value('SH', L.tr('Tristan da Cunha'))  
        //.value('KN', L.tr('Saint Kitts and Nevis'))  
        //.value('LC', L.tr('Saint Lucia'))  
        //.value('MF', L.tr('Saint Martin '))  
        //.value('PM', L.tr('Saint Pierre and Miquelon'))  
        //.value('VC', L.tr('Saint Vincent and the Grenadines'))  
        //.value('WS', L.tr('Samoa'))  
        //.value('SM', L.tr('San Marino'))  
        //.value('ST', L.tr('Sao Tome and Principe'))  
        //.value('SA', L.tr('SAUDI ARABIA'))  
        //.value('SN', L.tr('Senegal'))  
        //.value('RS', L.tr('Serbia'))  
        //.value('SC', L.tr('Seychelles'))  
        //.value('SL', L.tr('Sierra Leone'))  
        //.value('SG', L.tr('SINGAPORE'))  
        //.value('SX', L.tr('Sint Maarten'))  
        //.value('SK', L.tr('SLOVAKIA'))  
        //.value('SI', L.tr('SLOVENIA'))  
        //.value('SB', L.tr('Solomon Islands'))  
        //.value('SO', L.tr('Somalia'))  
        //.value('ZA', L.tr('SOUTH AFRICA'))  
        //.value('GS', L.tr('South Georgia and the South Sandwich Islands'))  
        //.value('SS', L.tr('South Sudan'))  
        //.value('ES', L.tr('SPAIN'))  
        //.value('LK', L.tr('Sri Lanka'))  
        //.value('SD', L.tr('Sudan'))  
        //.value('SR', L.tr('Suriname'))  
        //.value('SJ', L.tr('Svalbard'))  
        //.value('SJ', L.tr('Jan Mayen'))  
        //.value('SE', L.tr('SWEDEN'))  
        //.value('CH', L.tr('SWITZERLAND'))  
        //.value('SY', L.tr('SYRIAN ARAB REPUBLIC'))  
        //.value('TW', L.tr('TAIWAN'))  
        //.value('TJ', L.tr('Tajikistan'))  
        //.value('TZ', L.tr('Tanzania'))  
        //.value('TH', L.tr('THAILAND'))  
        //.value('TL', L.tr('Timor-Leste'))  
        //.value('TG', L.tr('Togo'))  
        //.value('TK', L.tr('Tokelau'))  
        //.value('TO', L.tr('Tonga'))  
        //.value('TT', L.tr('TRINIDAD AND TOBAGO'))  
        //.value('TN', L.tr('TUNISIA'))  
        //.value('TR', L.tr('TURKEY'))  
        //.value('TM', L.tr('Turkmenistan'))  
        //.value('TC', L.tr('Turks and Caicos Islands'))  
        //.value('TV', L.tr('Tuvalu'))  
        //.value('UG', L.tr('Uganda'))  
        //.value('UA', L.tr('UKRAINE'))  
        //.value('AE', L.tr('UNITED ARAB EMIRATES'))  
        //.value('GB', L.tr('UNITED KINGDOM'))  
        //.value('US', L.tr('UNITED STATES'))  
        //.value('UY', L.tr('URUGUAY'))  
        //.value('UZ', L.tr('UZBEKISTAN'))  
        //.value('VU', L.tr('Vanuatu'))  
        //.value('VE', L.tr('VENEZUELA'))  
        //.value('VN', L.tr('VIET NAM'))  
        //.value('VG', L.tr('Virgin Islands'))  
        //.value('WF', L.tr('Wallis and Futuna'))  
        //.value('EH', L.tr('Western Sahara '))  
        //.value('YE', L.tr('YEMEN'))  
        //.value('ZM', L.tr('Zambia'))  
        //.value('ZW', L.tr('ZIMBABWE')); 

		//s.taboption('wificonfig', L.cbi.ListValue, 'wifi5CountryRegion', {
			//caption:	L.tr('CountryRegion'),
			//initial:	'none'
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'})
		//.value('0', L.tr('0: Ch36-64, Ch149-165'))
		//.value('1', L.tr('1: Ch36-64, Ch100-140'))
		//.value('2', L.tr('2: Ch36-64'))
		//.value('3', L.tr('3: Ch52-64, Ch149-161'))
		//.value('4', L.tr('4: Ch149-165'))
		//.value('5', L.tr('5: Ch149-161'))
		//.value('6', L.tr('6: Ch36-48'))
		//.value('7', L.tr('7: Ch36-64, Ch100-140, Ch149-165'))
		//.value('8', L.tr('8: Ch52-64'))
		//.value('9', L.tr('9: Ch36-64, Ch100-116, Ch132-140, Ch149-165'))
		//.value('10', L.tr('10: Ch36-48, Ch149-165'))
		//.value('11', L.tr('11: Ch36-64, Ch100-120, Ch149-161'))
		//.value('12', L.tr('12: Ch36-64, Ch100-144'))
		//.value('13', L.tr('13: Ch36-64, Ch100-144, Ch149-165'))
		//.value('14', L.tr('14: Ch36-64, Ch100-116, Ch132-144, Ch149-165'))
		//.value('15', L.tr('15: Ch149-173'))
		//.value('16', L.tr('16: Ch52-64, Ch149-165'))
		//.value('17', L.tr('17: Ch36-48, Ch149-161'))
		//.value('18', L.tr('18: Ch36-64, Ch100-116, Ch132-140'))
		//.value('19', L.tr('19: Ch56-64, Ch100-140, Ch149-161'))
		//.value('20', L.tr('20: Ch36-64, Ch100-124, Ch149-161'))
		//.value('21', L.tr('21: Ch36-64, Ch100-140, Ch149-161'))
		//.value('22', L.tr('22: Ch100-140'))
		//.value('30', L.tr('30: Ch36-48, Ch52-64, Ch100-140, Ch149-165'))
		//.value('31', L.tr('31: Ch52-64, Ch100-140, Ch149-165'))
		//.value('32', L.tr('32: Ch36-48, Ch52-64, Ch100-140, Ch149-161'))
		//.value('33', L.tr('33: Ch36-48, Ch52-64, Ch100-140'))
		//.value('34', L.tr('34: Ch36-48, Ch52-64, Ch149-165'))
		//.value('35', L.tr('35: Ch36-48, Ch52-64'))
		//.value('36', L.tr('36: Ch36-48, Ch100-140, Ch149-165'))
		//.value('37', L.tr('37: Ch36-48, Ch52-64, Ch149-165, Ch173'));        
        
         //s.taboption('wificonfig',L.cbi.ListValue, 'wifi5deviceschannel', {
			//caption:	L.tr('Channel'),
		//}).depends({'wificonfig':'1','wifi1enable':'1'})
		//.value('1', L.tr('0'))
		//.value('36', L.tr('36'))
		//.value('40', L.tr('40'))
		//.value('44', L.tr('44'))
		//.value('48', L.tr('48'))
		//.value('52', L.tr('52'))
		//.value('56', L.tr('56'))
		//.value('60', L.tr('60'))
		//.value('64', L.tr('64'))
		//.value('100', L.tr('100'))
		//.value('104', L.tr('104'))
		//.value('108', L.tr('108'))
		//.value('112', L.tr('112'))
		//.value('116', L.tr('116'))
		//.value('132', L.tr('132'))
		//.value('136', L.tr('136'))
		//.value('140', L.tr('140'))
		//.value('149', L.tr('149'))
		//.value('153', L.tr('153'))
		//.value('157', L.tr('157'))
		//.value('161', L.tr('161'))
		//.value('165', L.tr('165'))
		//.value('auto', L.tr('auto'));
   		
	//s.taboption('wificonfig', L.cbi.ListValue, 'wifi5channelwidth', {
	//caption:	L.tr('Channel BandWidth'),
	//}).depends({'wificonfig':'1','wifi1enable':'1'})
	//.value('0', L.tr('disable'))
	//.value('VHT20', L.tr('20 MHz'))
	//.value('VHT40', L.tr('20/40MHz'))
	//.value('VHT80', L.tr('80 MHz'));     
	
	  //s.taboption('wificonfig', L.cbi.InputValue, 'wifi5TxPower', {
	//caption:	L.tr('TX Power'),
	//}).depends({'wificonfig':'1','wifi1enable':'1'})

			//s.taboption('wificonfig', L.cbi.InputValue, 'wifi5ssid', {
		//caption:	'Radio SSID'
	//}).depends({'wificonfig':'1','wifi1enable':'1'});
	  
	//s.taboption('wificonfig', L.cbi.PasswordValue, 'wifi5key', {
		//caption:	L.tr('Radio Passphrase'),
		//datatype:'rangelength(8,11)',
		//optional:	true	
	//}).depends({'wificonfig':'1','wifi1enable':'1'})
	
	        //s.taboption('wificonfig', L.cbi.ListValue, 'Wifi5Mode', {
			//caption:	L.tr('Radio Mode'),
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'})
		//.value('ap', L.tr('Access Point'));
	////	.value('sta', L.tr('Client only'))
	////	.value('apsta', L.tr('Access Point and Client'));
		
		//s.taboption('wificonfig', L.cbi.ListValue, 'wifi5encryption', {
			//caption:	L.tr('Radio Encryption'),
			//initial:	'none'
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'})
		//.value('none', L.tr('NONE'))
		//.value('psk2', L.tr('WPA Personal (PSK)'))
		//.value('psk2+aes', L.tr('WPA Personal (PSK) + AES'))
		//.value('psk2+ccmp', L.tr('WPA Personal (PSK) + CCMP'))
		//.value('psk+tkip+ccmp', L.tr('WPA Personal (PSK)+TKIP+CCMP'))
		//.value('psk+tkip+aes', L.tr('WPA Personal (PSK)+TKIP+AES'));
		
		 //s.taboption('wificonfig',L.cbi.InputValue, 'wifi5radio0dhcpip', {
           //caption: L.tr('Radio DHCP Server IP'), 
           //datatype: 'ip4addr',
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'})        
                
        //s.taboption('wificonfig',L.cbi.InputValue, 'wifi5Radio0DHCPrange', {
           //caption: L.tr('Radio DHCP Start Address'), 
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'})
		        
        //s.taboption('wificonfig',L.cbi.InputValue, 'wifi5Radio0DHCPlimit', {
           //caption: L.tr('Radio DHCP Limit'), 
		//}).depends({'wificonfig':'1','wifi1enable':'1','wifi51enable':'1'}) 

////Guest Wifi 2.4/5Ghz
        //s.tab({
            //id: 'guest',
            //caption: L.tr('Guest WIFI 2.4Ghz/5Ghz  ')
        //});
		////Guest WIFI 2.4Ghz
		   //s.taboption('guest',L.cbi.DummyValue, 'generalsettings', {
		  //caption: L.tr(''),
        //})
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspGuest WIFI 2.4Ghz </b> </h3>";
            //return id;
          //}; 
               
         //s.taboption('guest',L.cbi.CheckboxValue, 'guestwifienable2', {
			//caption:	L.tr('Enable 2.4Ghz Guest Wifi')
		//}).depends({'guest':'1'});
		  		
      
         //s.taboption('guest', L.cbi.InputValue, 'guestwifissid2', {
			//caption:	'SSID'
		//}).depends({'guest':'1','guestwifienable2':'1'});
		
		//s.taboption('guest', L.cbi.PasswordValue, 'guestwifikey2', {
			//caption:	L.tr('Passphrase'),
			//datatype:'rangelength(8,11)',
			//optional:	true
		//}).depends({'guest':'1','guestwifienable2':'1'});
		
       //s.taboption('guest',L.cbi.InputValue, 'guestradio0dhcpip2', {
           //caption: L.tr('Radio DHCP Server IP'), 
           //datatype: 'ip4addr',
		//}).depends({'guest':'1','guestwifienable2':'1'});
		////Guest WIFI 5Ghz
		   //s.taboption('guest',L.cbi.DummyValue, 'generalsettings', {
		  //caption: L.tr(''),
        //})
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspGuest WIFI 5Ghz </b> </h3>";
            //return id;
          //}; 
                        
         //s.taboption('guest',L.cbi.CheckboxValue, 'guestwifienable5', {
			//caption:	L.tr('Enable 5Ghz Guest Wifi')
		//}).depends({'guest':'1'});
		  		
      
         //s.taboption('guest', L.cbi.InputValue, 'guestwifissid5', {
			//caption:	'SSID'
		//}).depends({'guest':'1','guestwifienable5':'1'});
		
		//s.taboption('guest', L.cbi.PasswordValue, 'guestwifikey5', {
			//caption:	L.tr('Passphrase'),
			//datatype:'rangelength(8,11)',
			//optional:	true
		//}).depends({'guest':'1','guestwifienable5':'1'});
		
        //s.taboption('guest',L.cbi.InputValue, 'guestradio0dhcpip5', {
           //caption: L.tr('Radio DHCP Server IP'), 
           //datatype: 'ip4addr',
		//}).depends({'guest':'1','guestwifienable5':'1'});
		
		
		
      ////Wireless Schedule
        //s.tab({
            //id: 'wificonfigschedule',
            //caption: L.tr('Wireless Schedule')
        //});
		
		   //s.taboption('wificonfigschedule',L.cbi.DummyValue, 'generalsettings', {
		  //caption: L.tr(''),
        //}).depends({'wificonfig':'1'})
        //.depends({'wifi1enable':'1' })
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspWifi Schedule ON/OFF settings </b> </h3>";
            //return id;
          //}; 
		
		//s.taboption('wificonfigschedule',L.cbi.DummyValue, 'generalsettings', {
		  //caption: L.tr(''),
        //}).depends({'wificonfig':'1','wifi1enable':'0' })
        //.ucivalue=function()
          //{
            //var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspPlease Enable wifi to configure Schedule ON/OFF settings</b> </h3>";
            //return id;
          //}; 
		
		 //s.taboption('wificonfigschedule', L.cbi.CheckboxValue, 'ScheduledOnOff', {
			//caption:	L.tr('Scheduled Wifi On/Off'),
		//}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1'});
		
        //s.taboption('wificonfigschedule', L.cbi.DynamicList, 'DayOfWeek', {
            //caption: L.tr('Day Of Week'),
            //optional: true,
            //listlimit: 12,
            //listcustom:false
        //}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        //.value('*', L.tr('All'))
        //.value('0', L.tr('Sunday'))
        //.value('1', L.tr('Monday'))
        //.value('2', L.tr('Tuesday'))
        //.value('3', L.tr('Wednesday'))
        //.value('4', L.tr('Thursday'))
        //.value('5', L.tr('Friday'))
        //.value('6', L.tr('Saturday'));
        		
		
		//s.taboption('wificonfigschedule',L.cbi.DummyValue, 'from', {
		  //caption: L.tr(''),
        //}).depends({'wificonfig':'1','wifi1enable':'1' ,'wificonfigschedule':'1'})
        //.ucivalue=function()
          //{
            //var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp From: </b> </h5>";
            //return id;
          //}; 
		
		
		
		//var fromHourVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'fromHours', {
            //caption: L.tr('Hours'),
            //optional: true,
            //listlimit: 24,
            //listcustom:false,
        //}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        //.value('',L.tr('-- Please choose --'))
        //.value('*', L.tr('All'));

        //fromHourVal.load = function(sid) {
            //var hours = [ ];
            //for (var i = 0; i < 24; i++)
                //hours.push(i);
            //hours.sort();
            //for (var i = 0; i < hours.length; i++)
                //fromHourVal.value(i);
        //};
		
		
		//var fromMinuteVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'fromMinutes', {
            //caption: L.tr('Minutes'),
            //optional: true,
            //listlimit: 60,
            //listcustom: false
        //}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        //.value('',L.tr('-- Please choose --'))
        //.value('*', L.tr('All'));

        //fromMinuteVal.load = function(sid) {
            //var minutes = [ ];
            //for (var i = 0; i < 60; i++)
                //minutes.push(i);
            //minutes.sort();
            //for (var i = 0; i < minutes.length; i++)
                //fromMinuteVal.value(i);
        //};

        
        //s.taboption('wificonfigschedule',L.cbi.DummyValue, 'to', {
		  //caption: L.tr(''),
        //}).depends({'wificonfig':'1'})
        //.depends({'wifi1enable':'1' })
        //.ucivalue=function()
          //{
            //var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp To: </b> </h5>";
            //return id;
          //}; 
        
        //var HourVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'toHours', {
            //caption: L.tr('Hours'),
            //optional: true,
            //listlimit: 24,
            //listcustom:false,
        //}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        //.value('',L.tr('-- Please choose --'))
        //.value('*', L.tr('All'));

        //HourVal.load = function(sid) {
            //var hours = [ ];
            //for (var i = 0; i < 24; i++)
                //hours.push(i);
            //hours.sort();
            //for (var i = 0; i < hours.length; i++)
                //HourVal.value(i);
        //};
		
		
		//var MinuteVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'toMinutes', {
            //caption: L.tr('Minutes'),
            //optional: true,
            //listlimit: 60,
            //listcustom: false
        //}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        //.value('',L.tr('-- Please choose --'))
        //.value('*', L.tr('All'));

        //MinuteVal.load = function(sid) {
            //var minutes = [ ];
            //for (var i = 0; i < 60; i++)
                //minutes.push(i);
            //minutes.sort();
            //for (var i = 0; i < minutes.length; i++)
                //MinuteVal.value(i);
        //};
//==============================SMS Settings============================
        //s.tab({
            //id: 'smsconfig',
            //caption: L.tr('SMS Settings')
        //});
        
		//s.taboption('smsconfig',L.cbi.CheckboxValue, 'smsenable1', {
                       //caption: L.tr('SMS Enable'),
                       //optional: true
                //}).depends('smsconfig');
          
		//s.taboption('smsconfig',L.cbi.InputValue, 'smscenternumber1', {
                        //caption: L.tr('SMS center number for Sim1'),
                        //datatype: 'uinteger',
                        //description: L.tr('SMS center number in international format without the leading +')
                //}).depends(['modemenable','smsenable1']);
        
        //s.taboption('smsconfig',L.cbi.InputValue, 'smscenternumber2', {
                        //caption: L.tr('SMS center number for Sim2'),
                        //datatype: 'uinteger',
                        //description: L.tr('SMS center number in international format without the leading +')
                //}).depends(['modemenable','smsenable1']);
        
		//s.taboption('smsconfig',L.cbi.DummyValue, 'smsdeviceid', {
        //caption: L.tr('Serial Number'),
        //}).depends(['modemenable','smsenable1']);
        
                //s.taboption('smsconfig',L.cbi.InputValue, 'smsapikey', {
                        //caption: L.tr('API Key'),
                        //description: L.tr('API key used for sms communication')
                //}).depends(['modemenable','smsenable1']);
                
                //s.taboption('smsconfig',L.cbi.ListValue, 'validsmsreceivernumbers', {
                        //caption: L.tr('Select Valid SMS user Numbers')
                //}).depends({'modemenable':'1','smsenable1':'1'})
	              //.value("0",L.tr("Please select the option"))
	              //.value("1",L.tr("1"))
	              //.value("2",L.tr("2"))
			      //.value("3",L.tr("3"))
	              //.value("4",L.tr("4"))
	              //.value("5",L.tr("5"));       

                //s.taboption('smsconfig',L.cbi.InputValue, 'smsservernumber1', {
                        //caption: L.tr('Valid SMS User Number1'),
		                ////optional: true,
		                //description:L.tr('phone number in international format without the leading +'),
                //}).depends({'validsmsreceivernumbers':'1','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'2','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

	            //s.taboption('smsconfig',L.cbi.InputValue, 'smsservernumber2', {                                       
                        //caption: L.tr('Valid SMS User Number2'),                                                           
                        ////optional: true,                                                                             
                //}).depends({'validsmsreceivernumbers':'2','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

	            //s.taboption('smsconfig',L.cbi.InputValue, 'smsservernumber3', {           
                        //caption: L.tr('Valid SMS User Number3'),
                       //// optional: true                                     
                //}).depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

                //s.taboption('smsconfig',L.cbi.InputValue, 'smsservernumber4',{
                        //caption: L.tr('Valid SMS User Number4'),
                        ////optional: true
                //}).depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  //.depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'});       

                //s.taboption('smsconfig',L.cbi.InputValue, 'smsservernumber5',{   
                        //caption: L.tr('Valid SMS User Number5'),    
                        ////optional: true                                       
                //}).depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'});
                
                 //s.taboption('smsconfig',L.cbi.CheckboxValue, 'smsresponseserverenable', {
                       //caption: L.tr('SMS Response Enable'),
                      //// optional: true
                //}).depends({'smsenable1':'1'});
            
        s.tab({
            id: 'loopbackipconfig',
            caption: L.tr('Loopback IP Settings')
        });
        
           s.taboption('loopbackipconfig',L.cbi.InputValue, 'loopbackip', {
           caption: L.tr('Loopback IP'), 
           datatype: 'ip4addr',
           placeholder:'8.8.8.8',
           optional: true
        }).depends({'loopbackipconfig':'1'}); 
        
        s.taboption('loopbackipconfig',L.cbi.InputValue, 'loopbacknetmask', {
           caption: L.tr('Loopback NetMask'),
           placeholder:'8.8.8.8', 
           datatype: 'ip4addr',
           optional: true
        }).depends({'loopbackipconfig':'1'});
        
   		
		s.tab({
		id: 'flowoffloading',
		caption: L.tr('Flow Offloading')
		});
		
		s.taboption('flowoffloading',L.cbi.CheckboxValue, 'enableflowoffloading', {
		caption: L.tr('Enable Flow Offloading'), 
		}).depends({'flowoffloading':'1'}); 
		
		s.taboption('flowoffloading',L.cbi.CheckboxValue, 'smpirqaffinity', {
		caption: L.tr('Smp IRQ Affinity'),
		}).depends({'loopbackipconfig':'1'});
         
         
        		
        s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
    }
});

