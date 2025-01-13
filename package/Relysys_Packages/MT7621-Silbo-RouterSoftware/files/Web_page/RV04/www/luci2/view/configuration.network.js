L.ui.view.extend({

    title: L.tr('Network Configuration'),
    description: L.tr('Please click on update after editing or deleting any changes.'),
    
     
     fGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: [ 'config', 'type' ],
		expect: { values: {} }
	}),
	
	fCreateUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'add',
		params: [ 'config', 'type', 'name', 'values' ]
	}),
	
	fDeleteUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'delete',
		params: [ 'config','type','section' ]
	}),
	
	fCommitUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'commit',
		params: [ 'config' ]
	}),
    
    deletefirewallconfig: L.rpc.declare({
        object: 'rpc-updatewanconfig',
        method: 'delete',
        params: [ 'SectionName' ],
        expect: { output: '' }
    }),
    
       updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-updatewanconfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
        }),

	
	fCreateForm: function(mapwidget, fSectionID, fSectionType, fInterfaceName)
	{
		var self = this;
		
		if (!mapwidget)
			mapwidget = L.cbi.Map;
		
		if(fSectionType == "Dredirect") {
			var FormContent = self.pbCreateFormCallback;
		}
		
		var map = new mapwidget('networkinterfaces', {
			prepare:    FormContent,
			fSection:   fSectionID,
			fInterfaceName: fInterfaceName
		});
		return map;
	},
	
	fSectionEdit: function(ev) {
		var self = ev.data.self;
		var fSectionID = ev.data.fSectionID;
		var fSectionType = ev.data.fSectionType;
		var fInterfaceName = ev.data.interfaceName;
		
		return self.fCreateForm(L.cbi.Modal, fSectionID, fSectionType, fInterfaceName).show();
		
	},
	
	pbCreateFormCallback: function()
	{
		var map = this;
		var pbSectionID = map.options.fSection;
		var fInterfaceName = map.options.fInterfaceName;
		
		map.options.caption = L.tr('Network Interfaces');
		
		var s = map.section(L.cbi.NamedSection, pbSectionID, {
			collabsible: true,
			anonymous:   true,
			 tabbed:      true
		});
		
	s.option(L.cbi.InputValue, 'ifname', {
			caption:     L.tr('Physical device'),
			optional:      'true'
		});
		
	s.option(L.cbi.ListValue, 'type', {
			caption:     L.tr('Type'),
		}).value("LAN",L.tr("LAN"))
	      .value("WAN",L.tr("WAN"));	
		
       s.option(L.cbi.ListValue,'protocol_lan',{          
                 caption:L.tr('Protocol'), 
		}).depends({'type':'LAN'})   
		.value("static_lan", L.tr('Static'));
            
       s.option(L.cbi.ListValue,'protocol',{          
                 caption:L.tr('Protocol'), 
		}).depends({'type':'WAN'}) 
		  .value("static", L.tr('Static'))
          .value("dhcpclient", L.tr('DHCP'))
          .value("pppoe",L.tr("PPPoE"));
         
       s.option(L.cbi.InputValue, 'staticIP', {
           caption: L.tr('IP Address'), 
           datatype: 'ip4addr',
           optional: true
        }).depends({'type':'LAN','protocol_lan':'static_lan'})
        .depends({'type':'WAN','protocol':'static'});
          
        s.option(L.cbi.InputValue, 'staticnetmask', {
           caption: L.tr('Static Netmask'), 
           datatype: 'ip4addr',
           optional: true
        }).depends({'type':'LAN','protocol_lan':'static_lan'})
        .depends({'type':'WAN','protocol':'static'});
        
        s.option(L.cbi.InputValue, 'staticgateway', {
           caption: L.tr('Static Gateway'), 
           datatype: 'ip4addr',
           optional: true
        }).depends({'type':'LAN','protocol_lan':'static_lan'})
        .depends({'type':'WAN','protocol':'static'});
      
      s.option(L.cbi.InputValue, 'dhcpgateway', {
           caption: L.tr('DHCP Gateway'), 
           datatype: 'ip4addr',
           optional: true
        }).depends({'type':'WAN','protocol':'dhcpclient'}); 
          
   		   s.option(L.cbi.DummyValue, 'macaddr', {
           caption: L.tr('Mac Address')
        });
        
   		   s.option(L.cbi.InputValue, 'macaddress', {
           caption: L.tr('Override Mac Address'), 
           datatype: 'macaddr',
           optional: true
        });
        
         s.option(L.cbi.CheckboxValue, 'enable_dns', {
           caption: L.tr('Enable DNS'),
         }).depends({'protocol_lan':'static_lan','type':'LAN'});
        
		  
		 s.option(L.cbi.DynamicList, 'ServerStaticDnsServer', {
		   caption:     L.tr('DNS Server Address'),
		   placeholder:'8.8.8.8',
		   optional:     true
		 }).depends({'enable_dns':'1','protocol_lan':'static_lan','type':'LAN'});
		 
        
        s.option(L.cbi.InputValue, 'EthernetClientPppoeUsername', {
           caption: L.tr('Username'), 
        }).depends({'type':'WAN','protocol':'pppoe'});   
        
        s.option(L.cbi.InputValue, 'EthernetClientPppoePassword', {
           caption: L.tr('Password'), 
        }).depends({'type':'WAN','protocol':'pppoe'});  
        
        s.option(L.cbi.InputValue, 'EthernetClientPppoeAccessConcentrator', {
           caption: L.tr('Access Concentrator'), 
        }).depends({'type':'WAN','protocol':'pppoe'});  
        
         s.option(L.cbi.InputValue, 'EthernetClientPppoeServiceName', {
           caption: L.tr('Service Name'), 
        }).depends({'type':'WAN','protocol':'pppoe'}); 
        
         s.option(L.cbi.InputValue, 'pppoegateway', {
           caption: L.tr('Gateway'), 
        }).depends({'type':'WAN','protocol':'pppoe'}); 

         s.option(L.cbi.CheckboxValue, 'enable_dhcpserver', {
           caption: L.tr('Enable DHCP Server'),
        }).depends({'protocol_lan':'static_lan','type':'LAN'});
        
        s.option(L.cbi.InputValue, 'ServerDHCPrange', {
           caption: L.tr('DHCP Start Address'), 
           optional: true
        }).depends({'protocol_lan':'static_lan','type':'LAN','enable_dhcpserver':'1'});
        
          s.option(L.cbi.InputValue, 'ServerDHCPlimit', {
           caption: L.tr('DHCP Limit'),
           optional: true 
        }).depends({'protocol_lan':'static_lan','type':'LAN','enable_dhcpserver':'1'});
                
        s.option(L.cbi.InputValue, 'leasetime', {
           caption: L.tr('Lease time'), 
             placeholder:'12h',
           optional: true
        }).depends({'protocol_lan':'static_lan','type':'LAN','enable_dhcpserver':'1'});
          
        s.option(L.cbi.CheckboxValue, 'enable_zoneforward', {
           caption: L.tr('Create Firewall Zone'),
        });
        
         s.option(L.cbi.CheckboxValue, 'internetoverinterface', {
           caption: 'Internet Over ' + fInterfaceName,
        }).depends({'type':'LAN'}); 

        s.option(L.cbi.CheckboxValue, 'advanced_settings', {
           caption: L.tr('Advanced Settings'),
        }); 
       
        //s.option(L.cbi.InputValue, 'gatewaymetric', {
           //caption: L.tr('Gateway Metric'), 
           //optional: true
        //}).depends({'advanced_settings':'1'});
        
        s.option(L.cbi.InputValue, 'broadcast', {
           caption: L.tr('Broadcast'), 
           datatype: 'ip4addr',
           optional: true
        }).depends({'advanced_settings':'1'});
        
         s.option(L.cbi.InputValue, 'mtu', {
           caption: L.tr('Override MTU'),
           placeholder:'1500', 
           optional: true
        }).depends({'advanced_settings':'1'});
		 
        
        s.option(L.cbi.CheckboxValue, 'delegate', {
           caption: L.tr('Delegate'),
        }).depends({'advanced_settings':'1'});
        
        s.option(L.cbi.CheckboxValue, 'force_link', {
           caption: L.tr('Force Link'),
        }).depends({'advanced_settings':'1'});
        
        //s.option(L.cbi.CheckboxValue, 'enable_bridge', {
           //caption: L.tr('Enable Bridge'),
        //}).depends({'advanced_settings':'1'});
        
         //s.option(L.cbi.NetworkList, 'bridge_interfaces', {
           //caption: L.tr('Interfaces'), 
           //multiple: true,
            //customInput: true,
            //labelName: 'device',
           //optional: true
        //}).depends({'advanced_settings':'1','enable_bridge':'1'});
        
     s.option(L.cbi.DummyValue, 'mwan3', {
    caption: L.tr('')
    })
    .ucivalue = function() {
    var noteText = "<b>Note:if required, add an interface in Internet page under Settings</b>";
    return noteText;
    };
 },  
	
		
	pbRenderContents: function(rv)
	{
		var self = this;

		var list = new L.ui.table({
			columns: [ 
			{ 
				caption: L.tr('Interface Name'),
				format:  function(v,n) {
					var div = $('<small />').attr('id', 'pbinterface_%s'.format(n));
					return div.append(v);
				}
		    },{ 
				caption: L.tr('Physical Device'),
				format:  function(v,n) {
					var div = $('<small />').attr('id', 'pbphysicaldevice_%s'.format(n));
					return div.append(v);
				}
		    },{ 
				caption: L.tr('Mac Address'),
				format:  function(v,n) {
					var div = $('<small />').attr('id', 'pbphysicaldevice_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('Type'),
				format:  function(v,n) {
					var div = $('<small />').attr('id', 'pbtype_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Actions'),
				format:  function(v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Port Forward'))
							.click({ self: self, fSectionID: v, fSectionType: "Dredirect" ,interfaceName: rv[v].interface}, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Port Forward'))
							.click({ self: self, pbSectionID: v }, self.pbSectionRemove));
				}
			}]
		});
		
		for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
								var Interface = obj.interface
								var PhysicalDevice = obj.ifname
								var Type = obj.type
								var Macaddr = obj.macaddr
			                
                                 list.row([Interface,PhysicalDevice,Macaddr,Type,key]); 
                        }
                }
		
		$('#section_network_interface_port').append(list.render());		
	},


	pbSectionRemove: function(ev) {
		var self = ev.data.self;
		var pbSectionID = ev.data.pbSectionID;
		self.deletefirewallconfig(pbSectionID).then(function(rv) {
		self.fDeleteUCISection("networkinterfaces","redirect",pbSectionID).then(function(rv){
			if(rv == 0){
				self.fCommitUCISection("networkinterfaces").then(function(res){
						//if (res != 0){
					//		alert("Error: Delete Port Forward Configuration");
						//}
						//else {
							location.reload();
						//}
				});
			};
		});
	});	
		
	},
	
	pbSectionAdd: function () 
	{
		var self = this;
		var pbinterface = $('#field_netint_redirect_newRedirect_interfacename').val();		
		var pbphysicaldevice = $('#field_vlan_redirect_newRedirect_physicaldevice').val();
		var pbtype = $('#field_lan_wan_redirect_newRedirect_type').val();
		
		var SectionOptions = {interface:pbinterface,ifname:pbphysicaldevice,type:pbtype,enable_dns:"0",EthernetClientPptpMppeEncryption:"0",enable_dhcpserver:"0",enable_zoneforward:"0",internetoverinterface:"0"};
			self.fCreateUCISection("networkinterfaces","redirect",pbinterface,SectionOptions).then(function(rv){
			if(rv){
				if (rv.section){
					self.fCommitUCISection("networkinterfaces").then(function(res){
						//if (res != 0) {
						//	alert("Error: New Port Forward Configuration");
					//	}
						//else {
							location.reload();
					//	}
					});
					
				};
			};
		});
		
	},
     
     
     
     
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        execute:function() {
			
	   
        $('#AddNewPortForward').click(function() {          
			self.pbSectionAdd();
		});
		        
        var self = this;
		this.fGetUCISections("networkinterfaces","redirect").then(function(rv) {
			self.pbRenderContents(rv);   
		});
		
		
		 $('#btn_update').click(function() {
                        L.ui.loading(true);
                        self.updateinterfaceconfig('Update','updateinterface').then(function(rv){
                            L.ui.loading(false);
                                L.ui.dialog(
                                    L.tr('Updated interface configuration'),[
                                        $('<pre />')
                                        .addClass('alert alert-success')
                                        .text(rv)
                                    ],
                                    { style: 'close'}
                                );
                                
                               });
                    });

	var self = this;  
    var m = new L.cbi.Map('sysconfig', {       
		
                });
  
    var s = m.section(L.cbi.NamedSection, 'sysconfig', {
        caption:L.tr(''),
    });
    
    
	s.option(L.cbi.CheckboxValue, 'enablecellular', {
	caption: L.tr('Cellular Enable'),
	optional: true
	}).depends({'cellularconfig' : '1'}); 

	s.option(L.cbi.ListValue, 'CellularOperationMode', {
	caption: L.tr('Cellular Operation Mode'),
	}).depends({'cellularconfig':'1','enablecellular':'1'})
	//.value("singlecellulardualsim",L.tr("Single Cellular With Dual SIM"))
	.value("dualcellularsinglesim",L.tr("Dual Cellular each With Single SIM"))
	.value("singlecellularsinglesim",L.tr("Single Cellular With Single SIM"));

	s.option(L.cbi.DummyValue, 'modem1', {
	caption: L.tr(''),
	}).depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularconfig':'1','enablecellular':'1'})
	.ucivalue=function()
	{
	var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 1 </b> </h3>";
	return id;
	};  
	//============================General settings ==============================================

	s.option(L.cbi.DummyValue, 'cellularmodem1', {
	caption: L.tr('Cellular Modem 1'),
	}).depends({'cellularconfig':'1'})
	// .depends({'enablecellular':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});

	s.option(L.cbi.CheckboxValue, 'dataenable', {
	caption: L.tr('Data Service 1'),
	optional: true
	}) .depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});  
	s.option(L.cbi.InputValue, 'apn', {
	caption: L.tr('SIM 1 Access Point Name')
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'}) ;

	s.option(L.cbi.ListValue, 'pdp', {
	caption: L.tr('SIM 1 PDP Type')
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.value('1', L.tr('IPV4'))                        
	.value('2', L.tr('IPV6'))                        
	.value('3', L.tr('IPV4V6')); 

	s.option(L.cbi.CheckboxValue, 'Enable464xlatSim1', {
	caption: L.tr('Enable 464xlat for Sim1')
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});

	s.option(L.cbi.InputValue, 'username', {
	caption: L.tr('SIM 1 Username'),
	optional: true 
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});

	s.option(L.cbi.PasswordValue,'password',{
	caption: L.tr('SIM 1 Password'),
	optional: true 
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});

	s.option(L.cbi.ListValue, 'auth', {
	caption: L.tr('SIM 1 Authentication Protocol'),
	}).depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.value('0', L.tr('None'))
	.value('1', L.tr('PAP'))
	.value('2', L.tr('CHAP')) 
	.value('3', L.tr('PAP/CHAP')); 

	s.option(L.cbi.DummyValue, 'modem2', {
	caption: L.tr(''),
	}).depends({'CellularOperationMode' : 'dualcellularsinglesim','cellularconfig':'1','enablecellular':'1'})
	.ucivalue=function()
	{
	var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 2 </b> </h3>";
	return id;
	}; 
	s.option(L.cbi.DummyValue, 'cellularmodem2', {
	caption: L.tr('Cellular Modem 2'),
	}).depends({'cellularconfig':'1'})
	// .depends({'enablecellular':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','enablecellular':'1'})

	//=========================== SIM 2 Settings ====================================

	s.option(L.cbi.CheckboxValue, 'dataenable2', {
	caption: L.tr('Data Service2'),
	optional: true
	}) .depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','enablecellular':'1'});  


	s.option(L.cbi.InputValue, 'sim2apn', {
	caption: L.tr('SIM 2 Access Point Name')
	})
	//.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' :'dualcellularsinglesim','modemenable':'1','dataenable':'1'});
	.depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;

	s.option(L.cbi.ListValue, 'sim2pdp', {
	caption: L.tr('SIM 2 PDP Type')
	})
	.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' :'dualcellularsinglesim','modemenable':'1','dataenable':'1','enablecellular':'1'})
	.depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','enablecellular':'1'}) 
	.value('1', L.tr('IPV4'))                        
	.value('2', L.tr('IPV6'))                        
	.value('3', L.tr('IPV4V6')); 


	s.option(L.cbi.CheckboxValue, 'Enable464xlatSim2', {
	caption: L.tr('Enable 464xlat for Sim2')
	}).depends({'cellularconfig':'1'})
	// .depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable' : '1','enablecellular':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable' : '1','enablecellular':'1'});


	s.option(L.cbi.InputValue, 'sim2username', {
	caption: L.tr('SIM 2 Username'),
	optional: true 
	})
	.depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;

	s.option(L.cbi.PasswordValue,'sim2password',{
	caption: L.tr('SIM 2 Password'),
	optional: true 
	})
	.depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) ;

	s.option(L.cbi.ListValue, 'sim2auth', {
	caption: L.tr('SIM 2 Authentication Protocol'),
	})
	//.depends({'cellularconfig' : '1','CellularOperationMode' : 'singlecellulardualsim','CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable':'1'})
	.depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim','modemenable':'1','dataenable2' : '1','enablecellular':'1'})

	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable2' : '1','enablecellular':'1'}) 
	.value('0', L.tr('None'))
	.value('1', L.tr('PAP'))
	.value('2', L.tr('CHAP')) 
	.value('3', L.tr('PAP/CHAP')); 

	s.option(L.cbi.CheckboxValue, 'primarysimswitchbackenable', {
	caption: L.tr('Primary SIM Switchback Enable'),
	optional: true
	}) .depends({'cellularconfig':'1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','enablecellular':'1'});   


	s.option(L.cbi.InputValue, 'primarysimswitchbacktime', {
	caption: L.tr('Primary SIM Switchback Time (In Minutes)'),
	optional: true 
	})
	.depends({'cellularconfig' : '1'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim','modemenable':'1','dataenable':'1','primarysimswitchbackenable': '1','enablecellular':'1'});

   m.insertInto('#section_cellular');  
   
   var m = new L.cbi.Map('sysconfig', {
                });     
   
   var s = m.section(L.cbi.NamedSection, 'bandlock', {
        caption:L.tr('')
    });
    


//Modem1
          
        s.option(L.cbi.DummyValue, 'modem1', {
			caption: L.tr(''),
        }).depends({'band':'1'})
				.ucivalue=function()
					{
					var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 1 </b> </h3>";
					return id;
					};  
          
           s.option(L.cbi.DummyValue, 'cellularmodem1', {
           caption: L.tr('Module'),
        }).depends({'band':'1'});
        
          
			 s.option(L.cbi.ListValue, 'bandselectenable1', {         
                        caption: L.tr('Mode Selection'), 
                        optional: true                   
                }).depends({'band':'1'})                                
                .value('auto', L.tr('AUTOMATIC'))                             
                .value('lte', L.tr('LTE Only'))   
                .value('5g', L.tr('NR5G Only'))   
                .value('5g4g', L.tr('NR5G & LTE'));    
                     
			s.option(L.cbi.DynamicList, 'lte', {         
                        caption: L.tr('LTE Band Selection'), 
                        optional: true                   
                }).depends({'bandselectenable1' : 'lte'})
                .depends({'bandselectenable1' : '5g4g'})
                .value('all_lte_bands', L.tr('All LTE Bands'))                                                             
                .value('1', L.tr('LTE B1'))                             
                .value('3', L.tr('LTE B3'))   
                .value('5', L.tr('LTE B5'))   
                .value('8', L.tr('LTE B8')) 
                .value('34', L.tr('LTE B34')) 
                .value('38', L.tr('LTE B38')) 
                .value('39', L.tr('LTE B39')) 
                .value('40', L.tr('LTE B40')) 
                .value('41', L.tr('LTE B41')); 
            
             s.option(L.cbi.DynamicList, '5g', {         
                        caption: L.tr('NR5G Band Selection'), 
                        optional: true                   
                }).depends({'bandselectenable1' : '5g'})                                
                .depends({'bandselectenable1' : '5g4g'})                                
                .value('all_5g_bands', L.tr('All 5G Bands'))                             
                .value('1', L.tr('5G B1'))                             
                .value('2', L.tr('5G B2'))                             
                .value('3', L.tr('5G B3'))                             
                .value('5', L.tr('5G B5'))                             
                .value('7', L.tr('5G B7'))                             
                .value('8', L.tr('5G B8'))                             
                .value('12', L.tr('5G B12'))                             
                .value('20', L.tr('5G B20'))                             
                .value('25', L.tr('5G B25'))                             
                .value('28', L.tr('5G B28'))                             
                .value('38', L.tr('5G B38'))                             
                .value('40', L.tr('5G B40'))                             
                .value('41', L.tr('5G B41'))                             
                .value('48', L.tr('5G B48'))                                                          
                .value('66', L.tr('5G B66'))                             
                .value('71', L.tr('5G B71'))                             
                .value('77', L.tr('5G B77'))                             
                .value('78', L.tr('5G B78'))                             
                .value('79', L.tr('5G B79'))                             
                .value('257', L.tr('5G B257'))                             
                .value('258', L.tr('5G B258'))                             
                .value('260', L.tr('5G B260'))                             
                .value('261', L.tr('5G B261'));     
                                                      
                   ////=================================Operator sections ==============================================================================         
       
       //For Modem1
			
          s.option(L.cbi.CheckboxValue, 'enableoperator1', {
                    caption: L.tr('Operator Select Enable'),
                    optional: true
                  }).depends({'band':'1'});
                         
         s.option(L.cbi.ListValue, 'selectionmode1', {         
                    caption: L.tr('Operator Selection Mode'), 
                    optional: true                   
                  }).depends({'enableoperator1':'1' ,'band':'1'})
                    
                    .value('auto', L.tr('AUTOMATIC'))
                    .value('manual', L.tr('MANUAL'))                              
                    .value('manual-auto', L.tr('MANUAL-AUTOMATIC')); 
                
        s.option(L.cbi.InputValue, 'Code1', {
                    caption: L.tr('Operator Code'),
                    optional: true 
                    }).depends({'enableoperator1':'1', 'selectionmode1' : 'manual'})
                      .depends({'enableoperator1':'1', 'selectionmode1' : 'manual-auto'});                                      
        //Modem2
       
                 s.option(L.cbi.DummyValue, 'modem2', {
			caption: L.tr(''),
        }).depends({'CellularOperationMode' : 'dualcellularsinglesim','band':'1'})
				.ucivalue=function()
					{
					var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem 2 </b> </h3>";
					return id;
					};  
          
       
		s.option(L.cbi.DummyValue, 'cellularmodem2', {
          caption: L.tr('Module'),
        }).depends({'CellularOperationMode' : 'dualcellularsinglesim','band':'1'});
          
         s.option(L.cbi.ListValue, 'bandselectenable2', {         
                        caption: L.tr('Mode Selection'), 
                        optional: true                   
                }).depends({'CellularOperationMode' : 'dualcellularsinglesim','band':'1'})                               
                .value('auto2', L.tr('AUTOMATIC'))                             
                .value('lte2', L.tr('LTE Only'));   
                
           s.option(L.cbi.DynamicList, '4g', {         
                        caption: L.tr('LTE Band Selection'), 
                        optional: true                   
                }).depends({'CellularOperationMode' : 'dualcellularsinglesim','bandselectenable2' : 'lte2'})                                
                .value('all_lte_bands', L.tr('All LTE Bands'))
                .value('1', L.tr('LTE B1'))
                .value('3', L.tr('LTE B3'))
                .value('5', L.tr('LTE B5'))
                .value('8', L.tr('LTE B8'))
                .value('34', L.tr('LTE B34'))
                .value('38', L.tr('LTE B38'))
                .value('39', L.tr('LTE B39'))
                .value('40', L.tr('LTE B40'))
                .value('41', L.tr('LTE B41'));
             
                ////=================================Operator sections ==============================================================================         
		
        //For Modem2 
        
        
         s.option(L.cbi.CheckboxValue, 'enableoperator2', {
                    caption: L.tr('Operator Select Enable'),
                    optional: true
                  }).depends({'CellularOperationMode' : 'dualcellularsinglesim','band':'1'});
                  
                   
        s.option(L.cbi.ListValue, 'selectionmode2', {         
                    caption: L.tr('Operator Selection Mode'), 
                    optional: true                   
                  }).depends({'enableoperator2':'1','band':'1'})
                    
                    .value('auto', L.tr('AUTOMATIC'))
                    .value('manual', L.tr('MANUAL'))                              
                    .value('manual-auto', L.tr('MANUAL-AUTOMATIC')); 
                
         s.option(L.cbi.InputValue, 'Code2', {
                    caption: L.tr('Operator Code'),
                    optional: true 
                    }).depends({'enableoperator2':'1', 'selectionmode2' : 'manual'})
                      .depends({'enableoperator2':'1', 'selectionmode2' : 'manual-auto'});

    
   m.insertInto('#section_bandop');  
   
    var m5 = new L.cbi.Map('sysconfig', {
                });     
   
   var s5 = m5.section(L.cbi.NamedSection, 'smsconfig', {
        caption:L.tr('')
    });
   
		s5.option(L.cbi.CheckboxValue, 'smsenable1', {
                       caption: L.tr('SMS Enable'),
                       optional: true
                }).depends('smsconfig');
          
		s5.option(L.cbi.InputValue, 'smscenternumber1', {
                        caption: L.tr('SMS center number for Sim1'),
                        datatype: 'uinteger',
                        description: L.tr('SMS center number in international format without the leading +')
                }).depends(['modemenable','smsenable1']);
        
        s5.option(L.cbi.InputValue, 'smscenternumber2', {
                        caption: L.tr('SMS center number for Sim2'),
                        datatype: 'uinteger',
                        description: L.tr('SMS center number in international format without the leading +')
                }).depends(['modemenable','smsenable1']);
        
		s5.option(L.cbi.DummyValue, 'smsdeviceid', {
        caption: L.tr('Serial Number'),
        }).depends(['modemenable','smsenable1']);
        
                s5.option(L.cbi.InputValue, 'smsapikey', {
                        caption: L.tr('API Key'),
                        description: L.tr('API key used for sms communication')
                }).depends(['modemenable','smsenable1']);
                
                s5.option(L.cbi.ListValue, 'validsmsreceivernumbers', {
                        caption: L.tr('Select Valid SMS user Numbers')
                }).depends({'modemenable':'1','smsenable1':'1'})
	              .value("0",L.tr("Please select the option"))
	              .value("1",L.tr("1"))
	              .value("2",L.tr("2"))
			      .value("3",L.tr("3"))
	              .value("4",L.tr("4"))
	              .value("5",L.tr("5"));       

                s5.option(L.cbi.InputValue, 'smsservernumber1', {
                        caption: L.tr('Valid SMS User Number1'),
		                //optional: true,
		                description:L.tr('phone number in international format without the leading +'),
                }).depends({'validsmsreceivernumbers':'1','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'2','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

	            s5.option(L.cbi.InputValue, 'smsservernumber2', {                                       
                        caption: L.tr('Valid SMS User Number2'),                                                           
                        //optional: true,                                                                             
                }).depends({'validsmsreceivernumbers':'2','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

	            s5.option(L.cbi.InputValue, 'smsservernumber3', {           
                        caption: L.tr('Valid SMS User Number3'),
                       // optional: true                                     
                }).depends({'validsmsreceivernumbers':'3','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'}); 

                s5.option(L.cbi.InputValue, 'smsservernumber4',{
                        caption: L.tr('Valid SMS User Number4'),
                        //optional: true
                }).depends({'validsmsreceivernumbers':'4','modemenable':'1','smsenable1':'1'})
                  .depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'});       

                s5.option(L.cbi.InputValue, 'smsservernumber5',{   
                        caption: L.tr('Valid SMS User Number5'),    
                        //optional: true                                       
                }).depends({'validsmsreceivernumbers':'5','modemenable':'1','smsenable1':'1'});
                
                 s5.option(L.cbi.CheckboxValue, 'smsresponseserverenable', {
                       caption: L.tr('SMS Response Enable'),
                      // optional: true
                }).depends({'smsenable1':'1'});
            

   m5.insertInto('#section_sms');
   
     
   
   var m6 = new L.cbi.Map('sysconfig', {
                });     
   
   var s6 = m6.section(L.cbi.NamedSection, 'loopbackip', {
        caption:L.tr('')
    });

          s6.option(L.cbi.InputValue, 'loopbackip', {
           caption: L.tr('Loopback IP'), 
           datatype: 'ip4addr',
           placeholder:'8.8.8.8',
           optional: true
        }).depends({'loopbackipconfig':'1'}); 
        
       s6.option(L.cbi.InputValue, 'loopbacknetmask', {
           caption: L.tr('Loopback NetMask'),
           placeholder:'8.8.8.8', 
           datatype: 'ip4addr',
           optional: true
        }).depends({'loopbackipconfig':'1'});
   		   		
   m6.insertInto('#section_loopback'); 
   
     var m7 = new L.cbi.Map('sysconfig', {
                });     
   
   var s7 = m7.section(L.cbi.NamedSection, 'offloading', {
        caption:L.tr('')
    });
		s7.option(L.cbi.CheckboxValue, 'enableflowoffloading', {
		caption: L.tr('Enable Flow Offloading'), 
		}).depends({'flowoffloading':'1'}); 
		
		s7.option(L.cbi.CheckboxValue, 'smpirqaffinity', {
		caption: L.tr('Smp IRQ Affinity'),
		}).depends({'loopbackipconfig':'1'});

       m7.insertInto('#section_offloading');  
     
  
    }
});
