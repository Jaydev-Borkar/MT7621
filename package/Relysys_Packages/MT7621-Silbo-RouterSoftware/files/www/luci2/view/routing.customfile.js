L.ui.view.extend({
    title: L.tr('Dynamic Routing Custom File Upload'),
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
    

	handleArchiveUpload : function() {
        var self = this;  
        L.ui.upload(
            L.tr('File Upload'),
            L.tr('Select the file and click on "%s" button to proceed.').format(L.tr('Apply')), {
				filename: '/etc/frr/frr.conf',
				//filename: '/tmp/testttt.txt',
			    success: function(info) {
		          self.handleArchiveVerify(info);
		        }
			}
	    );
	},
	
	handleArchiveVerify : function(info)
	{
		var self = this;
              var archive=$('[name=filename]').val();
        
       // if((checksumval == info.checksum) &&(sizeval == info.size)) {
			L.ui.loading(true);
            //self.TestArchive(archive).then(function(TestArchiveOutput) {
				
				//self.updatenmsconfig('configure').then(function(rv) {
				               
                //});
			    
		    	L.ui.dialog(
						L.tr('File'), [
						$('<p />').text(L.tr('Success')),
						$('<pre />')
						.addClass('alert-success')
						.text("file uploaded successfully")	
					],{
							style: 'close',
							
						}
			    );
				L.ui.loading(false);   
		    //});    
	},

  
    execute:function()
    {
		
	
    var self = this;
          
    var m = new L.cbi.Map('routingcustomfile', {       
		
                });
         
        
    var s = m.section(L.cbi.NamedSection, 'uploadfile', {
        caption:L.tr(''),
    });
        
       
      s.option(L.cbi.CheckboxValue, 'upload_custom_file', {
              caption:        L.tr('Upload Custom File'),    
              optional: true     
            });   
       
    s.option(L.cbi.ButtonValue, 'upload', {
              caption:        L.tr('Upload Configuration'),
              label: 		  L.tr("Upload"),  
			  
            }).on('click', function() {
				self.handleArchiveUpload();        
            }).depends({'upload_custom_file':'1'});
			 
			 
   m.insertInto('#section_routing_general');  
   
  
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
               //L.ui.loading(false);
        });

	  
    }
});


