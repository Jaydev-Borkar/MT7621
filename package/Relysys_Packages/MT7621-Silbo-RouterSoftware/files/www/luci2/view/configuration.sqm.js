L.ui.view.extend({
        title: L.tr('SQM-Smart Queue Management'),
        description: L.tr(''),
        
        RS485GetUCISections: L.rpc.declare({
                object: 'uci',
                method: 'get',
                params: ['config', 'type'],
                expect: { values: {} }
        }),

        RS485CreateUCISection: L.rpc.declare({
                object: 'uci',
                method: 'add',
                params: ['config', 'type', 'name', 'values']
        }),

        RS485CommitUCISection: L.rpc.declare({
                object: 'uci',
                method: 'commit',
                params: ['config']
        }),

        RS485DeleteUCISection: L.rpc.declare({
                object: 'uci',
                method: 'delete',
                params: ['config', 'type', 'section']
        }),


        
        updatesmartsqm: L.rpc.declare({
                object: 'rpc-updatesqm',
                method: 'smartsqm',
                expect: { output: '' }
        }),

       


        smartsqmConfigCreateForm: function (mapwidget, smartsqmConfigSectionName) {
                var self = this;

                if (!mapwidget)
                        mapwidget = L.cbi.Map;

                var map = new mapwidget('sqm', {
                        prepare: self.smartsqmFormCallback,
                        smartsqmConfigSection: smartsqmConfigSectionName
                });
                return map;
        },

        smartsqmFormCallback: function () {
                var map = this;
                var smartsqmConfigSectionName = map.options.smartsqmConfigSection;
                //var numericExpression = /^[0-9]+$/;

                map.options.caption = L.tr(smartsqmConfigSectionName + ' Configuration');

                var s = map.section(L.cbi.NamedSection, smartsqmConfigSectionName, {
                        collabsible: true

                });

                 s.option(L.cbi.DummyValue, 'connectionsettings', {
                        caption: L.tr(''),
                        //  caption: L.tr(a),
                }).ucivalue = function () {
                                var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspSQM Connection settings </b> </h3>";
                                return id;
                        };

                        s.option(L.cbi.InterfaceList_ra, 'interface', {
                                caption: L.tr('Interface'),
                                optional: true
                        });



                        s.option(L.cbi.ListValue, 'qdisc', {
                                caption: L.tr('Queueing Discipline')
                        }).value("cake", L.tr('Cake'))
                         .value("fqcode", L.tr('fq_code'));


                         s.option(L.cbi.ListValue, 'script', {
                                caption: L.tr('Queue setup Script')
                        }).value("piece_of_cake.qos", L.tr('piece_of_cake.qos'))
                         .value("layer_cake.qos", L.tr('layer_Cake.qos'));


                         s.option(L.cbi.InputValue, 'upload', {
                                caption: L.tr('Upload speed (kbps)'),
                                 placeholder: '0000',
                                datatype: 'range(0000,100000)',
                              });

                         s.option(L.cbi.InputValue, 'download', {
                                caption: L.tr('Download speed (kbps)'),
                                placeholder: '0000',
                                datatype:'range(0000,100000)',
                                });

                                
                        },

        smartsqmRenderContents: function (rv) {

                configdata = function () {
                        return rv;
                    }

                var self = this;

                var list = new L.ui.table({
                        columns: [{
                                caption: L.tr('Name'),
                                //width: '12%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'smartsqmConfigSectionName_%s'.format(n));
                                        return div.append('<strong>' + v + '</strong>');
                                }
                        },
                        {
                                caption: L.tr('Interface Name'),
                                //width: '14%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'smartsqm_%s'.format(n));
                                        return div.append(v);
                                }
                        },


                        {
                                caption: L.tr('Download Speed'),
                                width: '14%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'smartsqm_%s'.format(n));
                                        return div.append(v);
                                }
                        },

                        {
                                caption: L.tr('Upload Speed'),
                                width: '16%',
                                align: 'left',
                                format: function (v, n) {
                                        var div = $('<p />').attr('id', 'smartsqm_%s'.format(n));
                                        return div.append(v);
                                }
                        },
                       
                        
                        {
                                caption: L.tr('Enable/Disable'),
                                //width: '14%',
                                align: 'center',
                                format: function (v, n) {
                                        
                                        console.log(this.Enabled)
                                        var div = $('<label />').attr('id', 'smartsqm_%s'.format(n)).attr('class', 'switch');
                                        return div.append(`<input type="checkbox" ${v}   id="smartsqmforwardingstatusSwitch${n}" onclick="smartsqmenablebutton(${n})">
  <span class="slider round"></span>`);
                                        
                                }
                                
                        },
                        {
                                caption: L.tr('Update'),
                                align: 'center',
                                format: function (v, n) {
                                        return $('<div />')
                                                .addClass('btn-group btn-group-sm')

                                                .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('smartsqm'))
                                                        .click({ self: self, smartsqmConfigSectionName: v }, self.smartsqmConfigSectionEdit))
                                                .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                                                        .click({ self: self, smartsqmConfigSectionName: v }, self.smartsqmConfigSectionRemove));
                                }
                        }]
                });

              
                for (var key in rv) {
                        if (rv.hasOwnProperty(key)) {
                                var obj = rv[key];
                                console.log(obj);
                                var Name = obj.name
                                var interface = obj.interface;
                                var download = obj.download;
                                var upload = obj.upload;
                               // var qdisc = obj.qdisc;
                               // var script = obj.script;
                                
                                //var Status = obj.status
                                var Enabled = obj.enabled;

                                if (Enabled == "1") 
                                {
                                  Enabled = "checked"
                                }
  
                                else 
                                {
                                  Enabled = ""
                                }

                                list.row([Name,interface,download,upload,Enabled,key]);
                        }
                }


                $('#section_vpn_smartsqm').append(list.render());

        },      

        smartsqmConfigSectionAdd: function () {
                var self = this;
                
                var smartsqmConfigSectionName = $('#field_firewall_rule2').val();

            
                var smartsqmConfigSection = { name: smartsqmConfigSectionName ,enabled: '1' };

               
                
                this.RS485GetUCISections("sqm", "queue", smartsqmConfigSection).then(function (rv) {
                        var keys = Object.keys(rv);
                        
                        var keysLength = keys.length;
                        if (keysLength >= 7) {
                                alert("Only 7 connections can be configured");
                        }
                        else {
                                self.RS485CreateUCISection("sqm", "queue", smartsqmConfigSectionName ,smartsqmConfigSection).then(function (rv) {
                                        if (rv) {
                                                if (rv.section) {
                                                        self.RS485CommitUCISection("sqm").then(function (res) {
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
                });
        },
      
        smartsqmConfigSectionRemove: function (ev) {
        var self = ev.data.self;
        var smartsqmConfigSectionName = ev.data.smartsqmConfigSectionName;

        //self.RS485DeleteUCISection("vpnconfig1","RS485Config",RS485ConfigSectionName).then(function(rv){
        //self.deletewireguardconfig(wireguardConfigSectionName).then(function() {

        self.RS485DeleteUCISection("sqm", "queue", smartsqmConfigSectionName).then(function (rv) {
                if (rv == 0) {
                        self.RS485CommitUCISection("sqm").then(function (res) {
                                if (res != 0) {
                                        alert("Error: Delete Configuration");
                                }
                                else {
                                        location.reload();
                                }
                        });
                };
        });

},


        smartsqmConfigSectionEdit: function (ev) {
                var self = ev.data.self;
                var smartsqmConfigSectionName = ev.data.smartsqmConfigSectionName;
                return self.smartsqmConfigCreateForm(L.cbi.Modal, smartsqmConfigSectionName).show();
        },



        execute: function () {

                var self = this;

              

                 //zerotier
                 $('#AddNewconnectionsmartsqm').click(function () {
                        self.smartsqmConfigSectionAdd();
                });
                self.RS485GetUCISections("sqm", "queue").then(function (rv) {
                        self.smartsqmRenderContents(rv);
                });




        $('#update_smartsqm').click(function () {
                L.ui.loading(true);
                self.updatesmartsqm().then(function (rv) {
                        //alert(rv);
                        // L.ui.loading(false);
                        L.ui.dialog(
                                L.tr('update configuration'), [
                                $('<pre />')
                                        .addClass('alert alert-success')
                                        .text(rv)
                        ],

                                { style: 'close' }
                        );

                        L.ui.loading(false);

                });
                
        });


        smartsqmenablebutton=function (n) {
                var checkbox = $("#smartsqmforwardingstatusSwitch" + n)[0].checked
                var faileditdata = configdata();
                var failName=Object.keys(faileditdata)[n] 
                var failsensorSectionOptions = { enabled: "0" };
                  console.log(checkbox);
                if (checkbox) {
                    document.getElementById("smartsqmforwardingstatusSwitch"+n).checked = true;
                     failsensorSectionOptions = { enabled: "1" };
                }
                else {
                    document.getElementById("smartsqmforwardingstatusSwitch"+n).checked = false;
                    failsensorSectionOptions = { enabled: "0" };
                }
                self.RS485CreateUCISection("sqm", "queue",failName,failsensorSectionOptions).then(function (rv) {
                    if (rv) {
                        if (rv.section) {
                            self.RS485CommitUCISection("sqm").then(function (res) {
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





