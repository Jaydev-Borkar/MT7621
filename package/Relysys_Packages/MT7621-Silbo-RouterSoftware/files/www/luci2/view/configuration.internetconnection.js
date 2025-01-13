L.ui.view.extend({
  title: L.tr('Multi-Wan Configuration'),
  //description: L.tr('Please update after editing or deleting any changes.'),

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

  updategeneralconfig: L.rpc.declare({
    object: 'rpc-validatepriority',
    method: 'configure',
    expect: { output: '' }
  }),

  updatefailoverconfig: L.rpc.declare({
    object: 'rpc-validatepriority',
    method: 'configure',
    expect: { output: '' }
  }),
  deletefailoverconfig: L.rpc.declare({
    object: 'rpc-validatepriority',
    method: 'delete',
    params: ['FailoverConfigSectionName'],
    expect: { output: '' }
  }),

  updateloadbalanceconfig: L.rpc.declare({
    object: 'rpc-validatepriority',
    method: 'configure',
    expect: { output: '' }
  }),

  deleteloadbalanceconfig: L.rpc.declare({
    object: 'rpc-validatepriority',
    method: 'delete',
    params: ['LoadBalanceConfigSectionName'],
    expect: { output: '' }
  }),
  fGetUCISections: L.rpc.declare({
    object: 'uci',
    method: 'get',
    params: ['config', 'type'],
    expect: { values: {} }
  }),

  fDeleteUCISection: L.rpc.declare({
    object: 'uci',
    method: 'delete',
    params: ['config', 'type', 'section']
  }),

  fCommitUCISection: L.rpc.declare({
    object: 'uci',
    method: 'commit',
    params: ['config']
  }),

  updatefirewallconfig: L.rpc.declare({
    object: 'rpc-updatemwan3status',
    method: 'configure',
    expect: { output: '' }
  }),

  fCreateForm: function (mapwidget, fSectionID, fSectionType) {
    var self = this;

    if (!mapwidget)
      mapwidget = L.cbi.Map;

    if (fSectionType == "Dredirect") {
      var FormContent = self.pfCreateFormCallback;
      //~ alert("create form");
    }

    var map = new mapwidget('mwan3statusconfig', {
      prepare: FormContent,
      fSection: fSectionID
    });
    //~ alert("after create form");
    return map;
  },
  fSectionEdit: function (ev) {
    var self = ev.data.self;
    var fSectionID = ev.data.fSectionID;
    //alert(ev.data.fSectionID);
    var fSectionType = ev.data.fSectionType;
    //location.reload();

    return self.fCreateForm(L.cbi.Modal, fSectionID, fSectionType).show();
    location.reload();

  },

  pfCreateFormCallback: function () {
    var map = this;
    var pfSectionID = map.options.fSection;

    map.options.caption = L.tr('Configuration');

    var s = map.section(L.cbi.NamedSection, pfSectionID, {
      collabsible: true,
      anonymous: true,
      tabbed: true
    });

    s.option(L.cbi.DummyValue, 'name', {
      caption: L.tr('Name')
    });

    s.option(L.cbi.ComboBox, 'wanpriority', {
      caption: L.tr('Priority'),
      optional: 'true'
    }).value("1", L.tr('1'))
      .value("2", L.tr('2'))
      .value("3", L.tr('3'));

    s.option(L.cbi.InputValue, 'trackIp1', {
      caption: L.tr('TrackIP1'),
      placeholder: '8.8.8.8',
    });

    s.option(L.cbi.InputValue, 'trackIp2', {
      caption: L.tr('TrackIP2'),
      placeholder: '8.8.8.8',
    });

    s.option(L.cbi.InputValue, 'trackIp3', {
      caption: L.tr('TrackIP3'),
      placeholder: '8.8.8.8',
    });

    s.option(L.cbi.InputValue, 'trackIp4', {
      caption: L.tr('TrackIP4'),
      placeholder: '8.8.8.8',
    });


  },

  FailoverFormCallback: function () {
    var map = this;
    var FailoverConfigSectionName = map.options.FailoverConfigSection;
    var numericExpression = /^[0-9]+$/;

    map.options.caption = L.tr(FailoverConfigSectionName + ' Configuration');

    var s = map.section(L.cbi.NamedSection, FailoverConfigSectionName, {
      collabsible: true
    });

    s.option(L.cbi.DummyValue, 'connectionsettings', {
      caption: L.tr(''),
      //  caption: L.tr(a),
   }).ucivalue = function () {
      var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspFailover Configuration Settings </b> </h3>";
      return id;
   };


    s.option(L.cbi.DummyValue, 'name', {
    caption:     L.tr('Interface Name')
    });

    s.option(L.cbi.ComboBox, 'wanpriority', {
      caption: L.tr('Priority'),
      optional: 'true'
    }).value("1", L.tr('1'))
      .value("2", L.tr('2'))
      .value("3", L.tr('3'));
	
	s.option(L.cbi.ListValue, 'track_method', {
                        caption: L.tr('Track Method')
                }).value("ping",L.tr("Ping"))
	              .value("httping",L.tr("HTTP Ping"));
	              
	 s.option(L.cbi.CheckboxValue, 'flush_conntrack', {
           caption: L.tr('Flush conntrack'),
           optional: true
        });  
    // Conditionally hide 'initial_state' checkbox
if (!/^CWAN\d+(_\d+)?$/.test(FailoverConfigSectionName)) {
  s.option(L.cbi.CheckboxValue, 'initial_state', {
      caption: L.tr('Initial State Offline'),
      optional: true
  });
}

                    
    s.option(L.cbi.ListValue, 'validtrackip', {
      caption: L.tr('Select Track IP Numbers')
    }).value("0", L.tr("Please select the option"))
      .value("1", L.tr("1"))
      .value("2", L.tr("2"))
      .value("3", L.tr("3"))
      .value("4", L.tr("4"));

    s.option(L.cbi.InputValue, 'trackIp1', {
      caption: L.tr('TrackIP1'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '1' })
      .depends({ 'validtrackip': '2' })
      .depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s.option(L.cbi.InputValue, 'trackIp2', {
      caption: L.tr('TrackIP2'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '2' })
      .depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s.option(L.cbi.InputValue, 'trackIp3', {
      caption: L.tr('TrackIP3'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s.option(L.cbi.InputValue, 'trackIp4', {
      caption: L.tr('TrackIP4'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '4' });


    s.option(L.cbi.InputValue, 'reliability', {
      caption: L.tr('Reliability'),
      datatype: 'integer',
    });


    s.option(L.cbi.InputValue, 'count', {
      caption: L.tr('Count'),
      datatype: 'integer',
    });


    s.option(L.cbi.InputValue, 'up', {
      caption: L.tr('Up'),
      datatype: 'integer',
    });


    s.option(L.cbi.InputValue, 'down', {
      caption: L.tr('Down'),
      datatype: 'integer',
    });

  },


  LoadBalancingFormCallback: function () {
    var map = this;
    var LoadBalanceConfigSectionName = map.options.LoadBalanceConfigSection;
    var numericExpression = /^[0-9]+$/;

    map.options.caption = L.tr(LoadBalanceConfigSectionName + ' Configuration');

    var s1 = map.section(L.cbi.NamedSection, LoadBalanceConfigSectionName, {
      collabsible: true
    });


    s1.option(L.cbi.DummyValue, 'connectionsettings', {
      caption: L.tr(''),
      //  caption: L.tr(a),
   }).ucivalue = function () {
      var id = "<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbspLoad Balancing Configuration Settings</b></h3>";
      return id;
   };

    s1.option(L.cbi.DummyValue, 'name', {
    caption:     L.tr('Interface Name')
    });

    s1.option(L.cbi.InputValue, 'wanweight', {
      caption: L.tr('Traffic Distribution Ratio'),
    });
	
	s1.option(L.cbi.ListValue, 'track_method', {
                        caption: L.tr('Track Method')
                }).value("ping",L.tr("Ping"))
	              .value("httping",L.tr("HTTP Ping"));
	              
	s1.option(L.cbi.CheckboxValue, 'flush_conntrack', {
           caption: L.tr('Flush conntrack'),
           optional: true
        });
  // Conditionally hide 'initial_state' checkbox
if (!/^CWAN\d+(_\d+)?$/.test(LoadBalanceConfigSectionName)) {
  s1.option(L.cbi.CheckboxValue, 'initial_state', {
      caption: L.tr('Initial State Offline'),
      optional: true
  });
}

        
    s1.option(L.cbi.ListValue, 'validtrackip', {
      caption: L.tr('Select Track IP Numbers')
    }).value("0", L.tr("Please select the option"))
      .value("1", L.tr("1"))
      .value("2", L.tr("2"))
      .value("3", L.tr("3"))
      .value("4", L.tr("4"));

    s1.option(L.cbi.InputValue, 'trackIp1', {
      caption: L.tr('TrackIP1'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '1' })
      .depends({ 'validtrackip': '2' })
      .depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s1.option(L.cbi.InputValue, 'trackIp2', {
      caption: L.tr('TrackIP2'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '2' })
      .depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s1.option(L.cbi.InputValue, 'trackIp3', {
      caption: L.tr('TrackIP3'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '3' })
      .depends({ 'validtrackip': '4' });

    s1.option(L.cbi.InputValue, 'trackIp4', {
      caption: L.tr('TrackIP4'),
      placeholder: '8.8.8.8',
      optional: true,
    }).depends({ 'validtrackip': '4' });


    s1.option(L.cbi.InputValue, 'reliability', {
      caption: L.tr('Reliability'),
      datatype: 'integer',
    });


    s1.option(L.cbi.InputValue, 'count', {
      caption: L.tr('Count'),
      datatype: 'integer',
    });


    s1.option(L.cbi.InputValue, 'up', {
      caption: L.tr('Up'),
      datatype: 'integer',
    });


    s1.option(L.cbi.InputValue, 'down', {
      caption: L.tr('Down'),
      datatype: 'integer',
    });

  },

  FailoverConfigCreateForm: function (mapwidget, FailoverConfigSectionName) {
    var self = this;

    if (!mapwidget)
      mapwidget = L.cbi.Map;

    var map = new mapwidget('mwan3config', {
      prepare: self.FailoverFormCallback,
      FailoverConfigSection: FailoverConfigSectionName
    });
    return map;
  },

  LoadBalanceConfigCreateForm: function (mapwidget, LoadBalanceConfigSectionName) {
    var self = this;

    if (!mapwidget)
      mapwidget = L.cbi.Map;

    var map = new mapwidget('mwan3config', {
      prepare: self.LoadBalancingFormCallback,
      LoadBalanceConfigSection: LoadBalanceConfigSectionName
    });
    return map;
  },
  pfRenderContents: function (rv) {
    var self = this;

    var list = new L.ui.table({
      columns: [{
        caption: L.tr('Interface'),
        width: '20%',
        align: 'left',
        format: function (v, n) {
          var div = $('<p />').attr('id', 'pfName_%s'.format(n));
          return div.append('<strong>' + v + '</strong>');
        }
      },


      {
        caption: L.tr('Interface Status'),
        width: '20%',
        align: 'left',
        format: function (v, n) {
          var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
          return div.append(v);
        }
      },
      {
        caption: L.tr('Internet Status'),
        width: '20%',
        align: 'left',
        format: function (v, n) {
          var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
          return div.append(v);
        }
      },

      {
        caption: L.tr('Tracking Status'),
        width: '20%',
        align: 'left',
        format: function (v, n) {
          var div = $('<p />').attr('id', 'pfForwardTo_%s'.format(n));
          return div.append('<strong>' + v + '</strong>');
        }
      },


      ]
    });

    for (var key in rv) {
      if (rv.hasOwnProperty(key)) {
        var obj = rv[key];
        var name = obj.name;
        var interfacestatus = obj.interface_status;
        var internetstatus = obj.internet_status;
        var trackingstatus = obj.trackingstatus;

        var Interfacestatus;

        if (interfacestatus === "online") {
          Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #90EE90; border-left: 7px solid green; padding-left: 9px; width: 74px;">
					<b>Online</b><br />
					</div>`;
        }
        else if (interfacestatus === "offline") {
          Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
					<b>Offline</b><br />
					</div>`;
        }
        else if (interfacestatus === "error") {
          Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #ffbc41; border-left: 7px solid #ffbc41; padding-left: 9px; width: 74px;">
					<b>Error</b><br />
					</div>`;
        }
        else if (interfacestatus === "disabled") {
					Interfacestatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
					<b>Disabled</b><br />
					</div>`;
				}
        var Internetstatus;

        if (internetstatus === "online") {
          Internetstatus = `<div style="border-radius: 5px; border: 2px solid #90EE90; border-left: 7px solid green; padding-left: 9px; width: 74px;">
					<b>Online</b><br />
					</div>`;
        }
        else if (internetstatus === "offline") {
          Internetstatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
					<b>Offline</b><br />
					</div>`;
        }
        else if (internetstatus === "error") {
          Internetstatus = `<div style="border-radius: 5px; border: 2px solid #ffbc41; border-left: 7px solid #ffbc41; padding-left: 9px; width: 74px;">
					<b>Error</b><br />
					</div>`;
        }
        else if (internetstatus === "disabled") {
					Internetstatus = `<div style="border-radius: 5px; border: 2px solid #FF6B6B; border-left: 7px solid red; padding-left: 9px; width: 74px;">
					<b>Disabled</b><br />
					</div>`;
				}


        list.row([name, Interfacestatus, Internetstatus,trackingstatus, key]);


      }
    }

    $('#section_firewall_port').
      append(list.render());
  },



  FailoverRenderContents: function (rv) {
    configdata1 = function () {
      return rv;
    }

    var self = this;
    var list = new L.ui.table({
      columns: [
        {
          caption: L.tr('Interface Name'),
          width: '20%',
        align: 'left',
          format: function (v, n) {
            var div = $('<small />').attr('id', 'FailoverDeviceEventName_%s'.format(n));
            return div.append(v);
          }
        },

        {
          caption: L.tr('Priority'),
          width: '10%',
        align: 'left',
          format: function (v, n) {
            var div = $('<p />').attr('id', 'FailoverDeviceEventWanpriority_%s'.format(n));
            return div.append(v);
          }
        },

        {
          caption: L.tr('Enable/Disable'),
          width: '30%',
          align: 'center',
          format: function (v, n) {
            //alert(v)
            console.log(this.Enabled)
            var div = $('<label />').attr('id', 'FailoverDevice_%s'.format(n)).attr('class', 'switch');
            return div.append(`<input type="checkbox" ${v}   id="FailoverstatusSwitch${n}" onclick="changestatusfail(${n})">
  <span class="slider round"></span>`);

          }
        },

        {
          caption: L.tr('Update'),
          width: '40%',
          align: 'left',
          format: function (v, n) {
            return $('<div />')
              .addClass('btn-group btn-group-sm')
              .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Configure'))
                .click({ self: self, FailoverConfigSectionName: v }, self.FailoverConfigSectionEdit))
              .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                .click({ self: self, FailoverConfigSectionName: v }, self.FailoverConfigSectionRemove));

          }
        }]
    });

    for (var key in rv) {
      if (rv.hasOwnProperty(key)) {
        var obj = rv[key];
        var Name = obj.name
        var Wanpriority = obj.wanpriority
        var Enabled = obj.enabled

        if (Enabled == "1") {
          Enabled = "checked"
        }

        else {
          Enabled = ""
        }


        list.row([Name, Wanpriority, Enabled, key]);

      }
    }

    $('#section_internet_failover').append(list.render());

  },

  LoadBalancingRenderContents: function (rv) {
    configdata = function () {
      return rv;
    }


    var self = this;

    var list2 = new L.ui.table({
      columns: [
        {
          caption: L.tr('Interface Name'),
          width: '12%',
          align: 'left',
          format: function (v, n) {
            var div = $('<small />').attr('id', 'LoadBalanceDeviceEventName_%s'.format(n));
            return div.append(v);
          }
        },

        {
          caption: L.tr('Traffic Distribution Ratio(total sum must be 100)'),
          width: '40%',
          align: 'center',
          format: function (v, n) {
            var div = $('<p />').attr('id', 'LoadBalanceDeviceEventWeight_%s'.format(n));
            return div.append(v);
          }
        },


        {
          caption: L.tr('Enable/Disable'),
          width: '20%',
          align: 'center',
          format: function (v, n) {
            //alert(v)
            console.log(this.Enabled)
            var div = $('<label />').attr('id', 'LoadBalanceDevice_%s'.format(n)).attr('class', 'switch');
            return div.append(`<input type="checkbox" ${v}   id="PortforwardingstatusSwitch${n}" onclick="changestatus(${n})">
  <span class="slider round"></span>`);

          }
        },



        {
          caption: L.tr('Update'),
          width: '40%',
          align: 'left',
          format: function (v, n) {
            return $('<div />')
              .addClass('btn-group btn-group-sm')
              .append(L.ui.button(L.tr('Edit'), 'primary', L.tr('Configure'))
                .click({ self: self, LoadBalanceConfigSectionName: v }, self.LoadBalanceConfigSectionEdit))
              .append(L.ui.button(L.tr('Delete'), 'danger', L.tr('Delete Event'))
                .click({ self: self, LoadBalanceConfigSectionName: v }, self.LoadBalanceConfigSectionRemove));

          }
        }]
    });

    for (var key in rv) {
      if (rv.hasOwnProperty(key)) {
        var obj = rv[key];
        var Name = obj.name
        var Weight = obj.wanweight
        var Enabled = obj.enabled

        if (Enabled == "1") {
          Enabled = "checked"
        }

        else {
          Enabled = ""
        }


        list2.row([Name, Weight, Enabled, key])

      }
    }

    $('#section_internet_loadbalancing').append(list2.render());

  },


  FailoverConfigSectionAdd: function () {
    var self = this;
    var FailoverConfigSectionName = $('#field_failover_redirect_newRedirect_name').val();
    var FailoverConfigWanpriority = $('#field_failover_redirect_newRedirect_wanpriority').val();
    var FailoverConfigSection = { name: FailoverConfigSectionName, wanpriority: FailoverConfigWanpriority, enabled: "1" };

    self.RS485GetUCISections("mwan3config", "genericconfig").then(function (rv) {
      for (var key in rv) {
        if (rv.hasOwnProperty(key)) {
          var obj = rv[key];
          var Selection = obj.select;
          if (Selection == 'failover') {
            self.RS485CreateUCISection("mwan3config", "redirect", FailoverConfigSectionName, FailoverConfigSection).then(function (rv) {
              if (rv) {
                if (rv.section) {
                  self.RS485CommitUCISection("mwan3config").then(function (res) {

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
          else {
            alert("Cannot Add Configuration, Please select Failover in General Settings tab to Add");
          }
        }
      }
    });
  },


  LoadBalanceConfigSectionAdd: function () {
    var self = this;
    var LoadBalanceConfigSectionName = $('#field_loadbalancing_rule_newRule_name').val();
    var LoadBalanceConfigWeight = $('#field_loadbalancing_rule_newRule_weight').val();
    var LoadBalanceConfigSection = { name: LoadBalanceConfigSectionName, wanweight: LoadBalanceConfigWeight, enabled: "1" };

    self.RS485GetUCISections("mwan3config", "genericconfig").then(function (rv) {
      for (var key in rv) {
        if (rv.hasOwnProperty(key)) {
          var obj = rv[key];
          var Selection = obj.select;
          if (Selection == 'balanced') {
            self.RS485CreateUCISection("mwan3config", "redirect", LoadBalanceConfigSectionName, LoadBalanceConfigSection).then(function (rv) {
              if (rv) {
                if (rv.section) {
                  self.RS485CommitUCISection("mwan3config").then(function (res) {
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
          else {
            alert("Cannot Add Configuration, Please select Load Balancing in General Settings tab to Add");
          }
        }
      }
    });
  },


  FailoverConfigSectionRemove: function (ev) {
    var self = ev.data.self;
    var FailoverConfigSectionName = ev.data.FailoverConfigSectionName;
    L.ui.loading(true);
    self.RS485GetUCISections("mwan3config", "genericconfig").then(function (rv) {
      for (var key in rv) {
        if (rv.hasOwnProperty(key)) {
          var obj = rv[key];
          var Selection = obj.select;
          if (Selection == 'failover') {
            self.deletefailoverconfig(FailoverConfigSectionName).then(function (rv) {
              if (rv == 1) {
                alert("Cannot Delete CWAN1_0, CWAN1_1 and CWAN1");
              }
              else {
                self.RS485DeleteUCISection("mwan3config", "redirect", FailoverConfigSectionName).then(function (rv) {
                  if (rv == 0) {
                    self.RS485CommitUCISection("mwan3config").then(function (res) {
                      if (res != 0) {
                        alert("Error: Delete Configuration");
                        L.ui.loading(false);
                      }
                      else {
                        location.reload();
                        L.ui.loading(false);
                      }
                    });
                  };
                });
              }
            });
          }
          else {
            alert("Cannot Delete Configuration, Please select Failover in General Settings tab to delete");
          }
        }
      }
    });
  },

  LoadBalanceConfigSectionRemove: function (ev) {
    var self = ev.data.self;
    var LoadBalanceConfigSectionName = ev.data.LoadBalanceConfigSectionName;
    L.ui.loading(true);

    self.RS485GetUCISections("mwan3config", "genericconfig").then(function (rv) {
      for (var key in rv) {
        if (rv.hasOwnProperty(key)) {
          var obj = rv[key];
          var Selection = obj.select;
          if (Selection == 'balanced') {
            self.deleteloadbalanceconfig(LoadBalanceConfigSectionName).then(function (rv) {
              if (rv == 1) {
                alert("Cannot Delete CWAN1_0, CWAN1_1 and CWAN1");
              }
              else {
                self.RS485DeleteUCISection("mwan3config", "redirect", LoadBalanceConfigSectionName).then(function (rv) {
                  if (rv == 0) {
                    self.RS485CommitUCISection("mwan3config").then(function (res) {
                      if (res != 0) {
                        alert("Error: Delete Configuration");
                        L.ui.loading(false);
                      }
                      else {
                        location.reload();
                        L.ui.loading(false);
                      }
                    });
                  };
                });
              }
            });
          }
          else {
            alert("Cannot Delete Configuration, Please select Load Balancing in General Settings tab to delete");
          }
        }
      }
    });
  },

  FailoverConfigSectionEdit: function (ev) {
    var self = ev.data.self;
    var FailoverConfigSectionName = ev.data.FailoverConfigSectionName;
    return self.FailoverConfigCreateForm(L.cbi.Modal, FailoverConfigSectionName).show();
  },


  LoadBalanceConfigSectionEdit: function (ev) {
    var self = ev.data.self;
    var LoadBalanceConfigSectionName = ev.data.LoadBalanceConfigSectionName;
    return self.LoadBalanceConfigCreateForm(L.cbi.Modal, LoadBalanceConfigSectionName).show();
  },


  execute: function () {
    var self = this;
    var self = this;
    L.ui.loading(true);
    self.updatefirewallconfig().then(function (rv) {
      self.fGetUCISections("mwan3statusconfig", "redirect").then(function (rv) {

        self.pfRenderContents(rv);

      });

    });


    var m = new L.cbi.Map('mwan3config', {
    });

    var s = m.section(L.cbi.NamedSection, 'general', {
      caption: L.tr('General Configurations')
    });

    s.option(L.cbi.ListValue, 'select', {
      caption: L.tr('Choose')
      //     }).value("none", L.tr('None'))
    }).value("failover", L.tr('Failover'))
      .value("balanced", L.tr('Load Balancing'));


    m.insertInto('#section_internet_connection');


    $('#btn_internet_general_update').click(function () {
      L.ui.loading(true);
      self.updategeneralconfig('configure').then(function (rv) {
        //required to show loading unitil it gets updated
        L.ui.loading(false);
        L.ui.dialog(
          L.tr('update configuration'), [
          $('<pre />')
            .addClass('alert alert-success')
            .text(rv)
        ],

          { style: 'close' }
        );

      });

    });




    var self = this;

    $('#AddNewConnectionfailover').click(function () {
      self.FailoverConfigSectionAdd();
    });

    self.RS485GetUCISections("mwan3config", "redirect").then(function (rv) {
      self.FailoverRenderContents(rv);
    });

    $('#AddNewConnectionLoadBalancing').click(function () {
      self.LoadBalanceConfigSectionAdd();
    });
    self.RS485GetUCISections("mwan3config", "redirect").then(function (rv) {
      self.LoadBalancingRenderContents(rv);
    });


    $('#btn_internet_update').click(function () {
      L.ui.loading(true);
      self.updatefailoverconfig('configure').then(function (rv) {
        //required to show loading unitil it gets updated
        L.ui.loading(false);
        L.ui.dialog(
          L.tr('update configuration'), [
          $('<pre />')
            .addClass('alert alert-success')
            .text(rv)
        ],

          { style: 'close' }
        );

      });
      //L.ui.loading(false);
    });
    $('#AddNewPortForward').click(function () {

      L.ui.loading(true);
      self.updatefirewallconfig().then(function (rv) {
        L.ui.loading(false);
        L.ui.dialog(
          L.tr('Show Status'), [
          $('<pre />')
            .addClass('alert alert-success')
            .text(rv)

        ],

          {
            style: 'close',
            close: function () {
              location.reload();
            }
          }

        );


      });

    });

    $('#AddNewPortForward').show();





    changestatusfail = function (n) {
      var checkbox = $("#FailoverstatusSwitch" + n)[0].checked
      var faileditdata = configdata1();
      console.log(faileditdata)
      var failName = Object.keys(faileditdata)[n]
      console.log(failName)
      var failsensorSectionOptions = { enabled: "0" };
      console.log(checkbox);
      if (checkbox) {
        document.getElementById("FailoverstatusSwitch" + n).checked = true;
        failsensorSectionOptions = { enabled: "1" };
      }
      else {
        document.getElementById("FailoverstatusSwitch" + n).checked = false;
        failsensorSectionOptions = { enabled: "0" };
      }
      self.RS485CreateUCISection("mwan3config", "redirect", failName, failsensorSectionOptions).then(function (rv) {
        if (rv) {
          if (rv.section) {
            self.RS485CommitUCISection("mwan3config").then(function (res) {
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



    $('#btn_internet_loadbalance_update').click(function () {
      L.ui.loading(true);
      self.updateloadbalanceconfig('configure').then(function (rv) {
        //required to show loading unitil it gets updated
        L.ui.loading(false);
        L.ui.dialog(
          L.tr('update configuration'), [
          $('<pre />')
            .addClass('alert alert-success')
            .text(rv)
        ],

          { style: 'close' }
        );

      });

    });



    changestatus = function (n) {
      var checkbox = $("#PortforwardingstatusSwitch" + n)[0].checked
      var porteditdata = configdata();
      console.log(porteditdata)
      var portName = Object.keys(porteditdata)[n]
      console.log(portName)
      var sensorSectionOptions = { enabled: "0" };
      console.log(checkbox);
      if (checkbox) {
        document.getElementById("PortforwardingstatusSwitch" + n).checked = true;
        sensorSectionOptions = { enabled: "1" };
      }
      else {
        document.getElementById("PortforwardingstatusSwitch" + n).checked = false;
        sensorSectionOptions = { enabled: "0" };
      }
      self.RS485CreateUCISection("mwan3config", "redirect", portName, sensorSectionOptions).then(function (rv) {
        if (rv) {
          if (rv.section) {
            self.RS485CommitUCISection("mwan3config").then(function (res) {
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

    //$('#btn_internet_general_update').click(function() {
    //L.ui.loading(true);
    //self.updategeneralconfig('configure').then(function(rv) {
    //L.ui.dialog(
    //L.tr('update configuration'),[
    //$('<pre />')
    //.addClass('alert alert-success')
    //.text(rv)
    //],

    //{ style: 'close'}
    //);

    //});
    //L.ui.loading(false);
    //});




  }
});



