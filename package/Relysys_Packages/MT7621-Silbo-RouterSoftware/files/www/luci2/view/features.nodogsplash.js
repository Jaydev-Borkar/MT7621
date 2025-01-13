L.ui.view.extend({

    title: L.tr('Captive Portal'),
      RunUdev:L.rpc.declare({
        object:'command',
        method:'exec',
        params : ['command','args'],
    }),
    
    
     fGetUCISections: L.rpc.declare({
        object: 'uci',
        method: 'get',
       // params: [ 'config', 'type', 'section']  
              params: [ 'config', 'type']  
       
    }),

 updateinterfaceconfig: L.rpc.declare({
        object: 'rpc-nodogsplash',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
    }),    
        
	handleBackupDownload: function() {
          var form = $('#btn_backup').parent();
      
          form.find('[name=sessionid]').val(L.globals.sid);
          form.submit();
        },
        

  
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('nodogsplash', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'nodogsplash', {
            caption:L.tr('')
        });
        
        
        s.option(L.cbi.CheckboxValue, 'enabled', {
                            caption: L.tr('Enable Captive Portal'),
                            optional: true
                  }); 
                  
         s.option(L.cbi.Ifname_List, 'gatewayinterface', {
                    caption: L.tr('Interface'),
					labelName: 'device',
                  }).depends({'enable':'1'});
		
		 s.option(L.cbi.CheckboxValue, 'enable_internet', {
                            caption: L.tr('Captive Portal with Internet'),
                            optional: true
                  }); 
                  
         //s.option(L.cbi.InputValue, 'serveripaddr', {
                    //caption: L.tr('Server IP Address'),
                  //}).depends({'enable':'1'});
                  
		 s.option(L.cbi.InputValue, 'gatewayport', {
                    caption: L.tr('Port'),
                    placeholder: '2050',
                  }).depends({'enable':'1'});
                  
         s.option(L.cbi.InputValue, 'sessiontimeout', {
                    caption: L.tr('Session Timeout (in min)'),
                    optional: true
                  }).depends({'enable':'1'});
          
          s.option(L.cbi.InputValue, 'authidletimeout', {
                    caption: L.tr('Authentication Idle Timeout (in min)'),
                    optional: true
                  }).depends({'enable':'1'});
                  
         s.option(L.cbi.InputValue, 'preauthidletimeout', {
                    caption: L.tr('Pre-Authentication Idle Timeout (in min)'),
                    optional: true
                  }).depends({'enable':'1'});
           
            var s = m.section(L.cbi.NamedSection, 'nodogsplash', {
            caption:L.tr('Web Redirection Interface Settings')
        });
                          
          s.option(L.cbi.CheckboxValue, 'redirect_enabled', {
                    caption: L.tr('Redirect Status'),
                    optional: true
                  });
                           
          s.option(L.cbi.InputValue, 'redirect_url', {
                    caption: L.tr('Redirect URL'),
                    placeholder: 'http://192.168.11.1',
                    optional: true
                  }).depends({'redirect_enabled':'1'});
                          
         //s.option(L.cbi.ListValue, 'snmpIP', {
                     //caption: L.tr('IP Family'),
                   //}).depends({'enablesnmp':'1'})
                    //// .value("none",L.tr("Choose Option"))
                    //.value('IPV4', L.tr('IPV4')); 

          ////s.option(L.cbi.InputValue, 'portagent', {
                    ////caption: L.tr('Port'),
                      ////placeholder: '161',
                    ////}).depends({'enablesnmp':'1'});
			
		  //s.option(L.cbi.DummyValue, 'portagent', {
                    //caption: L.tr('Port'),
                    //}).depends({'enablesnmp':'1'});
                    
          //// s.option(L.cbi.ListValue, 'Systemoid', {
          ////           caption: L.tr('System OID'),
          ////           }).depends({'enablesnmp':'1'})
          ////           .value('1.3.5.2.4.113815', L.tr('1.3.5.2.4.113815')); 

          //s.option(L.cbi.DummyValue, 'Systemoid', {
                      //caption: L.tr('System OID'),
                   //}).depends({'enablesnmp':'1'})
                           

          //s.option(L.cbi.InputValue, 'name', {
                    //caption: L.tr('Name'),
                    //placeholder: 'Silbo Router',
                  //}).depends({'enablesnmp':'1'});

          //s.option(L.cbi.InputValue, 'contact', {
                         //caption: L.tr('Contact'),
                         //placeholder: 'support@silbo.com',
                       //}).depends({'enablesnmp':'1'});

          //s.option(L.cbi.InputValue, 'location', {
                   //caption: L.tr('Location'),
                   //placeholder: 'Bangalore',
                  //}).depends({'enablesnmp':'1'});
                
           //s.option(L.cbi.CheckboxValue, 'version1', {
                   //caption: L.tr('Version-1'),
                   //optional: true
                 //}).depends({'enablesnmp':'1'});

           //s.option(L.cbi.CheckboxValue, 'version2', {
                   //caption: L.tr('Version-2'),
                   //optional: true
                 //}).depends({'enablesnmp':'1'});


           //s.option(L.cbi.CheckboxValue, 'version3', {
                   //caption: L.tr('Version-3'),
                   //optional: true
                 //}).depends({'enablesnmp':'1'});

                 //s.option(L.cbi.ListValue, 'snmpsecurity', {
                  //caption: L.tr('Security'),
                //}).depends({'version3' : '1','enablesnmp':'1'})
                  //.value("none",L.tr("Choose Option"))
                 //.value('NoAuthNoPriv', L.tr('NoAuthNoPriv')) 
                 //.value('AuthNoPriv', L.tr('AuthNoPriv'))
                 //.value('AuthPriv', L.tr('AuthPriv'));

                

           //s.option(L.cbi.InputValue, 'username', {
                   //caption: L.tr('User Name'),
                   //placeholder: 'admin',
                 //}).depends({'snmpsecurity' : 'NoAuthNoPriv','version3' : '1','enablesnmp':'1'})
                   //.depends({'snmpsecurity' : 'AuthNoPriv','version3' : '1','enablesnmp':'1'})
                   //.depends({'snmpsecurity' : 'AuthPriv','version3' : '1','enablesnmp':'1'});


            //s.option(L.cbi.InputValue, 'authenticationpassword', {
                          //caption: L.tr('Authentication Password:'),
                          //placeholder: 'Authentication Password',
                        //}) 
                        //.depends({'snmpsecurity' : 'AuthNoPriv','version3' : '1','enablesnmp':'1'})
                        //.depends({'snmpsecurity' : 'AuthPriv','version3' : '1','enablesnmp':'1'});

		 //s.option(L.cbi.InputValue, 'privacypassword', {       
                          //caption: L.tr('Privacy Password:'),                              
                          //placeholder: 'Privacy Password',                             
                        //}).depends({'snmpsecurity':'AuthPriv','version3' : '1','enablesnmp':'1'});      
                  
       $('#btn_backup').click(function() { self.handleBackupDownload(); });
  
                     
  s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
        
   }     

});




