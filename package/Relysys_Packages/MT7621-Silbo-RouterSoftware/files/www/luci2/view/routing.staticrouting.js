L.ui.view.extend({
	
	title: L.tr('Routing'),
	description: L.tr('Please update after editing any changes.'),		
	
	fGetUCISections: L.rpc.declare({
		object: 'uci',
		method: 'get',
		params: [ 'config', 'type' ],
		expect: { values: {} }
	}),
	
	fCreateUCISection:  L.rpc.declare({
		object: 'uci',
		method: 'add',
		params: [ 'config', 'type', 'values' ]
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

	updateroutingconfig: L.rpc.declare({
        object: 'rpc-updateroutingconfig',
        method: 'configure',
        expect: { output: '' }
    }),

	deleteroutingconfig: L.rpc.declare({
		object: 'rpc-updateroutingconfig',
		method: 'delete',
		expect: { output: '' }
	}),  
			
	
	fCreateForm: function(mapwidget, fSectionID, fSectionType)
	{
		var self = this;
		
		if (!mapwidget)
			mapwidget = L.cbi.Map;
		
		if(fSectionType == "Droutes") {
			var FormContent = self.srCreateFormCallback;
		}else if(fSectionType == "Sroutes") {
			var FormContent = self.AsrCreateFormCallback;
		}else if(fSectionType == "Troutes") {
			var FormContent = self.AsrtCreateFormCallback;
		}
		
		var map = new mapwidget('routingconfig', {
			prepare:    FormContent,
			fSection:   fSectionID
		});
		return map;
	},

	
	
	fSectionEdit: function(ev) {
		var self = ev.data.self;
		var fSectionID = ev.data.fSectionID;
		var fSectionType = ev.data.fSectionType;
		
		return self.fCreateForm(L.cbi.Modal, fSectionID, fSectionType).show();
		
	},
	
	srCreateFormCallback: function()
	{
		var map = this;
		var srSectionID = map.options.fSection;
		
		map.options.caption = L.tr('Port Forward Configuration');
		
		var s = map.section(L.cbi.NamedSection, srSectionID, {
			collabsible: true,
			anonymous:   true,
			 tabbed:      true
		});

		s.option(L.cbi.ComboBox, 'interface', {                                            
			caption:     L.tr('Interface'),
			optional:      'true'
		}).value("eth0", L.tr('eth0'))
		.value("eth0.1", L.tr('eth0.1'))
		.value("eth0.5", L.tr('eth0.5'))
		.value("lo", L.tr('lo'))
		.value("ra0", L.tr('ra0'))
		.value("ra1", L.tr('ra1'))
		.value("usb0", L.tr('usb0'))
		  .value("wwan0", L.tr('wwan0'));
		 
		
		s.option(L.cbi.InputValue, 'target', {
			caption:     L.tr('Target'),
			datatype:    'ip4addr',
            optional: true 	
		});	
		
		s.option(L.cbi.InputValue, 'ipv4netmask', {
			caption:     L.tr('IPV4 Netmask'),
			datatype:    'netmask4',
		    optional: true,
		 });

				
		s.option(L.cbi.InputValue, 'metric', {
			caption:     L.tr('Metric'),
			placeholder: "0",
			datatype: 'uinteger',
			optional: true, 	

		});
		
		s.option(L.cbi.InputValue, 'ipv4gateway', {
			caption:     L.tr('IPV4 Gateway'),
			datatype:    'ip4addr',
		    optional: true,
		});

		s.option(L.cbi.ComboBox, 'routetype', {                                            
			caption:     L.tr('Route type'),
			optional:      'true'
		}).value("unicast", L.tr('Unicast'));

		
	     
	},

	
	srRenderContents: function(rv)
	{
		debugger;
		var self = this;

		var list = new L.ui.table({
			columns: [ { 
				caption: L.tr('Interface'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srInterface_%s'.format(n));
					return div.append('<strong>'+v+'</strong>');
				}
			},{ 
				caption: L.tr('Target'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srTarget_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('IPV4Netmask'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srIPV4Netmask_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('Metric'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srMetric_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('IPV4Gateway'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srIPV4Gateway_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Routetype'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'srRoutetype_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Actions'),
				format:  function(v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Static Routes'))
							.click({ self: self, fSectionID: v, fSectionType: "Droutes" }, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Static Routes'))
							.click({ self: self, srSectionID: v }, self.srSectionRemove));
				}
			}]
		});
		
		for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
								var Sourcemap =obj.interface
								var SourceIP = obj.target;
								var SourceNetmask = obj.ipv4netmask
								var Sourcemetric = obj.metric
								var Sourcegateway = obj.ipv4gateway
								var Sourcetype = obj.routetype
								
                                list.row([Sourcemap,SourceIP,SourceNetmask,Sourcemetric,Sourcegateway,Sourcetype,key]); 
                        }
                }
		
		
		$('#section_staticroutes_port').append(list.render());	
			
	},
    

	srSectionRemove: function(ev) {
		var self = ev.data.self;
		var srSectionID = ev.data.srSectionID;
		
		self.deleteroutingconfig('delete').then(function(rv) {
			self.fDeleteUCISection("routingconfig","routes",srSectionID).then(function(rv){
			if(rv == 0){
				self.fCommitUCISection("routingconfig").then(function(res){
						if (res != 0){
							alert("Error: Delete Static Routes Configuration");
						}
						else {
							location.reload();
						}
				});
			};
		});
	});

	},

	
	
	srSectionAdd: function () 
	{
		var self = this;
		var srInterface = $('#field_staticroutes_routes_newRoutes_interface').val();		
		var srTarget = $('#field_staticroutes_routes_newRoutes_target').val();
		var srIPV4Netmask = $('#field_staticroutes_routes_newRoutes_ipv4netmask').val();
		var srMetric = $('#field_staticroutes_routes_newRoutes_metric').val();
		var srIPV4Gateway = $('#field_staticroutes_routes_newRoutes_ipv4gateway').val();
		var srRoutetype = $('#field_staticroutes_routes_newRoutes_routetype').val();
		var srTargetcheck = false;

		if (srInterface === "custom")
		{
			srInterface = $('#field_staticroutes_routes_newRoutes_inter').val();
		}

		if (srRoutetype === "custom")
		{
			srRoutetype = $('#field_staticroutes_routes_newRoutes_routetype1').val();
		}
		// Regular expression pattern for IPv4 validation
		var ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}$/;
		
			// Check if the input matches the IPv4 pattern
		if (ipv4Pattern.test(srTarget)) {
			 srTargetcheck = true; // Valid IPv4 address
			} 


		
		if (srTargetcheck)
		{
			var SectionOptions = {interface:srInterface,target:srTarget,ipv4netmask:srIPV4Netmask,metric:srMetric,ipv4gateway:srIPV4Gateway,routetype:srRoutetype};
			self.fCreateUCISection("routingconfig","routes",SectionOptions).then(function(rv){
			if(rv){
				if (rv.section){
					self.fCommitUCISection("routingconfig").then(function(res){
						if (res != 0) {
							alert("Error: New Static Routes Configuration");
						}
						else {
							location.reload();
						}
					});
					
				};
			};
		});
		}
		else
		{
			alert("Invalid IPV4 address");
		}
		
		
	},

	AsrCreateFormCallback: function()
	{
		var map = this;
		var AsrSectionID = map.options.fSection;
		
		map.options.caption = L.tr('Port Forward Configuration');
		
		var s = map.section(L.cbi.NamedSection, AsrSectionID, {
			collabsible: true,
			anonymous:   true,
			 tabbed:      true
		});

		s.option(L.cbi.ComboBox, 'interface', {                                            
			caption:     L.tr('Interface'),
			optional:      'true'
		}).value("eth0", L.tr('eth0'))
		.value("eth0.1", L.tr('eth0.1'))
		.value("eth0.5", L.tr('eth0.5'))
		.value("lo", L.tr('lo'))
		.value("ra0", L.tr('ra0'))
		.value("ra1", L.tr('ra1'))
		.value("usb0", L.tr('usb0'))
		.value("wwan0", L.tr('wwan0'));
		 
		 
		
		s.option(L.cbi.InputValue, 'to', {
			caption:     L.tr('To'),
			datatype:    'ip4addr',
            optional: true 	
		});	
		
		s.option(L.cbi.InputValue, 'ipv4netmask', {
			caption:     L.tr('IPV4 Netmask'),
			datatype:    'netmask4',
		    optional: true,
		 });

		 s.option(L.cbi.InputValue, 'table', {
			caption:     L.tr('TableID'),
			placeholder: "100",
			datatype: 'uinteger',
			optional: true, 	
		 });		
		
		
		s.option(L.cbi.InputValue, 'from', {
			caption:     L.tr('From'),
			datatype:    'ip4addr',
		    optional: true,
		});

		s.option(L.cbi.ComboBox, 'priority', {                                            
			caption:     L.tr('Priority'),
			optional:      'true'
		});
		s.option(L.cbi.ComboBox, 'interfacesout', {                                            
			caption:     L.tr('outgoingInterface'),
			optional:      'true'
		}).value("fwmark", L.tr('fwmark'))
		.value("iif", L.tr('iif'))
		.value("oif", L.tr('oif'))
		.value("lookup", L.tr('lookup'))
		.value("blackhole", L.tr('blackhole'))
		.value("prohibited", L.tr('prohibited'))
		.value("unreachable", L.tr('unreachable'));
	},

	AsrRenderContents: function(rv)
	{
		debugger;
		var self = this;

		var list = new L.ui.table({
			columns: [ { 
				caption: L.tr('Interface'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrInterface_%s'.format(n));
					return div.append('<strong>'+v+'</strong>');
				}
			},{ 
				caption: L.tr('To'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrTo_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('IPV4 Netmask'),
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrIPV4Netmask_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('TableID'),
				align: 'center',
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrTable_%s'.format(n));
					return div.append(v);
				}
			},{ 
				caption: L.tr('From'),
				align: 'center',
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrFrom_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Priority'),
				align: 'center',
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrPriority_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Actions'),
				format:  function(v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Advanced Static Routes'))
							.click({ self: self, fSectionID: v, fSectionType: "Sroutes" }, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Advanced Static Routes'))
							.click({ self: self, AsrSectionID: v }, self.AsrSectionRemove));
				}
			}]
		});
		
		for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
								var Sourceifce =obj.interface
								var Sourceto = obj.to
								var Sourcenetmask = obj.ipv4netmask
								var Sourcetable = obj.table
								var Sourcefrom = obj.from
								var Sourcepriority = obj.priority
								
                                list.row([Sourceifce,Sourceto,Sourcenetmask,Sourcetable,Sourcefrom,Sourcepriority,key]); 
                        }
                }
		
		
		$('#section_advancedstaticroutes_Asr').append(list.render());	
			
	},

	AsrSectionRemove: function(ev) {
		var self = ev.data.self;

		var AsrSectionID = ev.data.AsrSectionID;
		
		self.deleteroutingconfig('Delete').then(function(rv) {
			

			self.fDeleteUCISection("routingconfig","rule",AsrSectionID).then(function(rv){
			if(rv == 0){
				self.fCommitUCISection("routingconfig").then(function(res){

						if (res != 0){
							alert("Error: Delete Advanced Static Routes Configuration");
						}
						else {
							location.reload();
						}
					//});
				});
			};
		});
	});

	},

	
	
	AsrSectionAdd: function () 
	{
		var self = this;
		var AsrInterface = $('#section_advancedstaticroutes_Asr_interface').val();		
		var AsrTo = $('#section_advancedstaticroutes_Asr_to').val();
		var AsrIPV4Netmask = $('#section_advancedstaticroutes_Asr_ipv4netmask').val();
		var AsrTable = $('#section_advancedstaticroutes_Asr_table').val();
		var AsrFrom = $('#section_advancedstaticroutes_Asr_from').val();
		var AsrPriority = $('#section_advancedstaticroutes_Asr_priority').val();
		var AsrTocheck = false;


		if (AsrInterface === "custom")
		{
			AsrInterface = $('#section_advancedstaticroutes_Asr_inter').val();
		}
        if (AsrTable === "custom")
		{
			AsrTable = $('#section_advancedstaticroutes_Asr_table1').val();
		}
		



		// Regular expression pattern for IPv4 validation
		var ipv4Pattern = /^(\d{1,3}\.){3}\d{1,3}$/;
		
			// Check if the input matches the IPv4 pattern
		if (ipv4Pattern.test(AsrTo)) {
			AsrTocheck = true; // Valid IPv4 address
			} 


		
		if (AsrTocheck)
		{
			var SectionOptions = {interface:AsrInterface,to:AsrTo,ipv4netmask:AsrIPV4Netmask,from:AsrFrom,table:AsrTable,from:AsrFrom,priority:AsrPriority};
			self.fCreateUCISection("routingconfig","rule",SectionOptions).then(function(rv){
			if(rv){
				if (rv.section){
					self.fCommitUCISection("routingconfig").then(function(res){
						if (res != 0) {
							alert("Error:New Advanced Static Routes Configuration");
						}
						else {
							location.reload();
						}
					});
					
				};
			};
		});
		}
		else
		{
			alert("Invalid IPV4 address");
		}
		
		
	},

	AsrtCreateFormCallback: function()
	{
		var map = this;
		var AsrSectionID = map.options.fSection;
		
		map.options.caption = L.tr('Port Forward Configuration');
		
		var s = map.section(L.cbi.NamedSection, AsrSectionID, {
			collabsible: true,
			anonymous:   true,
			 tabbed:      true
		});

		s.option(L.cbi.DummyValue, 'typesettings', {
			caption: L.tr(''),
			
	    }).ucivalue = function () {
					var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspRouting Table </b> </h3>";
					return id;
			};

		s.option(L.cbi.InputValue, 'tableid', {                                            
			caption:     L.tr('ID of table'),
			optional:      'true'
		});
        

		s.option(L.cbi.InputValue, 'name', {                                            
			caption:     L.tr('Nameoftable'),
			optional:      'true'
		});

		s.option(L.cbi.DummyValue, 'typesettings', {
			caption: L.tr(''),
			
	    }).ucivalue = function () {
					var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspStaticIPV4Routes</b> </h3>";
					return id;
			};

		
		s.option(L.cbi.InputValue, 'target', {
			caption:     L.tr('Target'),
			placeholder: "192.168.10.0",
			datatype:    'ip4addr',
            optional: true 	
		});	
		
		s.option(L.cbi.InputValue, 'ipv4netmask', {
			caption:     L.tr('IPV4 Netmask'),
			placeholder: "255.255.255.0",
			datatype:    'netmask4',
		    optional: true,
		 });

				
		s.option(L.cbi.InputValue, 'metric', {
			caption:     L.tr('Metric'),
			placeholder: "0",
			datatype: 'uinteger',
			optional: true, 	

		});
		
		s.option(L.cbi.InputValue, 'ipv4gateway', {
			caption:     L.tr('IPV4 Gateway'),
			placeholder: "10.1.1.1",
			datatype:    'ip4addr',
		    optional: true,
		});

		s.option(L.cbi.ComboBox, 'routetype', {                                            
			caption:     L.tr('Route type'),
			optional:      'true'
		}).value("unicast", L.tr('Unicast'));

		
		
	     
	},

	AsrtRenderContents: function(rv)
	{
		debugger;
		var self = this;

		var list = new L.ui.table({
			columns: [ { 
				caption: L.tr('TableID'),
				width: '15%',
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrtTableid_%s'.format(n));
					return div.append('<strong>'+v+'</strong>');
				}
			},{ 
				caption: L.tr('TableName'),
				width: '15%',
				align: 'left',
				format:  function(v,n) {
					var div = $('<p />').attr('id', 'AsrtName_%s'.format(n));
					return div.append(v);
				}
			},{
				caption: L.tr('Actions'),
				width: '15%',
				align: 'center',
				format:  function(v, n) {
					return $('<div />')
						.addClass('btn-group btn-group-sm')
						.append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Edit Advanced Static Routes'))
							.click({ self: self, fSectionID: v, fSectionType: "Troutes" }, self.fSectionEdit))
						.append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Advanced Static Routes'))
							.click({ self: self, AsrSectionID: v }, self.AsrtSectionRemove));
				}
			}]
		});
		
		for (var key in rv) 
                {
                        if (rv.hasOwnProperty(key)) 
                        {
                                var obj = rv[key];
								var Sourceifce =obj.tableid
								var Sourcepriority = obj.name
								
                                list.row([Sourceifce,Sourcepriority,key]); 
                        }
                }
		
		
		$('#Tableadv').append(list.render());	
			
	},

	AsrtSectionRemove: function(ev) {
		var self = ev.data.self;

		var AsrSectionID = ev.data.AsrSectionID;
		
		self.deleteroutingconfig('Delete').then(function(rv) {
			

			self.fDeleteUCISection("routingconfig","table",AsrSectionID).then(function(rv){
			if(rv == 0){
				self.fCommitUCISection("routingconfig").then(function(res){

						if (res != 0){
							alert("Error: Delete Advanced Static Routes Configuration");
						}
						else {
							location.reload();
						}
					//});
				});
			};
		});
	});

	},

	
	
	AsrtSectionAdd: function () 
	{
		var self = this;
		var AsrtTableid = $('#section_advancedstaticroutes_Asrt_TableID').val();		
		var AsrtName = $('#section_advancedstaticroutes_Asrt_Name').val();
		var AsrTocheck = false;

		if (!AsrtTableid) {
			AsrTocheck = false;
		}
        else {
            AsrTocheck = true;

		}
		
		
		if (AsrTocheck)
		{
			var SectionOptions = {tableid:AsrtTableid,name:AsrtName};
			self.fCreateUCISection("routingconfig","table",SectionOptions).then(function(rv){
			if(rv){
				if (rv.section){
					self.fCommitUCISection("routingconfig").then(function(res){
						if (res != 0) {
							alert("Error:New Advanced Static Routes Configuration");
						}
						else {
							location.reload();
						}
					});
					
				};
			};
		});
		}
		else
		{
			alert("Add TableID And TableName");
		}
		
		
	},
	
	execute: function() {
			
		var self = this;
		this.fGetUCISections("routingconfig","routes").then(function(rv) {
			self.srRenderContents(rv);   
		});
			this.fGetUCISections("routingconfig","rule").then(function(rv) {
				self.AsrRenderContents(rv);   
		});
		this.fGetUCISections("routingconfig","table").then(function(rv) {
			self.AsrtRenderContents(rv);   
	    });
	
		
		
		$('#AddNewStaticRoutes').click(function() {          
			self.srSectionAdd();
		});

		$('#AddNewAdvancedstaticRule').click(function() {          
			self.AsrSectionAdd();
		});

		$('#AddNewAdvancedstatictable').click(function() {          
			self.AsrtSectionAdd();
		});

		

	    $('#btn_update').click(function() {
            L.ui.loading(true);
            self.updateroutingconfig('configure').then(function(rv) {
                L.ui.loading(false);
                    L.ui.dialog(
                        L.tr('Updated routing configuration'),[
                            $('<pre />')
                            .addClass('alert alert-success')
                            .text(rv)
                        ],
                        { style: 'close'}
                    );
                    
                   });
		
            });
	}
});
