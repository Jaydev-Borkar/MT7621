L.ui.view.extend({
    title: L.tr('BGP'),
    description: L.tr(''),
    
    BGPGetUCISections: L.rpc.declare({
            object: 'uci',
            method: 'get',
            params: [ 'config', 'type'],
            expect: { values: {} }
    }),
    
    BGPCreateUCISection:  L.rpc.declare({
            object: 'uci',
            method: 'add',
            params: [ 'config', 'type', 'name', 'values' ]
    }),
    
    BGPCommitUCISection:  L.rpc.declare({
            object: 'uci',
            method: 'commit',
            params: [ 'config' ]
    }),
    
    BGPDeleteUCISection:  L.rpc.declare({
    object: 'uci',
    method: 'delete',
    params: [ 'config','type','section' ]
}),

    updategeneralconfig: L.rpc.declare({
        object: 'rpc-updatebgpconfig',
        method: 'configure',
        expect: { output: '' }
    }),
    
    
    updatebgpstatusconfig: L.rpc.declare({
        object: 'rpc-updatebgpstatus',
        method: 'configure',
        expect: { output: '' }
    }),


	//handleArchiveUpload : function() {
        //var self = this;  
        //L.ui.upload(
            //L.tr('File Upload'),
            //L.tr('Select the file and click on "%s" button to proceed.').format(L.tr('Apply')), {
				//filename: '/etc/frr/frr.conf',
			    //success: function(info) {
		          //self.handleArchiveVerify(info);
		        //}
			//}
	    //);
	//},
	
	//handleArchiveVerify : function(info)
	//{
		//var self = this;
              //var archive=$('[name=filename]').val();
        
       //// if((checksumval == info.checksum) &&(sizeval == info.size)) {
			//L.ui.loading(true);
            ////self.TestArchive(archive).then(function(TestArchiveOutput) {
				
				////self.updatenmsconfig('configure').then(function(rv) {
				               
                ////});
			    
		    	//L.ui.dialog(
						//L.tr('File'), [
						//$('<p />').text(L.tr('Success')),
						//$('<pre />')
						//.addClass('alert-success')
						//.text("file uploaded successfully")	
					//],{
							//style: 'close',
							
						//}
			    //);
				//L.ui.loading(false);   
		    ////});    
	//},

        
    PeerFormCallback: function() 
    {
        var map = this;
        var PeerConfigSectionName = map.options.PeerConfigSection;
        var numericExpression = /^[0-9]+$/;
            
        map.options.caption = L.tr(PeerConfigSectionName+' Configuration');
            
        var s = map.section(L.cbi.NamedSection, PeerConfigSectionName, {
                collabsible: true
        });
        
       //s.option(L.cbi.CheckboxValue, 'enabled', {
              //caption:        L.tr('Enable'),         
              //optional:    true
            //});                                 
      
       s.option(L.cbi.InputValue, 'name', {
       caption: L.tr('Name'),
       });
     
       
       s.option(L.cbi.InputValue, 'as', {
       caption: L.tr('AS'),
     });
           
       s.option(L.cbi.InputValue, 'ipaddr', {
       caption: L.tr('IP Address'),
       placeholder: "10.1.1.10",
       });  
       
        
       s.option(L.cbi.InputValue, 'update_source', {
           caption: L.tr('Update Source'),
           placeholder: "Name of the loopback interface",
            optional:    true
        });
        
         s.option(L.cbi.InputValue, 'egbp_multihop', {
           caption: L.tr('EGBP MultiHop'),
            optional:    true
        }); 
        
       
       //s.option(L.cbi.DynamicList, 'ipaddr', {
       //caption:     L.tr('IP Address'),		         
	   //datatype:    'ipaddr',
	   //optional:     true
	  //}).value("none", "None"); 
       
       
        
       s.option(L.cbi.InputValue, 'password', {
       caption: L.tr('Password'),
       optional:    true
       }); 
   
       s.option(L.cbi.InputValue, 'weight', {
       caption: L.tr('Weight'),
       optional:    true
       });
       
      
        
        s.option(L.cbi.CheckboxValue, 'default_originate', {
              caption:        L.tr('Default Originate'),   
              optional: true      
            });   
        
         s.option(L.cbi.CheckboxValue, 'next_hop_self', {
              caption:        L.tr('Next Hop Self'),   
              optional: true      
            });   
        
       s.option(L.cbi.CheckboxValue, 'soft_reconfiguration', {
              caption:        L.tr('Inbound Soft Reconfiguration'),    
              optional: true          
       });
       
       s.option(L.cbi.InputValue, 'hold_time', {
           caption: L.tr('Hold Time'),
           placeholder: "In seconds",
           description: "Both the Hold Time and Keepalive time should either be filled or left empty.",
            optional:    true
        });   
     
         s.option(L.cbi.InputValue, 'keepalive_time', {
           caption: L.tr('Keepalive Time'),
            placeholder: "In seconds",
            optional:    true
        });  
        
        
        s.option(L.cbi.InputValue, 'connect_retry_time', {
           caption: L.tr('Connect Retry Time'),
            placeholder: "In seconds",
            optional:    true
        });   
        //s.option(L.cbi.InputValue, 'egbp_multihop', {
           //caption: L.tr('EGBP Hop'),
            //optional:    true
        //}); 
        
        //s.option(L.cbi.InputValue, 'keepalive_timer', {
           //caption: L.tr('Keepalive Timer'),
           //placeholder: "0-65535",
            //optional:    true
        //}); 
        
        //s.option(L.cbi.InputValue, 'hold_time', {
           //caption: L.tr('Hold Time'),
           //placeholder: "0-65535",
            //optional:    true
        //});
        
        //s.option(L.cbi.InputValue, 'connect_timer', {
           //caption: L.tr('Connect Timer'),
           //placeholder: "1-65535",
            //optional:    true
        //});   
        
                       
 },

                       
    PeerGroupFormCallback: function() 
    {
            var map = this;
            var PeerGroupConfigSectionName = map.options.PeerGroupConfigSection;
            var numericExpression = /^[0-9]+$/;
          
            map.options.caption = L.tr(PeerGroupConfigSectionName+' Configuration');
            
            var s1 = map.section(L.cbi.NamedSection, PeerGroupConfigSectionName, {
                    collabsible: true
            });
         
      
       s1.option(L.cbi.InputValue, 'name', {
       caption: L.tr('Name'),
       });
   
       s1.option(L.cbi.InputValue, 'as', {
       caption: L.tr('AS'),
       optional: true
       });
       
       s1.option(L.cbi.DynamicList, 'ipaddr', {
       caption:     L.tr('Neighbor Address'),		         
	   //placeholder: "10.1.1.10",
	   optional:     true
	  }).value("none", "None"); 
       
       s1.option(L.cbi.InputValue, 'password', {
       caption: L.tr('Password'),
       optional:    true
       }); 
   
       s1.option(L.cbi.InputValue, 'weight', {
       caption: L.tr('Weight'),
       optional:    true
       });
       
       s1.option(L.cbi.CheckboxValue, 'soft_reconfiguration', {
            caption:        L.tr('Inbound Soft Reconfiguration'),         
            optional: true
       });
       
       s1.option(L.cbi.InputValue, 'hold_time', {
           caption: L.tr('Hold Time'),
           placeholder: "In seconds",
           description: "Both the Hold Time and Keepalive time should either be filled or left empty.",
            optional:    true
        });   
       
         s1.option(L.cbi.InputValue, 'keepalive_time', {
           caption: L.tr('Keepalive Time'),
            placeholder: "In seconds",
            optional:    true
        });  
        
         s1.option(L.cbi.InputValue, 'connect_retry_time', {
           caption: L.tr('Connect Retry Time'),
            placeholder: "In seconds",
            optional:    true
        });   
},
  
    PeerConfigCreateForm: function(mapwidget,PeerConfigSectionName) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('bgpconfig', {
                    prepare: self.PeerFormCallback,
                    PeerConfigSection: PeerConfigSectionName
            });
            return map;
    },
  
    PeerGroupConfigCreateForm: function(mapwidget,PeerGroupConfigSectionName) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('bgpconfig', {
                    prepare: self.PeerGroupFormCallback,
                    PeerGroupConfigSection: PeerGroupConfigSectionName
            });
            return map;
    },
   
   
   ///////////////////////////////////////////////////////////////
   
   BGPStatusRenderContents: function (rv) {

                var self = this;

                var list = new L.ui.table({
                        columns: [
                        {
                               // caption: L.tr('BGP Neighbor'),
                                width: '14%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'BGPNeighbor_%s'.format(n));
                                        return div.append('<strong>' + v + '</strong>');
                                }
                        },
                        
                        {
                                //caption: L.tr('State'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'BGPTime_%s'.format(n));
                                       // return div.append('<strong>' + v + '</strong>');
                                       return div.append(v);
                                }
                        },
                        
                        {
                               // caption: L.tr('Local AS'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'BGPLocalAS_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        
                        {
                               // caption: L.tr('Uptime'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'BGPUptime_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        
                        
                        {
                               // caption: L.tr('Uptime'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'BGPConnectTime_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        
                        
                        ]
					});
					
					for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                var BGPNeighbor = obj.bgpneighbor;
                                var state = obj.state;
                                var remoteAS = obj.remoteAS;
                                var remoteID = obj.remote_id;
                                var LocalAS = obj.localAS;
                                var LocalHostID = obj.local_host;
                                var Prefixes = obj.accepted_prefixes;
                                var uptime = obj.uptime;
                                var txupdates = obj.txupdates;
                                var rxupdates = obj.rxupdates;
                                var TotalTx = obj.totaltx;
                                var TotalRx = obj.totalrx;
                                var BGPVersion = obj.bgpversion;
                                var HostName = obj.hostname;
                                var HoldTime = obj.hold_time;
                                var ConnectTime = obj.connect_timer;
                                var KeepaliveTime = obj.keepalive_time;
                                var KeepAliveTx = obj.keepalive_tx;
                                var KeepAliveTx = obj.keepalive_rx;
                                
            
            B = "<b>Host Name:</b>"+HostName + "<br />" +"<b>BGP State:</b>"+state + "<br />" + "<b>Uptime:</b>"+uptime + "<br />" +"<b>BGP Version:</b>"+BGPVersion;      
                       
                    
            //C = "<b>Local AS:</b>"+LocalAS + "<br />" +"<b>Local Host ID:</b>"+LocalHostID + "<br />" + "<b>Accepted Prefixes:</b>"+Prefixes;                 
            
           C = "<b>Local Router ID:</b>"+LocalHostID + "<br />" +"<b>Peer Router ID:</b>"+remoteID + "<br />" + "<b>Local AS:</b>"+LocalAS + "<br />" +"<b>Peer AS:</b>"+remoteAS;                 

           // D = "<b>Uptime:</b>"+uptime + "<br />" +"<b>Updates Tx/Rx:</b>"+txupdates +"/" +rxupdates + "<br />" + "<b>Total Tx/Rx:</b>"+TotalTx +"/" +TotalRx;    
             
            D = "<b>Accepted Prefixes:</b>"+Prefixes + "<br />" +"<b>Updates Tx/Rx:</b>"+txupdates +"/" +rxupdates + "<br />" + "<b>Total Tx/Rx:</b>"+TotalTx +"/" +TotalRx + "<br />" +"<b>Keepalives Tx/Rx:</b>"+KeepAliveTx +"/" +KeepAliveTx; 
             
            E = "<b>Hold Time:</b>"+HoldTime + "<br />" +"<b>Connect Retry Time:</b>"+ConnectTime + "<br />" + "<b>Keep Alive Time:</b>"+KeepaliveTime;
                          
                                list.row([BGPNeighbor,B,C,D,E]);
							}
						}
						$('#section_routing_status').append(list.render());				
            },
                        
   //////////////////////////////////////////////////////////////////
   
   
   
   
    PeerRenderContents: function(rv) 
    {         
		configdata1 = function () {
                        return rv;
                    }
		           
            var self = this;

            var list = new L.ui.table({
                    columns: [
                    { 
				caption: L.tr('Name'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'PeerName_%s'.format(n));
					return div.append(v);
				}
		    },
                    
            {            
            caption: L.tr('AS'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'PeerAS%s'.format(n));
					return div.append(v);
				}
		    },    
		    
		    {
		    caption: L.tr('IP Address'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'PeerIPAddress%s'.format(n));
					return div.append(v);
				}
		    },       
                    
                 
			        
			        {
                                caption: L.tr('Enable/Disable'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        //alert(v)
                                        console.log(this.Enabled)
                                        var div = $('<label />').attr('id', 'Peer_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v}   id="PeerstatusSwitch${n}" onclick="changestatuspeer(${n})">
  <span class="slider round"></span>`);
                                        
                                }
                        },
			        
                    
                    {
                            caption: L.tr('Update'),
                            align: 'left',
                            format: function(v, n) {
                                    return $('<div />')
                                            .addClass('btn-group btn-group-sm')
                                            .append(L.ui.button(L.tr('Edit'),'primary', L.tr('Configure'))
                                            .click({ self: self, PeerConfigSectionName: v }, self.PeerConfigSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, PeerConfigSectionName: v }, self.PeerConfigSectionRemove));
                                          
                            }
                    }]
            });

         for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                var Name = obj.name
						        var AS = obj.as
                                var IPAddress = obj.ipaddr
                                var Enabled = obj.enabled
						    
							 if (Enabled == "1") 
                              {
                                Enabled = "checked"
                              }

                              else 
                              {
                                Enabled = ""
                              }

                                
                                list.row([Name,AS,IPAddress,Enabled,key]); 
                        }
                }
               
          $('#section_routing_peers').append(list.render());	

    },
  
    PeerGroupRenderContents: function(rv) 
    {
		
		configdata = function () {
                        return rv;
                    }
                     
            var self = this;
            

              var list2 = new L.ui.table({
                    columns: [
                    {
                            caption: L.tr('Name'),
                                    width:'10%',
                            align: 'left',
                            format: function(v,n) {
                                    var div = $('<p />').attr('id', 'PeerGroupName_%s'.format(n));
                                    return div.append('<strong>'+v+'</strong>');
                            }
                    },
                    
                    //{ 
				       //caption: L.tr('AS'),
				       //format:  function(v,n) {
					   //var div = $('<p />').attr('id', 'PeerGroupAS_%s'.format(n));
					   //return div.append(v);
				       //}
			        //},
			        
			        {
                                caption: L.tr('Enable/Disable'),
                                width: '40%',
                                align: 'center',
                                format: function (v, n) {
                                        //alert(v)
                                        console.log(this.Enabled)
                                        var div = $('<label />').attr('id', 'PeerGroup_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v}   id="PeerGroupstatusSwitch${n}" onclick="changestatus(${n})">
  <span class="slider round"></span>`);
                                        
                                }
                        },
			        
			        
                    
                    
                    {
                            caption: L.tr('Update'),
                            align: 'left',
                            format: function(v, n) {
                                    return $('<div />')
                                            .addClass('btn-group btn-group-sm')
                                            .append(L.ui.button(L.tr('Edit'),'primary', L.tr('Configure'))
                                            .click({ self: self, PeerGroupConfigSectionName: v }, self.PeerGroupConfigSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, PeerGroupConfigSectionName: v }, self.PeerGroupConfigSectionRemove));
                                          
                            }
                    }]
            });

  for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                var Name = obj.name
						        //var AS = obj.as
                                var Enabled = obj.enabled
						    
							 if (Enabled == "1") 
                              {
                                Enabled = "checked"
                              }

                              else 
                              {
                                Enabled = ""
                              }

                                
                                //list2.row([Name,AS,Enabled,key]); 
                                  list2.row([Name,Enabled,key]); 
                        }
                }
      
 $('#section_routing_peergroups').append(list2.render());
      
    },
  
    PeerConfigSectionAdd: function () 
    {
        debugger
            var self = this;
 
 var PeerConfigSectionName = $('#field_NewEvent_name').val();
 var PeerAS = $('#field_NewEvent_As').val();
 var PeerIPAddress = $('#field_NewEvent_IPAddress').val();
 var PeerConfigSection= {name:PeerConfigSectionName,as:PeerAS,ipaddr:PeerIPAddress,enabled: "1"};

           this.BGPGetUCISections("bgpconfig","bgp_peer").then(function(rv) {
                    var keys = Object.keys(rv);
                    var keysLength=keys.length;
                  
                    if(keysLength>=15)
                    {
                            alert("Only 15 connections can be configured");
                    }
                    else
                    {
                        
                              self.BGPCreateUCISection("bgpconfig","bgp_peer",PeerConfigSectionName,PeerConfigSection).then(function(rv){
                                    if(rv)
                                    {
                                            if (rv.section)
                                            {
                                                    self.BGPCommitUCISection("bgpconfig").then(function(res){
                                                              
                            if (res != 0) 
                                                            {
                                alert("Error:New Event Configuration");
                                                            }
                                                            else 
                                                            {
                                                                    location.reload();
                                                            }
                                                    });
                                            };
                                    };
                            }); 
                    }
            });
    },
    
    
          PeerGroupConfigSectionAdd: function () 
        {
                    var self = this;

           var PeerGroupConfigSectionName = $('#field_NewEvent_name_group').val();
           //var PeerGroupAS = $('#field_NewEvent_As_group').val();
           //var  PeerGroupConfigSection= {name:PeerGroupConfigSectionName,as:PeerGroupAS,enabled: "1"};
            var  PeerGroupConfigSection= {name:PeerGroupConfigSectionName,enabled: "1"};
        
               this.BGPGetUCISections("bgpconfig","bgp_peer_group").then(function(rv) {
                        var keys = Object.keys(rv);
                        var keysLength=keys.length;
                     
                        if(keysLength>=15)
                        {
                                alert("Only 15 connections can be configured");
                        }
                        else
                        {
                            
                                  self.BGPCreateUCISection("bgpconfig","bgp_peer_group",PeerGroupConfigSectionName,PeerGroupConfigSection).then(function(rv){
                                        if(rv)
                                        {
                                                if (rv.section)
                                                {
                                                        self.BGPCommitUCISection("bgpconfig").then(function(res){
                                                              	
								if (res != 0) 
                                                                {
									alert("Error:New Event Configuration");
                                                                }
                                                                else 
                                                                {
                                                                        location.reload();
                                                                }
                                                        });
                                                };
                                        };
                                }); 
                        }
                });
        },
    
    PeerConfigSectionRemove: function(ev) 
    {
    var self = ev.data.self;
    var PeerConfigSectionName = ev.data.PeerConfigSectionName;
    self.BGPDeleteUCISection("bgpconfig","bgpconfig",PeerConfigSectionName).then(function(rv){
        if(rv == 0){
            self.BGPCommitUCISection("bgpconfig").then(function(res){
                if (res != 0)
                {
                    alert("Error: Delete Configuration");
                }
                else 
                                    {
                    location.reload();
                }
            });
        };
    });
},
    
     PeerGroupConfigSectionRemove: function(ev) 
    {
    var self = ev.data.self;
    var PeerGroupConfigSectionName = ev.data.PeerGroupConfigSectionName;
   
    self.BGPDeleteUCISection("bgpconfig","bgp_peer_group",PeerGroupConfigSectionName).then(function(rv){
        if(rv == 0){
            self.BGPCommitUCISection("bgpconfig").then(function(res){
                if (res != 0)
                {
                    alert("Error: Delete Configuration");
                }
                else 
                                    {
                    location.reload();
                }
            });
        };
    });
    
},


    
    PeerConfigSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var PeerConfigSectionName = ev.data.PeerConfigSectionName;
            return self.PeerConfigCreateForm(L.cbi.Modal,PeerConfigSectionName).show();
    },
 
          
        PeerGroupConfigSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var PeerGroupConfigSectionName = ev.data.PeerGroupConfigSectionName;
            return self.PeerGroupConfigCreateForm(L.cbi.Modal,PeerGroupConfigSectionName).show();
    },       
           
  
    execute:function()
    {
		
	
    var self = this;
          
    var m = new L.cbi.Map('bgpconfig', {       
		
                });
         
        
    var s = m.section(L.cbi.NamedSection, 'general', {
        caption:L.tr('General Configurations'),
    });
    
    
    s.option(L.cbi.CheckboxValue, 'enable_bgp', {
              caption:        L.tr('Enable BGP'),
              optional: true          
            });
     
    s.option(L.cbi.CheckboxValue, 'enabled_vty', {
              caption:        L.tr('Enable vty'),      
              optional: true   
            });
     
     s.option(L.cbi.InputValue, 'password', {
       caption: L.tr('Password'),
       optional:    true
       }).depends({'enabled_vty':'1'});      
       
      //s.option(L.cbi.CheckboxValue, 'upload_custom_file', {
              //caption:        L.tr('Upload Custom File'),    
              //optional: true     
            //});   
       
    //s.option(L.cbi.ButtonValue, 'upload', {
              //caption:        L.tr('Upload Configuration'),
              //label: 		  L.tr("Upload"),  
			  
            //}).on('click', function() {
				//self.handleArchiveUpload();        
            //}).depends({'upload_custom_file':'1'});
			 
			 
   m.insertInto('#section_routing_general');  
   
  
   var m1 = new L.cbi.Map('bgpconfig', {
                });     
   
   var s1 = m1.section(L.cbi.NamedSection, 'main_instance', {
        caption:L.tr('BGP Instance')
    });
    
    
    //s1.option(L.cbi.CheckboxValue, 'enable_instance', {
              //caption:        L.tr('Enable Instance'),         
              //optional:    true
            //});    
            
    s1.option(L.cbi.InputValue, 'as', {
       caption: L.tr('AS'),
       });
       
       
    s1.option(L.cbi.InputValue, 'router_id', {
       caption: L.tr('Router ID'),
       datatype: 'ip4addr',
       optional:    true
       });
       
    //s1.option(L.cbi.CheckboxValue, 'ebgp_requires_policy', {
              //caption:        L.tr('EBGP Requires Policy'),         
              //optional:    true
            //});    
            
    s1.option(L.cbi.CheckboxValue, 'import_check', {
              caption:        L.tr('Network Import Check'),         
              optional:    true
            });        
       
    s1.option(L.cbi.DynamicList, 'network', {
       caption:     L.tr('Advertise Networks'),		         
	    //initial: "192.168.10.0/24",
	   //datatype: 'cidr4',
       description: L.tr(' Advertise Networks must be given as an address with subnet mask, ex: 192.168.10.0/24'),
	   optional:     true
	  }).value("none", "None"); 
		         
    s1.option(L.cbi.DynamicList, 'redistribute', {
			caption:     L.tr('Redistribute options'),
			optional:     true
		}).value("none", "None")
		.value("kernel", "Kernel Added Routes")
		.value("connected", "Connected Routes")
		.value("ospf", "OSPF Routes")
		.value("nhrp", "NHRP Routes")
		.value("static", "Static Routes");
	     
      s1.option(L.cbi.CheckboxValue, 'deterministic_med', {
              caption:        L.tr('Deterministic MED'),  
              optional: true       
            });          
            
     
   m1.insertInto('#section_routing_instance');  
   
   
   
    $('#btn_bgp_general_update').click(function() {
        L.ui.loading(true);
        self.updategeneralconfig('configure').then(function(rv) {
			L.ui.loading(false);
                L.ui.dialog(
                    L.tr('update configuration'),[
                        $('<pre />')
                        .addClass('alert alert-success')
                        .text(rv)
                    ],
                   
                    { style: 'close'}
                );
                
               });
              
        });
   
   
             var self = this;
             
             self.BGPGetUCISections("bgpdisplay","bgp").then(function(rv) {
					var keys = Object.keys(rv);
                    var keysLength=keys.length;
                   
                    if(keysLength > 0)
                    {
							   self.updatebgpstatusconfig('configure').then(function(rv) {
						   });
						   
                           self.BGPStatusRenderContents(rv); 
                    }
                    
            });
            
            //function fetchDataAndRender() {
				 
				//self.BGPGetUCISections("bgpdisplay", "bgp").then(function(rv) {
				//var keys = Object.keys(rv);
				//var keysLength = keys.length;

				//if (keysLength > 0) {
					//self.updatebgpstatusconfig('configure').then(function(rv) {
					//// Do something after updatebgpstatusconfig is complete
				//});
				 ////while (table.firstChild) {
					//////table.removeChild(table.firstChild);
				////}
				//self.BGPStatusRenderContents(rv);
			//}
		//});
//}
            
          
          	 $('#btn_bgpstatus_refresh').click(function() {

            L.ui.loading(true);
            self.updatebgpstatusconfig('configure').then(function(rv) {
                L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Show Status'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text(rv)
             
                        ],
                       
                        { style: 'close' , 
							close:function()
							{
								location.reload();
							}
						}
                        
                    );
                
                    
                   });
                  
            });
             
            $('#btn_bgpstatus_refresh').show();
          
          
            
            

 //$('#btn_bgpstatus_refresh').click(function() { 
	  //L.ui.loading(true);
	  
                    //self.fetchDataAndRender();
                     //L.ui.loading(false);
                     
            //});
             
              
           
           
            $('#AddNewbgppeer').click(function() { 
                    self.PeerConfigSectionAdd();
            });
          
          self.BGPGetUCISections("bgpconfig","bgp_peer").then(function(rv) {
					var keys = Object.keys(rv);
                    var keysLength=keys.length;
                   
                    if(keysLength > 0)
                    {
                           self.PeerRenderContents(rv); 
                    }
                    
            });           
           

         
            $('#AddNewbgppeergroup').click(function() { 
                self.PeerGroupConfigSectionAdd();
          });
          
			
            self.BGPGetUCISections("bgpconfig","bgp_peer_group").then(function(rv) {
				var keys = Object.keys(rv);
                var keysLength=keys.length;
                if(keysLength > 0)
                {
					self.PeerGroupRenderContents(rv); 
				}                   
                
          }); 
          
          
          changestatuspeer=function (n) {
                        var checkbox = $("#PeerstatusSwitch" + n)[0].checked
                        var faileditdata = configdata1();
                        console.log(faileditdata)
                        var portName=Object.keys(faileditdata)[n] 
                        console.log(portName)
                        var sensorSectionOptions = { enabled: "0" };
                          console.log(checkbox);
                        if (checkbox) {
                            document.getElementById("PeerstatusSwitch"+n).checked = true;
                             sensorSectionOptions = { enabled: "1" };
                        }
                        else {
                            document.getElementById("PeerstatusSwitch"+n).checked = false;
                            sensorSectionOptions = { enabled: "0" };
                        }
         self.BGPCreateUCISection("bgpconfig","bgp_peer",portName,sensorSectionOptions).then(function(rv){                            if (rv) {
                                if (rv.section) {
                                    self.BGPCommitUCISection("bgpconfig").then(function (res) {
                                        if (res != 0) {
                                            alert("Error:New Event Configuration");
                                        }
                                        else {
                                            location.reload();
                                        }
                                    });
                                };
                            };
                        });
                }
        
          
          
           changestatus=function (n) {
                        var checkbox = $("#PeerGroupstatusSwitch" + n)[0].checked
                        var porteditdata = configdata();
                        console.log(porteditdata)
                        var portName=Object.keys(porteditdata)[n] 
                        console.log(portName)
                        var sensorSectionOptions = { enabled: "0" };
                          console.log(checkbox);
                        if (checkbox) {
                            document.getElementById("PeerGroupstatusSwitch"+n).checked = true;
                             sensorSectionOptions = { enabled: "1" };
                        }
                        else {
                            document.getElementById("PeerGroupstatusSwitch"+n).checked = false;
                            sensorSectionOptions = { enabled: "0" };
                        }
                        self.BGPCreateUCISection("bgpconfig", "bgp_peer_group",portName,sensorSectionOptions).then(function (rv) {
                            if (rv) {
                                if (rv.section) {
                                    self.BGPCommitUCISection("bgpconfig").then(function (res) {
                                        if (res != 0) {
                                            alert("Error:New Event Configuration");
                                        }
                                        else {
                                            location.reload();
                                        }
                                    });
                                };
                            };
                        });
                }
        
          
	  
    }
});


