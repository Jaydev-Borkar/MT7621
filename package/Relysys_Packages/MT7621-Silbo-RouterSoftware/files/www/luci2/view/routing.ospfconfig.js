L.ui.view.extend({
    title: L.tr('OSPF'),
    description: L.tr(''),
    
    loadInterfaces: L.rpc.declare({
            object: 'network.interface',
            method: 'dump',
            expect: { interface: [] }
    }),
    
    OSPFGetUCISections: L.rpc.declare({
            object: 'uci',
            method: 'get',
            params: [ 'config', 'type'],
            expect: { values: {} }
    }),
    
    OSPFCreateUCISection:  L.rpc.declare({
            object: 'uci',
            method: 'add',
            params: [ 'config', 'type', 'name', 'values' ]
    }),
    
    OSPFCommitUCISection:  L.rpc.declare({
            object: 'uci',
            method: 'commit',
            params: [ 'config' ]
    }),
    
    OSPFDeleteUCISection:  L.rpc.declare({
    object: 'uci',
    method: 'delete',
    params: [ 'config','type','section' ]
}),

    updategeneralconfig: L.rpc.declare({
        object: 'rpc-updateospfconfig',
        method: 'configure',
        expect: { output: '' }
    }),
    
    
    updateospfstatusconfig: L.rpc.declare({
        object: 'rpc-updateospfstatus',
        method: 'configure',
        expect: { output: '' }
    }),


      OSPFNetworkAreaCallback: function() 
        {
        var map = this;
        var OSPFNetworkAreaSectionName = map.options.OSPFNetworkAreaSection;
        var numericExpression = /^[0-9]+$/;
            
        map.options.caption = L.tr(OSPFNetworkAreaSectionName+' Configuration');
            
        var s2 = map.section(L.cbi.NamedSection, OSPFNetworkAreaSectionName, {
                collabsible: true
        });
        
       //s2.option(L.cbi.InputValue, 'name', {
			//caption:     L.tr('Name'),	
		//});
		  
           
       s2.option(L.cbi.InputValue, 'network', {
       caption: L.tr('Network'),
       //placeholder: "192.168.25.0/24",
       datatype: "cidr4",
       });  
       
       s2.option(L.cbi.InputValue, 'area', {
       caption: L.tr('Area'),
       });  
      

                       
 },
      
       
        
    OSPFInterfaceCallback: function() 
    {
        var map = this;
        var OSPFInterafceConfigSectionName = map.options.OSPFInterafceConfigSection;
        var numericExpression = /^[0-9]+$/;
            
        map.options.caption = L.tr(OSPFInterafceConfigSectionName+' Configuration');
            
        var s = map.section(L.cbi.NamedSection, OSPFInterafceConfigSectionName, {
                collabsible: true
        });
        
        //alert(map.options.container);
       s.option(L.cbi.DynamicComboBox, 'interface', {
			caption:     L.tr('Interface'),	
		}).value(map.options.container);
		  
           
       s.option(L.cbi.InputValue, 'priority', {
       caption: L.tr('Priority'),
       });  
       
      s.option(L.cbi.InputValue, 'cost', {
       caption: L.tr('Cost'),
       optional:     true
       });  
       
       s.option(L.cbi.InputValue, 'hello_interval', {
       caption: L.tr('Hello Interval'),
       optional:     true
       });    
        
       s.option(L.cbi.InputValue, 'dead_interval', {
       caption: L.tr('Dead Interval'),
       optional:     true
       });  
       
       s.option(L.cbi.InputValue, 'retransmit_interval', {
       caption: L.tr('Retransmit Interval'),
       optional:     true
       });  
             
       s.option(L.cbi.ListValue, 'network_type', {
			caption:     L.tr('Network Type'),	
		}).value("broadcast", L.tr('Broadcast'))
		  .value("non-broadcast", L.tr('Non-Broadcast'))
		  .value("point-to-point", L.tr('Point to Point'))
		  .value("point-to-multipoint", L.tr('Point to Multipoint'));       
		  
	   s.option(L.cbi.ListValue, 'authentication', {
			caption:     L.tr('Authentication'),	
		}).value("none", L.tr('None'))
		  .value("general_key", L.tr('General Key'))
		  .value("md5", L.tr('MD5'));
		  
	   s.option(L.cbi.InputValue, 'authentication_id', {
       caption: L.tr('Authentication ID'),
       }).depends({'authentication':"md5"}); 	  
		    
	   s.option(L.cbi.InputValue, 'authentication_key', {
       caption: L.tr('Authentication Key'),
       }).depends({'authentication':"general_key"})
       .depends({'authentication':"md5"}); 	  
		      	
		           
 },


      //OSPFNeighborCallback: function() 
    //{
        //var map = this;
        //var OSPFNeighborConfigSectionName = map.options.OSPFNeighborConfigSection;
        //var numericExpression = /^[0-9]+$/;
            
        //map.options.caption = L.tr(OSPFNeighborConfigSectionName+' Configuration');
            
        //var s1 = map.section(L.cbi.NamedSection, OSPFNeighborConfigSectionName, {
                //collabsible: true
        //});
        
        ////s1.option(L.cbi.InputValue, 'name', {
			////caption:     L.tr('Name'),	
		////});
        
       //s1.option(L.cbi.InputValue, 'neighbor', {
			//caption:     L.tr('Neighbor'),	
		//});
		  
           
       //s1.option(L.cbi.InputValue, 'priority', {
       //caption: L.tr('Priority'),
       //});  
       
       //s1.option(L.cbi.InputValue, 'polling_interval', {
       //caption: L.tr('Polling Interval'),
       //optional:     true
       //});   
       
       ////s.option(L.cbi.DynamicList, 'ipaddr', {
       ////caption:     L.tr('IP Address'),		         
	   ////datatype:    'ipaddr',
	   ////optional:     true
	  ////}).value("none", "None"); 
       
                       
 //},
 
       OSPFNetworkAreaCreateForm: function(mapwidget,OSPFNetworkAreaSectionName) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('ospfconfig', {
                    prepare: self.OSPFNetworkAreaCallback,
                    OSPFNetworkAreaSection: OSPFNetworkAreaSectionName
            });
            return map;
    },
     

  
    OSPFInterfaceCreateForm: function(mapwidget,OSPFInterafceConfigSectionName,container) 
    {
            var self = this;
            
            if (!mapwidget)
                    mapwidget = L.cbi.Map;
            
            var map = new mapwidget('ospfconfig', {
                    prepare: self.OSPFInterfaceCallback,
                    OSPFInterafceConfigSection: OSPFInterafceConfigSectionName,
                    container: container
            });
            return map;
    },
    
    //OSPFNeighborCreateForm: function(mapwidget,OSPFNeighborConfigSectionName) 
    //{
            //var self = this;
            
            //if (!mapwidget)
                    //mapwidget = L.cbi.Map;
            
            //var map = new mapwidget('ospfconfig', {
                    //prepare: self.OSPFNeighborCallback,
                    //OSPFNeighborConfigSection: OSPFNeighborConfigSectionName
            //});
            //return map;
    //},
  
  
   
   OSPFStatusRenderContents: function (rv) {

                var self = this;

                var list = new L.ui.table({
                        columns: [
                        {
                               // caption: L.tr('BGP Neighbor'),
                                width: '14%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'OSPF_Neighbor_%s'.format(n));
                                        return div.append('<strong>' + v + '</strong>');
                                }
                        },
                        
                        {
                                //caption: L.tr('State'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'OSPFState_%s'.format(n));
                                       // return div.append('<strong>' + v + '</strong>');
                                       return div.append(v);
                                }
                        },
                        
                        {
                               // caption: L.tr('Local AS'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'OSPFPriority_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        
                        {
                               // caption: L.tr('Uptime'),
                                width: '20%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'OSPFRequest_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                        
                        
                        //{
                               //// caption: L.tr('Uptime'),
                                //width: '20%',
                                //align: 'left',
                                //format: function (v, n) {
                                        //var div = $('<p />').attr('id', 'BGPConnectTime_%s'.format(n));
                                        //return div.append(v);
                                //}
                        //},
                        
                        
                        ]
					});
					
					for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                var Neighborid = obj.neighborid;
                                var priority = obj.priority;
                                var state = obj.state;
                                var deadtime = obj.deadtime;
                                var neighboraddress = obj.neighboraddress;
                                var interface = obj.interface;
                                var interfaceaddress = obj.interfaceaddress;
                                var RXmtL = obj.RXmtL;
                                var RqstL = obj.RqstL;
                                var DBsmL = obj.DBsmL;
                                
                                
            
            B = "<b>State:</b>"+state + "<br />" +"<b>Local Interface:</b>"+interface + "<br />" + "<b>Local Interface Address:</b>"+interfaceaddress;      
           
           C = "<b>Neighbor Address:</b>"+neighboraddress + "<br />" +"<b> Priority:</b>"+priority + "<br />" + "<b>Dead Time:</b>"+deadtime;                 

           
            E = "<b>Received Metric LSA:</b>"+RXmtL + "<br />" +"<b>LSA Requests:</b>"+RqstL + "<br />" + "<b>LSA DB Description:</b>"+DBsmL;
                          
                                list.row([Neighborid,B,C,E]);
							}
						}
						$('#section_ospf_status').append(list.render());				
            },
                        
  
         OSPFNetworkAreaRenderContents: function(rv) 
         {         
		configdata3 = function () {
                        return rv;
                    }
		           
            var self = this;

            var list2 = new L.ui.table({
                    columns: [
                    { 
				caption: L.tr('Name'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'OspfName_%s'.format(n));
					return div.append(v);
				}
		    },
                    
            {            
            caption: L.tr('Network'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'OspfNetwork_%s'.format(n));
					return div.append(v);
				}
		    },    
		    
		    {
		    caption: L.tr('Area'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'OSPFArea%s'.format(n));
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
                                        var div = $('<label />').attr('id', 'NetworkArea_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v}   id="NetworkAreastatusSwitch${n}" onclick="changestatusnetarea(${n})">
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
                                            .click({ self: self, OSPFNetworkAreaSectionName: v }, self.OSPFNetworkAreaSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, OSPFNetworkAreaSectionName: v }, self.OSPFNetworkAreaSectionRemove));
                                          
                            }
                    }]
            });

         for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
                                var Name = obj.name;
						        var Network = obj.network;
                                var Area = obj.area;
                                var Enabled = obj.enabled;
						    
							 if (Enabled == "1") 
                              {
                                Enabled = "checked"
                              }

                              else 
                              {
                                Enabled = ""
                              }

                                list2.row([Name,Network,Area,Enabled,key]); 
                               // list.row([Interface,Priority,Enabled,key]); 
                        }
                }
               
          $('#section_ospf_network_area').append(list2.render());	

    },
       
  
  
  
   
    OSPFInterfaceRenderContents: function(rv) 
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
					var div = $('<p />').attr('id', 'OspfIntName_%s'.format(n));
					return div.append(v);
				}
		    },        
                    
            { 
				caption: L.tr('Interface'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'OspfInterface_%s'.format(n));
					return div.append(v);
				}
		    },
                    
            {            
            caption: L.tr('Priority'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'OspfPriority_%s'.format(n));
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
                                        return div.append(`<input type="checkbox" ${v}   id="InterfacestatusSwitch${n}" onclick="changestatusinterface(${n})">
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
                                            .click({ self: self, OSPFInterafceConfigSectionName: v,container: rv.container }, self.OSPFInterfaceConfigSectionEdit))
                                            .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            .click({ self: self, OSPFInterafceConfigSectionName: v }, self.OSPFInterfaceSectionRemove));
                                          
                            }
                    }]
            });

         for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key) && key != "container") 
                       
                        {
                                var obj = rv[key];
                                var Name = obj.name;
                                var Interface = obj.interface;
						        var Priority = obj.priority;
                                var Enabled = obj.enabled;
						    
							 if (Enabled == "1") 
                              {
                                Enabled = "checked"
                              }

                              else 
                              {
                                Enabled = ""
                              }

                                //list.row([Interface,Priority,key]); 
                               list.row([Name,Interface,Priority,Enabled,key]); 
                        }
                }
               
          $('#section_ospf_interface').append(list.render());	

    },
    
     
    //OSPFNeighborRenderContents: function(rv) 
    //{         
		//configdata2 = function () {
                        //return rv;
                    //}
		           
            //var self = this;

            //var list1 = new L.ui.table({
                    //columns: [
                    
            //{ 
				//caption: L.tr('Name'),
				//format:  function(v,n) {
					//var div = $('<p />').attr('id', 'OspfName_%s'.format(n));
					//return div.append(v);
				//}
		    //},
                    
                    
                    
                    //{ 
				//caption: L.tr('Neighbor'),
				//format:  function(v,n) {
					//var div = $('<p />').attr('id', 'OspfNeighbor_%s'.format(n));
					//return div.append(v);
				//}
		    //},
                    
            //{            
            //caption: L.tr('Priority'),
				//format:  function(v,n) {
					//var div = $('<p />').attr('id', 'OspfPriority_%s'.format(n));
					//return div.append(v);
				//}
		    //},    
		    
		    ////{
		    ////caption: L.tr('IP Address'),
				////format:  function(v,n) {
					////var div = $('<p />').attr('id', 'PeerIPAddress%s'.format(n));
					////return div.append(v);
				////}
		    ////},       
                    
                 
			        
			        //{
                                //caption: L.tr('Enable/Disable'),
                                //width: '20%',
                                //align: 'left',
                                //format: function (v, n) {
                                        ////alert(v)
                                        //console.log(this.Enabled)
                                        //var div = $('<label />').attr('id', 'Neighbor_%s'.format(n)).attr('class', 'switch');
                                        //return div.append(`<input type="checkbox" ${v}   id="NeighborstatusSwitch${n}" onclick="changestatusneighbors(${n})">
  //<span class="slider round"></span>`);
                                        
                                //}
                        //},
			        
                    
                    //{
                            //caption: L.tr('Update'),
                            //align: 'left',
                            //format: function(v, n) {
                                    //return $('<div />')
                                            //.addClass('btn-group btn-group-sm')
                                            //.append(L.ui.button(L.tr('Edit'),'primary', L.tr('Configure'))
                                            //.click({ self: self, OSPFNeighborConfigSectionName: v }, self.OSPFNeighborConfigSectionEdit))
                                            //.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                            //.click({ self: self, OSPFNeighborConfigSectionName: v }, self.OSPFNeighborSectionRemove));
                                          
                            //}
                    //}]
            //});

         //for (var key in rv) 
                //{
                        //if (rv.hasOwnProperty(key)) 
                        //{
                                //var obj = rv[key];
                                //var Name = obj.name;
                                //var Neighbor = obj.neighbor;
						        //var Priority = obj.priority;
                                //var Enabled = obj.enabled;
						    
							 //if (Enabled == "1") 
                              //{
                                //Enabled = "checked"
                              //}

                              //else 
                              //{
                                //Enabled = ""
                              //}

                                ////list1.row([Neighbor,Priority,key]); 
                               //list1.row([Name,Neighbor,Priority,Enabled,key]); 
                        //}
                //}
               
          //$('#section_ospf_neighbors').append(list1.render());	

    //},
    
   
      OSPFNetworkAreaSectionAdd: function () 
    {
        debugger
            var self = this;
 
       var OSPFNetworkAreaSectionName = $('#field_NewEvent_name_ospf').val();
       var OSPFNetwork = $('#field_NewEvent_Network_ospf').val();
       var OSPFArea = $('#field_NewEvent_Area_ospf').val();
       var OSPFNetworkAreaSection= {name:OSPFNetworkAreaSectionName,network:OSPFNetwork,area:OSPFArea,enabled: "1"};

           this.OSPFGetUCISections("ospfconfig","ospf_network").then(function(rv) {
                    var keys = Object.keys(rv);
                    var keysLength=keys.length;
                  
                    if(keysLength>=15)
                    {
                            alert("Only 15 connections can be configured");
                    }
                    else
                    {
                        
                              self.OSPFCreateUCISection("ospfconfig","ospf_network",OSPFNetworkAreaSectionName,OSPFNetworkAreaSection).then(function(rv){
                                    if(rv)
                                    {
                                            if (rv.section)
                                            {
                                                    self.OSPFCommitUCISection("ospfconfig").then(function(res){
                                                              
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
       
  
  
    OSPFInterfaceSectionAdd: function () 
    {
        debugger
            var self = this;
       
       var OSPFInterafceConfigSectionName = $('#field_NewEvent_name').val();
       var OSPFInterface = $('#field_NewEvent_interface').val();
       var OSPFPriority = $('#field_NewEvent_priority').val();
       
       if (OSPFInterafceConfigSectionName === "custom")
		{
			OSPFInterafceConfigSectionName = $('#field_NewEvent_inter').val();
		}

       
       var OSPFInterafceConfigSection= {name:OSPFInterafceConfigSectionName,interface:OSPFInterface,priority:OSPFPriority,enabled: "1"};

           this.OSPFGetUCISections("ospfconfig","ospf_interface").then(function(rv) {
                    var keys = Object.keys(rv);
                    var keysLength=keys.length;
                  
                    if(keysLength>=15)
                    {
                            alert("Only 15 connections can be configured");
                    }
                    else
                    {
                        
                              self.OSPFCreateUCISection("ospfconfig","ospf_interface",OSPFInterafceConfigSectionName,OSPFInterafceConfigSection).then(function(rv){
                                    if(rv)
                                    {
                                            if (rv.section)
                                            {
                                                    self.OSPFCommitUCISection("ospfconfig").then(function(res){
                                                              
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
    
    
    //OSPFNeighborSectionAdd: function () 
    //{
        //debugger
            //var self = this;
 
       //var OSPFNeighborConfigSectionName = $('#field_NewEvent_Name').val();
       //var OSPFNeighbor = $('#field_NewEvent_Neighbor').val();
       //var OSPFPriority = $('#field_NewEvent_Priorty').val();
       //var OSPFNeighborConfigSection= {name:OSPFNeighborConfigSectionName,neighbor:OSPFNeighbor,priority:OSPFPriority,enabled: "1"};

           //this.OSPFGetUCISections("ospfconfig","ospf_neighbors").then(function(rv) {
                    //var keys = Object.keys(rv);
                    //var keysLength=keys.length;
                  
                    //if(keysLength>=15)
                    //{
                            //alert("Only 15 connections can be configured");
                    //}
                    //else
                    //{
                        
                              //self.OSPFCreateUCISection("ospfconfig","ospf_neighbors",OSPFNeighborConfigSectionName,OSPFNeighborConfigSection).then(function(rv){
                                    //if(rv)
                                    //{
                                            //if (rv.section)
                                            //{
                                                    //self.OSPFCommitUCISection("ospfconfig").then(function(res){
                                                              
                            //if (res != 0) 
                                                            //{
                                //alert("Error:New Event Configuration");
                                                            //}
                                                            //else 
                                                            //{
                                                                    //location.reload();
                                                            //}
                                                    //});
                                            //};
                                    //};
                            //}); 
                    //}
            //});
    //},
    
    OSPFNetworkAreaSectionRemove: function(ev) 
    {
    var self = ev.data.self;
    var OSPFNetworkAreaSectionName = ev.data.OSPFNetworkAreaSectionName;
    self.OSPFDeleteUCISection("ospfconfig","ospfconfig",OSPFNetworkAreaSectionName).then(function(rv){
        if(rv == 0){
            self.OSPFCommitUCISection("ospfconfig").then(function(res){
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
     


  
    
    
    
    OSPFInterfaceSectionRemove: function(ev) 
    {
    var self = ev.data.self;
    var OSPFInterafceConfigSectionName = ev.data.OSPFInterafceConfigSectionName;
    self.OSPFDeleteUCISection("ospfconfig","ospf_interface",OSPFInterafceConfigSectionName).then(function(rv){
        if(rv == 0){
            self.OSPFCommitUCISection("ospfconfig").then(function(res){
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

      
   //OSPFNeighborSectionRemove: function(ev) 
    //{
    //var self = ev.data.self;
    //var OSPFNeighborConfigSectionName = ev.data.OSPFNeighborConfigSectionName;
    //self.OSPFDeleteUCISection("ospfconfig","ospfconfig",OSPFNeighborConfigSectionName).then(function(rv){
        //if(rv == 0){
            //self.OSPFCommitUCISection("ospfconfig").then(function(res){
                //if (res != 0)
                //{
                    //alert("Error: Delete Configuration");
                //}
                //else 
                                    //{
                    //location.reload();
                //}
            //});
        //};
    //});
//},
    
     OSPFNetworkAreaSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var OSPFNetworkAreaSectionName = ev.data.OSPFNetworkAreaSectionName;
            return self.OSPFNetworkAreaCreateForm(L.cbi.Modal,OSPFNetworkAreaSectionName).show();
    },
    
    OSPFInterfaceConfigSectionEdit: function(ev) 
    {
            var self = ev.data.self;
            var OSPFInterafceConfigSectionName = ev.data.OSPFInterafceConfigSectionName;
            var container = ev.data.container;
            return self.OSPFInterfaceCreateForm(L.cbi.Modal,OSPFInterafceConfigSectionName,container).show();
    },
 
 
    //OSPFNeighborConfigSectionEdit: function(ev) 
    //{
            //var self = ev.data.self;
            //var OSPFNeighborConfigSectionName = ev.data.OSPFNeighborConfigSectionName;
            //return self.OSPFNeighborCreateForm(L.cbi.Modal,OSPFNeighborConfigSectionName).show();
    //},
    
    
           
  
    execute:function()
    {
		
	
    var self = this;
          
    var m = new L.cbi.Map('ospfconfig', {       
		
                });
         
        
    var s = m.section(L.cbi.NamedSection, 'general', {
        caption:L.tr('General Configurations'),
    });
    
    
    s.option(L.cbi.CheckboxValue, 'enable_ospf', {
              caption:        L.tr('Enable OSPF'),
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
			 
			 
   m.insertInto('#section_ospf_general');  
   
   
   var m1 = new L.cbi.Map('ospfconfig', {
                });     
   
   var s1 = m1.section(L.cbi.NamedSection, 'main_instance', {
        caption:L.tr('Instance')
    });
    
    
    //s1.option(L.cbi.CheckboxValue, 'enable_instance', {
              //caption:        L.tr('Enable Instance'),         
              //optional:    true
            //});    
            
   s1.option(L.cbi.InputValue, 'router_id', {
       caption: L.tr('Router ID'),
       datatype: 'ip4addr',
       optional:    true
       });
       
    s1.option(L.cbi.DynamicList, 'passive_interface', {
			caption:     L.tr('Passive Interfaces'),
			description: L.tr('Passive Interfaces must be an interface name, ex: eth0.2'),
		//placeholder: "Must be an interface name ex: eth0.2",
			optional:     true
		}).value("none", "None")
		  .value("loopback", "Loopback")
		  .value("eth0.5", "eth0.5");    
  
  
    //s1.option(L.cbi.ListValue, 'generate_route', {
       //caption: L.tr('Generate a default external route'),
       //optional:    true
       //}).value("off", "off")
         //.value("always", "Always")
         //.value("default", "Default");   
         
         
    s1.option(L.cbi.DynamicList, 'redistribute', {
			caption:     L.tr('Redistribute options'),
			optional:     true
		}).value("none", "None")
		.value("kernel", "Kernel Added Routes")
		.value("connected", "Connected Routes")
		.value("nhrp", "NHRP Routes")
		.value("static", "Static Routes")
		.value("bgp", "BGP");     
          
     
   m1.insertInto('#section_ospf_instance');  
   
   
    $('#btn_ospf_general_update').click(function() {
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
             
             self.OSPFGetUCISections("ospfdisplay","ospf").then(function(rv) {
					var keys = Object.keys(rv);
                    var keysLength=keys.length;
                   
                    if(keysLength > 0)
                    {
							   self.updateospfstatusconfig('configure').then(function(rv) {
						   });
						   
                           self.OSPFStatusRenderContents(rv); 
                    }
                    
            });
            
        
          
          	 $('#btn_ospfstatus_refresh').click(function() {

            L.ui.loading(true);
            self.updateospfstatusconfig('configure').then(function(rv) {
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
          
  
              $('#AddNewNetworkArea').click(function() { 
                    self.OSPFNetworkAreaSectionAdd();
            });
          
          self.OSPFGetUCISections("ospfconfig","ospf_network").then(function(rv) {
					var keys = Object.keys(rv);
                    var keysLength=keys.length;
                   
                    if(keysLength > 0)
                    {
                           self.OSPFNetworkAreaRenderContents(rv); 
                    }
                    
            });           
             
  
  
  
            $('#AddNewospfinterface').click(function() { 
                    self.OSPFInterfaceSectionAdd();
            });
          

            var container = [];
          self.loadInterfaces().then(function(pv){
			for (var i=0; i < pv.length; i++)
			{
			        container.push(pv[i].device);
			}
                        self.OSPFGetUCISections("ospfconfig","ospf_interface").then(function(rv) {
                                var keys = Object.keys(rv);
                                var keysLength=keys.length;

                                rv.container = container;
           
                                if(keysLength > 0)
                                {
                                        self.OSPFInterfaceRenderContents(rv); 
                                }            
                }); 		 
	});
             
            
            
             //$('#AddNewospfNeighbor').click(function() { 
                    //self.OSPFNeighborSectionAdd();
            //});
          
          //self.OSPFGetUCISections("ospfconfig","ospf_neighbors").then(function(rv) {
					//var keys = Object.keys(rv);
                    //var keysLength=keys.length;
                   
                    //if(keysLength > 0)
                    //{
                           //self.OSPFNeighborRenderContents(rv); 
                    //}
                    
            //});       
            
              
              
            
            
            changestatusnetarea=function (n) {
                        var checkbox = $("#NetworkAreastatusSwitch" + n)[0].checked
                        var netareaeditdata = configdata3();
                        console.log(netareaeditdata)
                        var portName=Object.keys(netareaeditdata)[n] 
                        console.log(portName)
                        var sensorSectionOptions = { enabled: "0" };
                          console.log(checkbox);
                        if (checkbox) {
                            document.getElementById("NetworkAreastatusSwitch"+n).checked = true;
                             sensorSectionOptions = { enabled: "1" };
                        }
                        else {
                            document.getElementById("NetworkAreastatusSwitch"+n).checked = false;
                            sensorSectionOptions = { enabled: "0" };
                        }
                        self.OSPFCreateUCISection("ospfconfig", "ospf_network",portName,sensorSectionOptions).then(function (rv) {
                            if (rv) {
                                if (rv.section) {
                                    self.OSPFCommitUCISection("ospfconfig").then(function (res) {
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
            
                 
           
         
          changestatusinterface=function (n) {
                        var checkbox = $("#InterfacestatusSwitch" + n)[0].checked
                        var interfaceeditdata = configdata1();
                        console.log(interfaceeditdata)
                        var portName=Object.keys(interfaceeditdata)[n] 
                        console.log(portName)
                        var sensorSectionOptions = { enabled: "0" };
                          console.log(checkbox);
                        if (checkbox) {
                            document.getElementById("InterfacestatusSwitch"+n).checked = true;
                             sensorSectionOptions = { enabled: "1" };
                        }
                        else {
                            document.getElementById("InterfacestatusSwitch"+n).checked = false;
                            sensorSectionOptions = { enabled: "0" };
                        }
                          self.OSPFCreateUCISection("ospfconfig","ospf_interface",portName,sensorSectionOptions).then(function(rv){                            if (rv) {
                                if (rv.section) {
                                    self.OSPFCommitUCISection("ospfconfig").then(function (res) {
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
        
          
          
           //changestatusneighbors=function (n) {
                        //var checkbox = $("#NeighborstatusSwitch" + n)[0].checked
                        //var neighboreditdata = configdata2();
                        //console.log(neighboreditdata)
                        //var portName=Object.keys(neighboreditdata)[n] 
                        //console.log(portName)
                        //var sensorSectionOptions = { enabled: "0" };
                          //console.log(checkbox);
                        //if (checkbox) {
                            //document.getElementById("NeighborstatusSwitch"+n).checked = true;
                             //sensorSectionOptions = { enabled: "1" };
                        //}
                        //else {
                            //document.getElementById("NeighborstatusSwitch"+n).checked = false;
                            //sensorSectionOptions = { enabled: "0" };
                        //}
                        //self.OSPFCreateUCISection("ospfconfig", "ospf_neighbors",portName,sensorSectionOptions).then(function (rv) {
                            //if (rv) {
                                //if (rv.section) {
                                    //self.OSPFCommitUCISection("ospfconfig").then(function (res) {
                                        //if (res != 0) {
                                            //alert("Error:New Event Configuration");
                                        //}
                                        //else {
                                            //location.reload();
                                        //}
                                    //});
                                //};
                            //};
                        //});
                //}
        
          
              
          
	  
    }
});


