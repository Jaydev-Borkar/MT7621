L.ui.view.extend({

    title: L.tr('Wifi Advanced Settings'),
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
        object: 'rpc-updatewifiadvanceconfig',
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
 
		//Advanced Settings
              s.tab({
            id: 'Advanced2',
            caption: L.tr('2.4Ghz WIFI')
        });
		
      s.taboption('Advanced2',L.cbi.DummyValue, 'generalsettings', {
		  caption: L.tr(''),
		}).depends({'Advanced2':'1'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspAdvanced Settings </b> </h3>";
            return id;
          };
		 //Advanced Settings		
          s.taboption('Advanced2',L.cbi.InputValue, 'radiusport', {
           caption: L.tr('RADIUS Port'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});

          s.taboption('Advanced2',L.cbi.InputValue, 'radiusacctport', {
           caption: L.tr('RADIUS Acct Port'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
          s.taboption('Advanced2',L.cbi.CheckboxValue, 'TxBurst', {
           caption: L.tr('TxBurst'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
          s.taboption('Advanced2',L.cbi.CheckboxValue, 'HTOpMode', {
           caption: L.tr('HT OpMode'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
	  
          s.taboption('Advanced2',L.cbi.ListValue, 'HTMpduDensity', {
           caption: L.tr('HT MpduDensity'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'})
			.value('0', L.tr('no restriction'))
			.value('1', L.tr('1/4 μs'))
			.value('2', L.tr('1/2 μs'))
			.value('3', L.tr('1'))
			.value('4', L.tr('2'))
			.value('5', L.tr('4'))
			.value('6', L.tr('8'))
			.value('7', L.tr('16'));

          s.taboption('Advanced2',L.cbi.CheckboxValue, 'HTPROTECT', {
           caption: L.tr('HT PROTECT'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
          s.taboption('Advanced2',L.cbi.ListValue, 'HTRxStream', {
           caption: L.tr('HT RxStream'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'})
			.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
		
          s.taboption('Advanced2',L.cbi.ListValue, 'HTTxStream', {
           caption: L.tr('HT TxStream'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'})
			.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
		  
          s.taboption('Advanced2',L.cbi.ListValue, 'E2pAccessMode', {
           caption: L.tr('E2pAccessMode'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'})
		  	.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
			
          //s.taboption('Advanced2',L.cbi.CheckboxValue, 'WHNAT', {
           //caption: L.tr('HW NAT'), 
		//}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  //.depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
		  
          s.taboption('Advanced2',L.cbi.InputValue, 'BeaconPeriod', {
           caption: L.tr('BeaconPeriod'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
          s.taboption('Advanced2',L.cbi.InputValue, 'DtimPeriod', {
           caption: L.tr('DtimPeriod'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
        
		 s.taboption('Advanced2',L.cbi.CheckboxValue, 'WmmCapable', {
           caption: L.tr('WMM Capable'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
      
       s.taboption('Advanced2',L.cbi.InputValue, 'RTSThreshold', {
           caption: L.tr('RTS Threshold'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
       s.taboption('Advanced2',L.cbi.InputValue, 'FragThreshold', {
           caption: L.tr('Fragment Threshold'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
	   //s.taboption('Advanced2',L.cbi.CheckboxValue, 'IgmpSnEnable', {
           //caption: L.tr('IGMP Snooping'), 
		//}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  //.depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
	   s.taboption('Advanced2',L.cbi.CheckboxValue, 'HT_STBC', {
           caption: L.tr('STBC'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
	   s.taboption('Advanced2',L.cbi.CheckboxValue, 'HT_LDPC', {
           caption: L.tr('HT LDPC'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
	   s.taboption('Advanced2',L.cbi.CheckboxValue, 'VHT_STBC', {
           caption: L.tr('VHT STBC'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
	   s.taboption('Advanced2',L.cbi.CheckboxValue, 'VHT_LDPC', {
           caption: L.tr('VHT LDPC'), 
		}).depends({'Advanced2':'1','wifi1mode':'ap'})
		  .depends({'wificonfig':'1','wifi1enable' : '1','wifi1mode':'apsta'});
		  
        //Advanced Settings
              s.tab({
            id: 'Advanced',
            caption: L.tr('5Ghz WIFI')
        });
		
      s.taboption('Advanced',L.cbi.DummyValue, 'generalsettings', {
		  caption: L.tr(''),
		}).depends({'Advanced':'1'})
        .ucivalue=function()
          {
            var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspAdvanced Settings </b> </h3>";
            return id;
          };
      
		  //s.taboption('wifi5wifi',L.cbi.InputValue, 'wifi5PreAuthifname', {
           //caption: L.tr('Pre Authentication ifname'), 
      		//}).depends({'wifi5wifi':'1','wifi5wifienable':'1','wifi5wifi1enable':'1'});

		  
          s.taboption('Advanced',L.cbi.InputValue, 'wifi5radiusport', {
           caption: L.tr('RADIUS Port'), 
		}).depends({'Advanced':'1'});
		  
          s.taboption('Advanced',L.cbi.InputValue, 'wifi5radiusacctport', {
           caption: L.tr('RADIUS Acct Port'), 
		}).depends({'Advanced':'1'});

          s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5TxBurst', {
           caption: L.tr('TxBurst'), 
 		}).depends({'Advanced':'1'});

          s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5HTOpMode', {
           caption: L.tr('HT OpMode'), 
		}).depends({'Advanced':'1'});

          s.taboption('Advanced',L.cbi.ListValue, 'wifi5HTMpduDensity', {
           caption: L.tr('HT MpduDensity'), 
		}).depends({'Advanced':'1'})
			.value('0', L.tr('no restriction'))
			.value('1', L.tr('1/4 μs'))
			.value('2', L.tr('1/2 μs'))
			.value('3', L.tr('1'))
			.value('4', L.tr('2'))
			.value('5', L.tr('4'))
			.value('6', L.tr('8'))
			.value('7', L.tr('16'));

          s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5HTPROTECT', {
           caption: L.tr('HT PROTECT'), 
		}).depends({'Advanced':'1'});

          s.taboption('Advanced',L.cbi.ListValue, 'wifi5HTRxStream', {
           caption: L.tr('HT RxStream'), 
		}).depends({'Advanced':'1'})
			.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
			
          s.taboption('Advanced',L.cbi.ListValue, 'wifi5HTTxStream', {
           caption: L.tr('HT TxStream'), 
		}).depends({'Advanced':'1'})
			.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
					
 		  s.taboption('Advanced',L.cbi.ListValue, 'wifi5E2pAccessMode', {
           caption: L.tr('E2pAccessMode'), 
 		}).depends({'Advanced':'1'})
		  	.value('1', L.tr('1'))
			.value('2', L.tr('2'))
			.value('3', L.tr('3'))
			.value('4', L.tr('4'));
			
          //s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5WHNAT', {
           //caption: L.tr('HW NAT'), 
 		//}).depends({'Advanced':'1'});
		  
		  
          s.taboption('Advanced',L.cbi.InputValue, 'wifi5BeaconPeriod', {
           caption: L.tr('BeaconPeriod'), 
 		}).depends({'Advanced':'1'});
		  
          s.taboption('Advanced',L.cbi.InputValue, 'wifi5DtimPeriod', {
           caption: L.tr('DtimPeriod'), 
 		}).depends({'Advanced':'1'})
        
		 s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5WmmCapable', {
           caption: L.tr('WMM Capable'), 
 		}).depends({'Advanced':'1'});
      
       s.taboption('Advanced',L.cbi.InputValue, 'wifi5RTSThreshold', {
           caption: L.tr('RTS Threshold'), 
 		}).depends({'Advanced':'1'});
		  
       s.taboption('Advanced',L.cbi.InputValue, 'wifi5FragThreshold', {
           caption: L.tr('Fragment Threshold'), 
 		}).depends({'Advanced':'1'});
		  
	   //s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5IgmpSnEnable', {
           //caption: L.tr('IGMP Snooping'), 
 		//}).depends({'Advanced':'1'});
		 
	   s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5HT_STBC', {
           caption: L.tr('STBC'), 
 		}).depends({'Advanced':'1'});
		  
	   s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5HT_LDPC', {
           caption: L.tr('HT LDPC'), 
 		}).depends({'Advanced':'1'});
 		
	   s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5VHT_STBC', {
           caption: L.tr('VHT STBC'), 
 		}).depends({'Advanced':'1'});
		  
	   s.taboption('Advanced',L.cbi.CheckboxValue, 'wifi5VHT_LDPC', {
           caption: L.tr('VHT LDPC'), 
 		}).depends({'Advanced':'1'});
		
        s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
    }
});
