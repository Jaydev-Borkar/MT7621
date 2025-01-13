L.ui.view.extend({

    title: L.tr('Wifi 6 Configuration'),
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
        object: 'rpc-updateWifiConfig',
        method: 'configure',
        params: ['application','action'],
        expect: { output: '' }
    }),
  // wificonfig is the uci file for wifi 6 config 
    execute:function() {
        var self = this;
        var m = new L.cbi.Map('wificonfig', {
        });
        
        var s = m.section(L.cbi.NamedSection, 'wificonfig', {
            caption:L.tr('Wifi settings')
        });
        
  //   2.4GHZ starts from here       
         s.tab({
            id: 'twogigaconfig',
            caption: L.tr('2.4GHZ')
        });
       
        //Wifi Devices
        
        s.taboption('twogigaconfig', L.cbi.ListValue, 'wifi1protocol2_4ghz', {
		caption:	L.tr('Radio 0 Protocol'),
		}).depends({'twogigaconfig':'1'})
		.value('none', L.tr('Please choose'))
		.value('IEEE802.11b/g/n', L.tr('IEEE 802.11 b/g/n'));
        
          
         s.taboption('twogigaconfig', L.cbi.ListValue, 'CountryCode2_4ghz', {
		caption:	L.tr('Country Code'),
		}).depends({'twogigaconfig':'1'})
		.value('none', L.tr('Please choose'))
		.value('AF', L.tr('Afghanistan'))
        .value('AX', L.tr('Åland Islands'))
        .value('AL', L.tr('ALBANIA'))    
        .value('AS', L.tr('American Samoa'))  
        .value('AD', L.tr('Andorra'))  
        .value('AO', L.tr('Angola'))  
        .value('AI', L.tr('Anguilla')) 
        .value('AQ', L.tr('Antarctica')) 
        .value('AG', L.tr('Antigua and Barbuda')) 
        .value('AR', L.tr('ARGENTINA'))  
        .value('AM', L.tr('ARMENIA'))  
        .value('AW', L.tr('Aruba'))  
        .value('AU', L.tr('AUSTRALIA'))  
        .value('AT', L.tr('AUSTRIA'))  
        .value('AZ', L.tr('AZERBAIJAN'))  
        .value('BH', L.tr('BAHRAIN'))  
        .value('BD', L.tr('Bangladesh'))  
        .value('BB', L.tr('Barbados'))  
        .value('BY', L.tr('BELARUS'))  
        .value('BE', L.tr('BELGIUM'))  
        .value('BZ', L.tr('BELIZE'))  
        .value('BJ', L.tr('Benin'))  
        .value('BM', L.tr('Bermuda'))  
        .value('BT', L.tr('Bhutan'))  
        .value('BO', L.tr('BOLIVIA'))  
        .value('BQ', L.tr('Bonaire'))  
        .value('BQ', L.tr('Sint Eustatius'))  
        .value('BQ', L.tr('Saba'))  
        .value('BA', L.tr('Bosnia and Herzegovina'))  
        .value('BW', L.tr('Botswana'))  
        .value('BV', L.tr('Bouvet Island'))  
        .value('BR', L.tr('BRAZIL'))  
        .value('IO', L.tr('British Indian Ocean Territory'))  
        .value('BN', L.tr('BRUNEI DARUSSALAM'))  
        .value('BG', L.tr('BULGARIA'))  
        .value('BF', L.tr('Burkina Faso'))  
        .value('BI', L.tr('Burundi'))  
        .value('CV', L.tr('Cabo Verde'))  
        .value('KH', L.tr('Cambodia'))  
        .value('CM', L.tr('Cameroon'))  
        .value('CA', L.tr('CANADA'))  
        .value('KY', L.tr('Cayman Islands '))  
        .value('CF', L.tr('Central African Republic'))  
        .value('TD', L.tr('Chad'))  
        .value('CL', L.tr('CHILE'))  
        .value('CN', L.tr('CHINA'))  
        .value('CX', L.tr('Christmas Island'))  
        .value('CC', L.tr('Cocos (Keeling) Islands (the)'))  
        .value('CO', L.tr('COLOMBIA'))  
        .value('KM', L.tr('Comoros'))  
        .value('CD', L.tr('Congo(the Democratic Republic of the)'))  
        .value('CG', L.tr('Congo'))  
        .value('CK', L.tr('Cook Islands'))    
        .value('CR', L.tr('COSTA RICA'))  
        .value('CI', L.tr('Côte dIvoire'))  
        .value('HR', L.tr('CROATIA'))  
        .value('CU', L.tr('Cuba'))  
        .value('CW', L.tr('Curaçao'))  
        .value('CY', L.tr('CYPRUS'))  
        .value('CZ', L.tr('CZECH REPUBLIC'))  
        .value('DK', L.tr('DENMARK'))  
        .value('DJ', L.tr('Djibouti'))  
        .value('DM', L.tr('Dominica'))  
        .value('DO', L.tr('DOMINICAN REPUBLIC'))  
        .value('EC', L.tr('ECUADOR'))  
        .value('EG', L.tr('EGYPT'))  
        .value('SV', L.tr('EL SALVADOR'))  
        .value('GQ', L.tr('Equatorial Guinea'))  
        .value('ER', L.tr('Eritrea'))  
        .value('EE', L.tr('ESTONIA'))  
        .value('ET', L.tr('Ethiopia'))  
        .value('FK', L.tr('Falkland Islands'))  
        .value('FO', L.tr('Faroe Islands'))  
        .value('FJ', L.tr('Fiji'))  
        .value('FI', L.tr('FINLAND'))  
        .value('FR', L.tr('FRANCE'))  
        .value('GF', L.tr('French Guiana'))  
        .value('PF', L.tr('French Polynesia'))  
        .value('TF', L.tr('French Southern Territories'))  
        .value('GA', L.tr('Gabon'))  
        .value('GM', L.tr('Gambia'))  
        .value('GE', L.tr('GEORGIA'))  
        .value('DE', L.tr('GERMANY'))  
        .value('GH', L.tr('Ghana'))  
        .value('GI', L.tr('Gibraltar'))  
        .value('GR', L.tr('GREECE'))  
        .value('GL', L.tr('Greenland'))  
        .value('GD', L.tr('Grenada'))  
        .value('GP', L.tr('Guadeloupe'))  
        .value('GU', L.tr('Guam'))  
        .value('GT', L.tr('GUATEMALA'))  
        .value('GG', L.tr('Guernsey'))  
        .value('GW', L.tr('Guinea-Bissau'))  
        .value('GY', L.tr('Guyana'))  
        .value('HT', L.tr('Haiti'))  
        .value('HM', L.tr('Heard Island and McDonald Islands'))  
        .value('VA', L.tr('Holy See'))  
        .value('HN', L.tr('HONDURAS'))  
        .value('HK', L.tr('HONG KONG'))  
        .value('HU', L.tr('HUNGARY'))  
        .value('IS', L.tr('ICELAND'))  
        .value('IN', L.tr('INDIA'))  
        .value('ID', L.tr('INDONESIA'))  
        .value('IR', L.tr('IRAN'))  
        .value('IQ', L.tr('Iraq'))  
        .value('IE', L.tr('IRELAND'))  
        .value('IL', L.tr('ISRAEL'))  
        .value('IT', L.tr('ITALY'))  
        .value('JM', L.tr('Jamaica'))  
        .value('JP', L.tr('JAPAN'))  
        .value('JE', L.tr('Jersey'))  
        .value('JO', L.tr('JORDAN'))  
        .value('KZ', L.tr('KAZAKHSTAN'))  
        .value('KE', L.tr('Kenya'))  
        .value('KI', L.tr('Kiribati'))  
        .value('KP', L.tr('KOREA DEMOCRATIC'))  
        .value('KR', L.tr('REPUBLIC OF KOREA '))  
        .value('KW', L.tr('KUWAIT'))  
        .value('KG', L.tr('Kyrgyzstan'))  
        .value('LA', L.tr('Lao People Democratic Republic'))  
        .value('LV', L.tr('LATVIA'))  
        .value('LB', L.tr('LEBANON'))  
        .value('LS', L.tr('Lesotho'))  
        .value('LR', L.tr('Liberia'))  
        .value('LY', L.tr('Libya'))  
        .value('LI', L.tr('LIECHTENSTEIN'))  
        .value('LT', L.tr('LITHUANIA'))  
        .value('LU', L.tr('LUXEMBOURG'))  
        .value('MO', L.tr('MACAO'))  
        .value('MK', L.tr('MACEDONIA'))  
        .value('MG', L.tr('Madagascar'))  
        .value('MW', L.tr('Malawi'))  
        .value('MY', L.tr('MALAYSIA'))  
        .value('MV', L.tr('Maldives'))  
        .value('ML', L.tr('Mali'))  
        .value('MT', L.tr('Malta'))  
        .value('MH', L.tr('Marshall Islands'))  
        .value('MQ', L.tr('Martinique'))  
        .value('MR', L.tr('Mauritania'))  
        .value('MU', L.tr('Mauritius'))  
        .value('YT', L.tr('Mayotte'))  
        .value('MX', L.tr('MEXICO'))  
        .value('FM', L.tr('Micronesia'))  
        .value('MD', L.tr('Moldova'))  
        .value('MC', L.tr('MONACO'))  
        .value('MN', L.tr('Mongolia'))  
        .value('ME', L.tr('Montenegro'))  
        .value('MS', L.tr('Montserrat'))  
        .value('MA', L.tr('MOROCCO'))  
        .value('MZ', L.tr('Mozambique'))  
        .value('MM', L.tr('Myanmar'))  
        .value('NA', L.tr('Namibia'))  
        .value('NR', L.tr('Nauru'))  
        .value('NP', L.tr('Nepal'))  
        .value('NL', L.tr('NETHERLANDS'))  
        .value('NC', L.tr('New Caledonia '))  
        .value('NZ', L.tr('NEW ZEALAND'))   
        .value('NI', L.tr('Nicaragua'))  
        .value('NE', L.tr('Niger'))  
        .value('NG', L.tr('Nigeria'))  
        .value('NU', L.tr('Niue'))  
        .value('NF', L.tr('Norfolk Island'))  
        .value('MP', L.tr('Northern Mariana Islands'))  
        .value('NO', L.tr('NORWAY')) 
        .value('OM', L.tr('OMAN'))  
        .value('PK', L.tr('PAKISTAN'))  
        .value('PW', L.tr('Palau'))  
        .value('PS', L.tr('Palestine'))  
        .value('PA', L.tr('PANAMA'))  
        .value('PG', L.tr('Papua New Guinea'))  
        .value('PY', L.tr('Paraguay'))  
        .value('PE', L.tr('PERU'))  
        .value('PH', L.tr('PHILIPPINES'))  
        .value('PN', L.tr('Pitcairn'))  
        .value('PL', L.tr('POLAND'))  
        .value('PT', L.tr('PORTUGAL'))  
        .value('PR', L.tr('PUERTO RICO'))  
        .value('QA', L.tr('QATAR'))  
        .value('RE', L.tr('Réunion'))  
        .value('RO', L.tr('ROMANIA'))  
        .value('RU', L.tr('RUSSIA FEDERATION'))  
        .value('RW', L.tr('Rwanda'))  
        .value('BL', L.tr('Saint Barthélemy'))  
        .value('SH', L.tr('Saint Helena'))  
        .value('SH', L.tr('Ascension Island'))  
        .value('SH', L.tr('Tristan da Cunha'))  
        .value('KN', L.tr('Saint Kitts and Nevis'))  
        .value('LC', L.tr('Saint Lucia'))  
        .value('MF', L.tr('Saint Martin '))  
        .value('PM', L.tr('Saint Pierre and Miquelon'))  
        .value('VC', L.tr('Saint Vincent and the Grenadines'))  
        .value('WS', L.tr('Samoa'))  
        .value('SM', L.tr('San Marino'))  
        .value('ST', L.tr('Sao Tome and Principe'))  
        .value('SA', L.tr('SAUDI ARABIA'))  
        .value('SN', L.tr('Senegal'))  
        .value('RS', L.tr('Serbia'))  
        .value('SC', L.tr('Seychelles'))  
        .value('SL', L.tr('Sierra Leone'))  
        .value('SG', L.tr('SINGAPORE'))  
        .value('SX', L.tr('Sint Maarten'))  
        .value('SK', L.tr('SLOVAKIA'))  
        .value('SI', L.tr('SLOVENIA'))  
        .value('SB', L.tr('Solomon Islands'))  
        .value('SO', L.tr('Somalia'))  
        .value('ZA', L.tr('SOUTH AFRICA'))  
        .value('GS', L.tr('South Georgia and the South Sandwich Islands'))  
        .value('SS', L.tr('South Sudan'))  
        .value('ES', L.tr('SPAIN'))  
        .value('LK', L.tr('Sri Lanka'))  
        .value('SD', L.tr('Sudan'))  
        .value('SR', L.tr('Suriname'))  
        .value('SJ', L.tr('Svalbard'))  
        .value('SJ', L.tr('Jan Mayen'))  
        .value('SE', L.tr('SWEDEN'))  
        .value('CH', L.tr('SWITZERLAND'))  
        .value('SY', L.tr('SYRIAN ARAB REPUBLIC'))  
        .value('TW', L.tr('TAIWAN'))  
        .value('TJ', L.tr('Tajikistan'))  
        .value('TZ', L.tr('Tanzania'))  
        .value('TH', L.tr('THAILAND'))  
        .value('TL', L.tr('Timor-Leste'))  
        .value('TG', L.tr('Togo'))  
        .value('TK', L.tr('Tokelau'))  
        .value('TO', L.tr('Tonga'))  
        .value('TT', L.tr('TRINIDAD AND TOBAGO'))  
        .value('TN', L.tr('TUNISIA'))  
        .value('TR', L.tr('TURKEY'))  
        .value('TM', L.tr('Turkmenistan'))  
        .value('TC', L.tr('Turks and Caicos Islands'))  
        .value('TV', L.tr('Tuvalu'))  
        .value('UG', L.tr('Uganda'))  
        .value('UA', L.tr('UKRAINE'))  
        .value('AE', L.tr('UNITED ARAB EMIRATES'))  
        .value('GB', L.tr('UNITED KINGDOM'))  
        .value('US', L.tr('UNITED STATES'))  
        .value('UY', L.tr('URUGUAY'))  
        .value('UZ', L.tr('UZBEKISTAN'))  
        .value('VU', L.tr('Vanuatu'))  
        .value('VE', L.tr('VENEZUELA'))  
        .value('VN', L.tr('VIET NAM'))  
        .value('VG', L.tr('Virgin Islands'))  
        .value('WF', L.tr('Wallis and Futuna'))  
        .value('EH', L.tr('Western Sahara '))  
        .value('YE', L.tr('YEMEN'))  
        .value('ZM', L.tr('Zambia'))  
        .value('ZW', L.tr('ZIMBABWE')); 
        
        
         s.taboption('twogigaconfig',L.cbi.ListValue, 'wifideviceschannel2_4ghz', {
			caption:	L.tr('Channel')
		}).depends({'twogigaconfig':'1'})
		.value('1', L.tr('1'))
		.value('2', L.tr('2'))
		.value('3', L.tr('3'))
		.value('4', L.tr('4'))
		.value('5', L.tr('5'))
		.value('6', L.tr('6'))
		.value('7', L.tr('7'))
		.value('8', L.tr('8'))
		.value('9', L.tr('9'))
		.value('10', L.tr('10'))
		.value('11', L.tr('11'))
		.value('12', L.tr('12'))
		.value('13', L.tr('13'))
		.value('14', L.tr('14'))
		.value('auto', L.tr('auto'));
         
         s.taboption('twogigaconfig', L.cbi.InputValue, 'TxPower2_4ghz', {
		caption:	L.tr('TX Power'),
		}).depends({'twogigaconfig':'1'}); 
		
        s.taboption('twogigaconfig', L.cbi.InputValue, 'wifi1ssid2_4ghz', {
			caption:	'Radio SSID'
		}).depends({'twogigaconfig':'1'});	
			    
		s.taboption('twogigaconfig',L.cbi.CheckboxValue, 'wifi1enable2_4ghz', {
			caption:	L.tr('Advance Settings')
		}).depends({'twogigaconfig':'1'});
		  		
		s.taboption('twogigaconfig', L.cbi.ListValue, 'wifi1mode2_4ghz', {
			caption:	L.tr('Radio Mode'),
		}).depends({'twogigaconfig':'1','wifi1enable2_4ghz':'1'})
		.value('ap', L.tr('Access Point'));				     
		  
		 s.taboption('twogigaconfig', L.cbi.ListValue, 'wifi1authentication2_4ghz', {
			caption:	L.tr('Radio Authentication'),
			initial:	'none'
		}).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'})
		.value('OPEN', L.tr('No Authentication'))
		.value('WPAPSK1', L.tr('WPA Personal (PSK)'))
		.value('psk2', L.tr('WPA2 Personal (PSK)'))
		.value('mixed-psk', L.tr('WPA/WPA2 Personal (PSK) mixed'))
		
		s.taboption('twogigaconfig', L.cbi.ListValue, 'wifi1encryption2_4ghz', {
			caption:	L.tr('Radio Encryption'),
			initial:	'none'
		}).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'})
		.value('NONE', L.tr('NONE'))
		.value('TKIP', L.tr('TKIP'))
		.value('AES', L.tr('AES'));
		
		
		s.taboption('twogigaconfig', L.cbi.PasswordValue, 'wifi1key2_4ghz', {
			caption:	L.tr('Radio Passphrase'),
			datatype:'rangelength(8,11)',
			optional:	true
		}).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'});
		
			 s.taboption('twogigaconfig',L.cbi.InputValue, 'radio0dhcpip2_4ghz', {
           caption: L.tr('Radio DHCP Server IP'), 
           datatype: 'ip4addr',
        }).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'});
        
                
           s.taboption('twogigaconfig',L.cbi.InputValue, 'Radio0DHCPrange2_4ghz', {
           caption: L.tr('Radio DHCP Start Address'), 
        }).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'});
        
          s.taboption('twogigaconfig',L.cbi.InputValue, 'Radio0DHCPlimit2_4ghz', {
           caption: L.tr('Radio DHCP Limit'), 
        }).depends({'twogigaconfig':'1','wifi1enable2_4ghz' : '1','wifi1mode2_4ghz':'ap'});
	
  //   5GHZ starts from here   
		s.tab({
            id: 'fivegigaconfig',
            caption: L.tr('5GHZ')
        });
        
         s.taboption('fivegigaconfig', L.cbi.ListValue, 'wifi1protocol5ghz', {
		caption:	L.tr('Radio 0 Protocol'),
		}).depends({'fivegigaconfig':'1'})
		.value('none', L.tr('Please choose'))
		.value('IEEE802.11b/g/n', L.tr('IEEE 802.11 b/g/n'));
        
          
         s.taboption('fivegigaconfig', L.cbi.ListValue, 'CountryCode5ghz', {
		caption:	L.tr('Country Code'),
		}).depends({'fivegigaconfig':'1'})
		.value('none', L.tr('Please choose'))
		.value('AF', L.tr('Afghanistan'))
        .value('AX', L.tr('Åland Islands'))
        .value('AL', L.tr('ALBANIA'))    
        .value('AS', L.tr('American Samoa'))  
        .value('AD', L.tr('Andorra'))  
        .value('AO', L.tr('Angola'))  
        .value('AI', L.tr('Anguilla')) 
        .value('AQ', L.tr('Antarctica')) 
        .value('AG', L.tr('Antigua and Barbuda')) 
        .value('AR', L.tr('ARGENTINA'))  
        .value('AM', L.tr('ARMENIA'))  
        .value('AW', L.tr('Aruba'))  
        .value('AU', L.tr('AUSTRALIA'))  
        .value('AT', L.tr('AUSTRIA'))  
        .value('AZ', L.tr('AZERBAIJAN'))  
        .value('BH', L.tr('BAHRAIN'))  
        .value('BD', L.tr('Bangladesh'))  
        .value('BB', L.tr('Barbados'))  
        .value('BY', L.tr('BELARUS'))  
        .value('BE', L.tr('BELGIUM'))  
        .value('BZ', L.tr('BELIZE'))  
        .value('BJ', L.tr('Benin'))  
        .value('BM', L.tr('Bermuda'))  
        .value('BT', L.tr('Bhutan'))  
        .value('BO', L.tr('BOLIVIA'))  
        .value('BQ', L.tr('Bonaire'))  
        .value('BQ', L.tr('Sint Eustatius'))  
        .value('BQ', L.tr('Saba'))  
        .value('BA', L.tr('Bosnia and Herzegovina'))  
        .value('BW', L.tr('Botswana'))  
        .value('BV', L.tr('Bouvet Island'))  
        .value('BR', L.tr('BRAZIL'))  
        .value('IO', L.tr('British Indian Ocean Territory'))  
        .value('BN', L.tr('BRUNEI DARUSSALAM'))  
        .value('BG', L.tr('BULGARIA'))  
        .value('BF', L.tr('Burkina Faso'))  
        .value('BI', L.tr('Burundi'))  
        .value('CV', L.tr('Cabo Verde'))  
        .value('KH', L.tr('Cambodia'))  
        .value('CM', L.tr('Cameroon'))  
        .value('CA', L.tr('CANADA'))  
        .value('KY', L.tr('Cayman Islands '))  
        .value('CF', L.tr('Central African Republic'))  
        .value('TD', L.tr('Chad'))  
        .value('CL', L.tr('CHILE'))  
        .value('CN', L.tr('CHINA'))  
        .value('CX', L.tr('Christmas Island'))  
        .value('CC', L.tr('Cocos (Keeling) Islands (the)'))  
        .value('CO', L.tr('COLOMBIA'))  
        .value('KM', L.tr('Comoros'))  
        .value('CD', L.tr('Congo(the Democratic Republic of the)'))  
        .value('CG', L.tr('Congo'))  
        .value('CK', L.tr('Cook Islands'))    
        .value('CR', L.tr('COSTA RICA'))  
        .value('CI', L.tr('Côte dIvoire'))  
        .value('HR', L.tr('CROATIA'))  
        .value('CU', L.tr('Cuba'))  
        .value('CW', L.tr('Curaçao'))  
        .value('CY', L.tr('CYPRUS'))  
        .value('CZ', L.tr('CZECH REPUBLIC'))  
        .value('DK', L.tr('DENMARK'))  
        .value('DJ', L.tr('Djibouti'))  
        .value('DM', L.tr('Dominica'))  
        .value('DO', L.tr('DOMINICAN REPUBLIC'))  
        .value('EC', L.tr('ECUADOR'))  
        .value('EG', L.tr('EGYPT'))  
        .value('SV', L.tr('EL SALVADOR'))  
        .value('GQ', L.tr('Equatorial Guinea'))  
        .value('ER', L.tr('Eritrea'))  
        .value('EE', L.tr('ESTONIA'))  
        .value('ET', L.tr('Ethiopia'))  
        .value('FK', L.tr('Falkland Islands'))  
        .value('FO', L.tr('Faroe Islands'))  
        .value('FJ', L.tr('Fiji'))  
        .value('FI', L.tr('FINLAND'))  
        .value('FR', L.tr('FRANCE'))  
        .value('GF', L.tr('French Guiana'))  
        .value('PF', L.tr('French Polynesia'))  
        .value('TF', L.tr('French Southern Territories'))  
        .value('GA', L.tr('Gabon'))  
        .value('GM', L.tr('Gambia'))  
        .value('GE', L.tr('GEORGIA'))  
        .value('DE', L.tr('GERMANY'))  
        .value('GH', L.tr('Ghana'))  
        .value('GI', L.tr('Gibraltar'))  
        .value('GR', L.tr('GREECE'))  
        .value('GL', L.tr('Greenland'))  
        .value('GD', L.tr('Grenada'))  
        .value('GP', L.tr('Guadeloupe'))  
        .value('GU', L.tr('Guam'))  
        .value('GT', L.tr('GUATEMALA'))  
        .value('GG', L.tr('Guernsey'))  
        .value('GW', L.tr('Guinea-Bissau'))  
        .value('GY', L.tr('Guyana'))  
        .value('HT', L.tr('Haiti'))  
        .value('HM', L.tr('Heard Island and McDonald Islands'))  
        .value('VA', L.tr('Holy See'))  
        .value('HN', L.tr('HONDURAS'))  
        .value('HK', L.tr('HONG KONG'))  
        .value('HU', L.tr('HUNGARY'))  
        .value('IS', L.tr('ICELAND'))  
        .value('IN', L.tr('INDIA'))  
        .value('ID', L.tr('INDONESIA'))  
        .value('IR', L.tr('IRAN'))  
        .value('IQ', L.tr('Iraq'))  
        .value('IE', L.tr('IRELAND'))  
        .value('IL', L.tr('ISRAEL'))  
        .value('IT', L.tr('ITALY'))  
        .value('JM', L.tr('Jamaica'))  
        .value('JP', L.tr('JAPAN'))  
        .value('JE', L.tr('Jersey'))  
        .value('JO', L.tr('JORDAN'))  
        .value('KZ', L.tr('KAZAKHSTAN'))  
        .value('KE', L.tr('Kenya'))  
        .value('KI', L.tr('Kiribati'))  
        .value('KP', L.tr('KOREA DEMOCRATIC'))  
        .value('KR', L.tr('REPUBLIC OF KOREA '))  
        .value('KW', L.tr('KUWAIT'))  
        .value('KG', L.tr('Kyrgyzstan'))  
        .value('LA', L.tr('Lao People Democratic Republic'))  
        .value('LV', L.tr('LATVIA'))  
        .value('LB', L.tr('LEBANON'))  
        .value('LS', L.tr('Lesotho'))  
        .value('LR', L.tr('Liberia'))  
        .value('LY', L.tr('Libya'))  
        .value('LI', L.tr('LIECHTENSTEIN'))  
        .value('LT', L.tr('LITHUANIA'))  
        .value('LU', L.tr('LUXEMBOURG'))  
        .value('MO', L.tr('MACAO'))  
        .value('MK', L.tr('MACEDONIA'))  
        .value('MG', L.tr('Madagascar'))  
        .value('MW', L.tr('Malawi'))  
        .value('MY', L.tr('MALAYSIA'))  
        .value('MV', L.tr('Maldives'))  
        .value('ML', L.tr('Mali'))  
        .value('MT', L.tr('Malta'))  
        .value('MH', L.tr('Marshall Islands'))  
        .value('MQ', L.tr('Martinique'))  
        .value('MR', L.tr('Mauritania'))  
        .value('MU', L.tr('Mauritius'))  
        .value('YT', L.tr('Mayotte'))  
        .value('MX', L.tr('MEXICO'))  
        .value('FM', L.tr('Micronesia'))  
        .value('MD', L.tr('Moldova'))  
        .value('MC', L.tr('MONACO'))  
        .value('MN', L.tr('Mongolia'))  
        .value('ME', L.tr('Montenegro'))  
        .value('MS', L.tr('Montserrat'))  
        .value('MA', L.tr('MOROCCO'))  
        .value('MZ', L.tr('Mozambique'))  
        .value('MM', L.tr('Myanmar'))  
        .value('NA', L.tr('Namibia'))  
        .value('NR', L.tr('Nauru'))  
        .value('NP', L.tr('Nepal'))  
        .value('NL', L.tr('NETHERLANDS'))  
        .value('NC', L.tr('New Caledonia '))  
        .value('NZ', L.tr('NEW ZEALAND'))   
        .value('NI', L.tr('Nicaragua'))  
        .value('NE', L.tr('Niger'))  
        .value('NG', L.tr('Nigeria'))  
        .value('NU', L.tr('Niue'))  
        .value('NF', L.tr('Norfolk Island'))  
        .value('MP', L.tr('Northern Mariana Islands'))  
        .value('NO', L.tr('NORWAY')) 
        .value('OM', L.tr('OMAN'))  
        .value('PK', L.tr('PAKISTAN'))  
        .value('PW', L.tr('Palau'))  
        .value('PS', L.tr('Palestine'))  
        .value('PA', L.tr('PANAMA'))  
        .value('PG', L.tr('Papua New Guinea'))  
        .value('PY', L.tr('Paraguay'))  
        .value('PE', L.tr('PERU'))  
        .value('PH', L.tr('PHILIPPINES'))  
        .value('PN', L.tr('Pitcairn'))  
        .value('PL', L.tr('POLAND'))  
        .value('PT', L.tr('PORTUGAL'))  
        .value('PR', L.tr('PUERTO RICO'))  
        .value('QA', L.tr('QATAR'))  
        .value('RE', L.tr('Réunion'))  
        .value('RO', L.tr('ROMANIA'))  
        .value('RU', L.tr('RUSSIA FEDERATION'))  
        .value('RW', L.tr('Rwanda'))  
        .value('BL', L.tr('Saint Barthélemy'))  
        .value('SH', L.tr('Saint Helena'))  
        .value('SH', L.tr('Ascension Island'))  
        .value('SH', L.tr('Tristan da Cunha'))  
        .value('KN', L.tr('Saint Kitts and Nevis'))  
        .value('LC', L.tr('Saint Lucia'))  
        .value('MF', L.tr('Saint Martin '))  
        .value('PM', L.tr('Saint Pierre and Miquelon'))  
        .value('VC', L.tr('Saint Vincent and the Grenadines'))  
        .value('WS', L.tr('Samoa'))  
        .value('SM', L.tr('San Marino'))  
        .value('ST', L.tr('Sao Tome and Principe'))  
        .value('SA', L.tr('SAUDI ARABIA'))  
        .value('SN', L.tr('Senegal'))  
        .value('RS', L.tr('Serbia'))  
        .value('SC', L.tr('Seychelles'))  
        .value('SL', L.tr('Sierra Leone'))  
        .value('SG', L.tr('SINGAPORE'))  
        .value('SX', L.tr('Sint Maarten'))  
        .value('SK', L.tr('SLOVAKIA'))  
        .value('SI', L.tr('SLOVENIA'))  
        .value('SB', L.tr('Solomon Islands'))  
        .value('SO', L.tr('Somalia'))  
        .value('ZA', L.tr('SOUTH AFRICA'))  
        .value('GS', L.tr('South Georgia and the South Sandwich Islands'))  
        .value('SS', L.tr('South Sudan'))  
        .value('ES', L.tr('SPAIN'))  
        .value('LK', L.tr('Sri Lanka'))  
        .value('SD', L.tr('Sudan'))  
        .value('SR', L.tr('Suriname'))  
        .value('SJ', L.tr('Svalbard'))  
        .value('SJ', L.tr('Jan Mayen'))  
        .value('SE', L.tr('SWEDEN'))  
        .value('CH', L.tr('SWITZERLAND'))  
        .value('SY', L.tr('SYRIAN ARAB REPUBLIC'))  
        .value('TW', L.tr('TAIWAN'))  
        .value('TJ', L.tr('Tajikistan'))  
        .value('TZ', L.tr('Tanzania'))  
        .value('TH', L.tr('THAILAND'))  
        .value('TL', L.tr('Timor-Leste'))  
        .value('TG', L.tr('Togo'))  
        .value('TK', L.tr('Tokelau'))  
        .value('TO', L.tr('Tonga'))  
        .value('TT', L.tr('TRINIDAD AND TOBAGO'))  
        .value('TN', L.tr('TUNISIA'))  
        .value('TR', L.tr('TURKEY'))  
        .value('TM', L.tr('Turkmenistan'))  
        .value('TC', L.tr('Turks and Caicos Islands'))  
        .value('TV', L.tr('Tuvalu'))  
        .value('UG', L.tr('Uganda'))  
        .value('UA', L.tr('UKRAINE'))  
        .value('AE', L.tr('UNITED ARAB EMIRATES'))  
        .value('GB', L.tr('UNITED KINGDOM'))  
        .value('US', L.tr('UNITED STATES'))  
        .value('UY', L.tr('URUGUAY'))  
        .value('UZ', L.tr('UZBEKISTAN'))  
        .value('VU', L.tr('Vanuatu'))  
        .value('VE', L.tr('VENEZUELA'))  
        .value('VN', L.tr('VIET NAM'))  
        .value('VG', L.tr('Virgin Islands'))  
        .value('WF', L.tr('Wallis and Futuna'))  
        .value('EH', L.tr('Western Sahara '))  
        .value('YE', L.tr('YEMEN'))  
        .value('ZM', L.tr('Zambia'))  
        .value('ZW', L.tr('ZIMBABWE')); 
        
        
         s.taboption('fivegigaconfig',L.cbi.ListValue, 'wifideviceschannel5ghz', {
			caption:	L.tr('Channel')
		}).depends({'fivegigaconfig':'1'})
		.value('1', L.tr('1'))
		.value('2', L.tr('2'))
		.value('3', L.tr('3'))
		.value('4', L.tr('4'))
		.value('5', L.tr('5'))
		.value('6', L.tr('6'))
		.value('7', L.tr('7'))
		.value('8', L.tr('8'))
		.value('9', L.tr('9'))
		.value('10', L.tr('10'))
		.value('11', L.tr('11'))
		.value('12', L.tr('12'))
		.value('13', L.tr('13'))
		.value('14', L.tr('14'))
		.value('auto', L.tr('auto'));
		
		 
         s.taboption('fivegigaconfig', L.cbi.InputValue, 'TxPower5ghz', {
		caption:	L.tr('TX Power'),
		}).depends({'fivegigaconfig':'1'});
		
        s.taboption('fivegigaconfig', L.cbi.InputValue, 'wifi1ssid5ghz', {
			caption:	'Radio SSID'
		}).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'});
		    
		s.taboption('fivegigaconfig',L.cbi.CheckboxValue, 'wifi1enable5ghz', {
			caption:	L.tr('Advance Settings')
		}).depends({'fivegigaconfig':'1'});

		s.taboption('fivegigaconfig', L.cbi.ListValue, 'wifi1mode5ghz', {
			caption:	L.tr('Radio Mode'),
		}).depends({'fivegigaconfig':'1','wifi1enable5ghz':'1'})
		.value('ap', L.tr('Access Point'));
		      
		s.taboption('fivegigaconfig', L.cbi.ListValue, 'wifi1authentication5ghz', {
			caption:	L.tr('Radio Authentication'),
			initial:	'none'
		}).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'})
		.value('OPEN', L.tr('No Authentication'))
		.value('WPAPSK', L.tr('WPA Personal (PSK)'))
		.value('WPA2PSK', L.tr('WPA2 Personal (PSK)'));
		
		s.taboption('fivegigaconfig', L.cbi.ListValue, 'wifi1encryption5ghz', {
			caption:	L.tr('Radio Encryption'),
			initial:	'none'
		}).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'})
		.value('NONE', L.tr('NONE'))
		.value('TKIP', L.tr('TKIP'))
		.value('AES', L.tr('AES'));

		s.taboption('fivegigaconfig', L.cbi.PasswordValue, 'wifi1key5ghz', {
			caption:	L.tr('Radio Passphrase'),
			datatype:'rangelength(8,11)',
			optional:	true
		}).depends({'fivegigaconfig':'1','wifi1enable5gzh' : '1','wifi1mode5ghz':'ap'});

			 s.taboption('fivegigaconfig',L.cbi.InputValue, 'radio0dhcpip5ghz', {
           caption: L.tr('Radio DHCP Server IP'), 
           datatype: 'ip4addr',
        }).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'});
                
           s.taboption('fivegigaconfig',L.cbi.InputValue, 'Radio0DHCPrange5ghz', {
           caption: L.tr('Radio DHCP Start Address'), 
        }).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'});
        
          s.taboption('fivegigaconfig',L.cbi.InputValue, 'Radio0DHCPlimit5ghz', {
           caption: L.tr('Radio DHCP Limit'), 
        }).depends({'fivegigaconfig':'1','wifi1enable5ghz' : '1','wifi1mode5ghz':'ap'});

 //wificonfigschedule    
        s.tab({
            id: 'wificonfigschedule',
            caption: L.tr('Wireless Schedule')
        });
		
		   s.taboption('wificonfigschedule',L.cbi.DummyValue, 'generalsettings', {
		  caption: L.tr(''),
        }).depends({'wificonfig':'1'})
        .depends({'wifi1enable':'1' })
        .ucivalue=function()
          {
            var id="<h3><b>Wifi Schedule ON/OFF settings </b> </h3>";
            return id;
          }; 

		 s.taboption('wificonfigschedule', L.cbi.CheckboxValue, 'ScheduledOnOff', {
			caption:	L.tr('Scheduled Wifi On/Off'),
		}).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1'});

        s.taboption('wificonfigschedule', L.cbi.DynamicList, 'DayOfWeek', {
            caption: L.tr('Day Of Week'),
            optional: true,
            listlimit: 12,
            listcustom:false
        }).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        .value('*', L.tr('All'))
        .value('0', L.tr('Sunday'))
        .value('1', L.tr('Monday'))
        .value('2', L.tr('Tuesday'))
        .value('3', L.tr('Wednesday'))
        .value('4', L.tr('Thursday'))
        .value('5', L.tr('Friday'))
        .value('6', L.tr('Saturday'));
        		
		
		s.taboption('wificonfigschedule',L.cbi.DummyValue, 'from', {
		  caption: L.tr(''),
        }).depends({'wificonfig':'1','wifi1enable':'1' ,'wificonfigschedule':'1'})
        .ucivalue=function()
          {
            var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp From: </b> </h5>";
            return id;
          }; 
		
		
		
		var fromHourVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'fromHours', {
            caption: L.tr('Hours'),
            optional: true,
            listlimit: 24,
            listcustom:false,
        }).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        fromHourVal.load = function(sid) {
            var hours = [ ];
            for (var i = 0; i < 24; i++)
                hours.push(i);
            hours.sort();
            for (var i = 0; i < hours.length; i++)
                fromHourVal.value(i);
        };
		
		
		var fromMinuteVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'fromMinutes', {
            caption: L.tr('Minutes'),
            optional: true,
            listlimit: 60,
            listcustom: false
        }).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        fromMinuteVal.load = function(sid) {
            var minutes = [ ];
            for (var i = 0; i < 60; i++)
                minutes.push(i);
            minutes.sort();
            for (var i = 0; i < minutes.length; i++)
                fromMinuteVal.value(i);
        };

        
        s.taboption('wificonfigschedule',L.cbi.DummyValue, 'to', {
		  caption: L.tr(''),
        }).depends({'wificonfig':'1'})
        .depends({'wifi1enable':'1' })
        .ucivalue=function()
          {
            var id="<h5><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp To: </b> </h5>";
            return id;
          }; 
        
        var HourVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'toHours', {
            caption: L.tr('Hours'),
            optional: true,
            listlimit: 24,
            listcustom:false,
        }).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        HourVal.load = function(sid) {
            var hours = [ ];
            for (var i = 0; i < 24; i++)
                hours.push(i);
            hours.sort();
            for (var i = 0; i < hours.length; i++)
                HourVal.value(i);
        };
		
		
		var MinuteVal = s.taboption('wificonfigschedule', L.cbi.DynamicList, 'toMinutes', {
            caption: L.tr('Minutes'),
            optional: true,
            listlimit: 60,
            listcustom: false
        }).depends({'wificonfig':'1','wifi1enable':'1','wificonfigschedule':'1','ScheduledOnOff':'1'})
        .value('',L.tr('-- Please choose --'))
        .value('*', L.tr('All'));

        MinuteVal.load = function(sid) {
            var minutes = [ ];
            for (var i = 0; i < 60; i++)
                minutes.push(i);
            minutes.sort();
            for (var i = 0; i < minutes.length; i++)
                MinuteVal.value(i);
        };

        s.commit=function(){
        self.updateinterfaceconfig('Update','updateinterface').then(function(rv) {
               
                });
        }
		                        
        return m.insertInto('#map');
    }
});
