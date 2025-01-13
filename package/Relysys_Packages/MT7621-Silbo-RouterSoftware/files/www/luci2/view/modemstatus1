L.ui.view.extend({

    title: L.tr('Modem Status'),
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
        object: 'rpc-updatemodemstatus',
        method: 'configure',
        expect: { output: '' }
    }),
  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('modemstatus', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'modemstatus', {
            caption:L.tr('Modem')
        });
        
        
//#################################################################################################################
 // 
 // 					Modem Status
 //
 // ##################################################################################################################                
	  
        s.tab({
            id: 'modemstatus1',
            caption: L.tr('Modem Status 1')
        });
        
	s.taboption('modemstatus1',L.cbi.DummyValue, 'status1', {
	caption: L.tr(''),
		}).depends({'modemstatus1':'1'})
		.ucivalue=function()
			{
			var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem Status </b> </h3>";
			return id;
			};   
				
	s.taboption('modemstatus1',L.cbi.DummyValue, 'Operator', {
		caption: L.tr('Network Operator'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'Connected', {
		caption: L.tr('Network Technology'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'MODE', {
		caption: L.tr('Network Mode'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'MCC', {
		caption: L.tr('Mobile Country Code'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'MNC', {
		caption: L.tr('Mobile Network Code'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'LAC', {
		caption: L.tr('Location Area Code'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'CELLID', {
		caption: L.tr('Cell ID'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'BSIC', {
		caption: L.tr('BSIC / PCI'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'ARFCN', {
		caption: L.tr('RF Channel Number'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'BAND', {
		caption: L.tr('Frequency Band'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'ULBAND', {
		caption: L.tr('Upload Bandwidth'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'DLBAND', {
		caption: L.tr('Download Bandwidth'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'TAC', {
		caption: L.tr('Tracking Area Code'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'RSRP', {
		caption: L.tr('Reference Signal Received Power (dBm)'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'RSRQ', {
		caption: L.tr('Reference Signal Received Quality (dBm)'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'RSSI', {
		caption: L.tr('Received signal strength indication (dB)'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	
	s.taboption('modemstatus1',L.cbi.DummyValue, 'SINR', {
		caption: L.tr('Signal to Noise Ratio (dB)'),
	}).depends({'modemstatus1':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
	//modemstatus2	  
	s.tab({
		id: 'modemstatus2',
		caption: L.tr('Modem Status 2')
	});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'status2', {
		caption: L.tr(''),
	}).depends({'modemstatus2':'1'})
		.ucivalue=function()
	{
		var id="<h3><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspModem Status </b> </h3>";
		return id;
	};   

	s.taboption('modemstatus2',L.cbi.DummyValue, 'Operator2', {
		caption: L.tr('Network Operator'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'Connected2', {
		caption: L.tr('Network Technology'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'MODE2', {
		caption: L.tr('Network Mode'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'MCC2', {
		caption: L.tr('Mobile Country Code'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'MNC2', {
		caption: L.tr('Mobile Network Code'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'LAC2', {
		caption: L.tr('Location Area Code'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'CELLID2', {
		caption: L.tr('Cell ID'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'BSIC2', {
		caption: L.tr('BSIC / PCI'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'ARFCN2', {
		caption: L.tr('RF Channel Number'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'BAND2', {
		caption: L.tr('Frequency Band'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'ULBAND2', {
		caption: L.tr('Upload Bandwidth'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'DLBAND2', {
		caption: L.tr('Download Bandwidth'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'TAC2', {
		caption: L.tr('Tracking Area Code'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'RSRP2', {
		caption: L.tr('Reference Signal Received Power (dBm)'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'RSRQ2', {
		caption: L.tr('Reference Signal Received Quality (dBm)'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'RSSI2', {
		caption: L.tr('Received signal strength indication (dB)'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});

	s.taboption('modemstatus2',L.cbi.DummyValue, 'SINR2', {
		caption: L.tr('Signal to Noise Ratio (dB)'),
	}).depends({'modemstatus2':'1'})
	.depends({'CellularOperationMode' : 'dualcellularsinglesim'})
	.depends({'CellularOperationMode' : 'singlecellulardualsim'});
 
         
        		
        s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
    }
});

