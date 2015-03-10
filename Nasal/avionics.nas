
# Blink

aircraft.light.new( "/sim/model/avionics/blink[0]", [0.4, 0.4], "/controls/engines/engine[2]/starter" ); # APU button

var orientation = func {

	var maghdg = getprop("/orientation/heading-magnetic-deg");
	var truhdg = getprop("/orientation/heading-deg");
	var settrue = getprop("/instrumentation/MFD[0]/PA/true-heading");
	var setnth = getprop("/instrumentation/MFD[0]/PA/orientation-north");
	
	if (setnth) {
		setprop("/instrumentation/MFD[0]/PA/orientation-deg", 0);
				}
		if (!setnth) {
			if (settrue) {	setprop("/instrumentation/MFD[0]/PA/orientation-deg", truhdg); 	};
			if (!settrue) { setprop("/instrumentation/MFD[0]/PA/orientation-deg", maghdg);	};
			}
		settimer(orientation, 0.5);
		}

settimer(orientation, 0.5);

var contact_factor = func {
   var scale = 0.07;
   var pa_zoom = getprop("instrumentation/MFD[0]/PA/zoom-nm");
   result = ( scale / pa_zoom );
   setprop("instrumentation/MFD[0]/PA/contact-factor", result);
   }
   
setlistener("/instrumentation/MFD[0]/PA/zoom-nm", contact_factor);

var fuellevel = func {

	var ftankf1 = getprop("/consumables/fuel/tank[0]/level-lbs");
	var ftankf2 = getprop("/consumables/fuel/tank[1]/level-lbs");
	var ftankf3 = getprop("/consumables/fuel/tank[3]/level-lbs");
	var ftankf4 = getprop("/consumables/fuel/tank[5]/level-lbs");
	var ftankr1 = getprop("/consumables/fuel/tank[4]/level-lbs");
	var ftankr2 = getprop("/consumables/fuel/tank[6]/level-lbs");
	var ftankr3 = getprop("/consumables/fuel/tank[2]/level-lbs");
	
	var ftanksf = ( ftankf1 + ftankf2 + ftankf3 + ftankf4 );
	var ftanksr = ( ftankr1 + ftankr2 + ftankr3 );
	
	setprop("/consumables/fuel/fwd-level-lbs", ftanksf);
	setprop("/consumables/fuel/rear-level-lbs", ftanksr);
	
	settimer(fuellevel, 0.5);
	
	}
	
settimer(fuellevel, 2);

var fuelflow = func {

    var rpm1 = getprop("/engines/engine[0]/rpm");
	var rpm2 = getprop("/engines/engine[1]/rpm");
	var adjuster1 = ( rpm1 / 4 );
	var adjuster2 = ( rpm2 / 4 );
	
	var leftgph = getprop("/engines/engine[0]/fuel-flow-gph");
	var rightgph = getprop("/engines/engine[1]/fuel-flow-gph");
	var leftgpm = (( leftgph / 6 ) + adjuster1);
	var rightgpm = (( rightgph / 6 ) + adjuster2);
	setprop("/engines/engine[0]/fuel-flow-gpm", leftgpm);
	setprop("/engines/engine[1]/fuel-flow-gpm", rightgpm);
	settimer(fuelflow, 0.1);
	
}

settimer(fuelflow, 0.5);

var mfd = {
     select: func (num, page) {
	     setprop("/instrumentation/MFD["~num~"]/page-selected", page);
	    },
	 masscheck: func {
	     var pofnum = getprop("/computers/phase-of-flight-num");
	     var mass = getprop("/controls/armament/master-arm");
		 if ((mass) and (pofnum == 1)) { mfd.select(2,"stor"); }
		 if ((!mass) and (pofnum == 1)) { mfd.select(2,"eng"); }
		},
	 pofsel: func {
	     var pofnum = getprop("/computers/phase-of-flight-num");
		 var mass = getprop("/controls/armament/master-arm");
		 if ( pofnum == 1 ) {
		     mfd.select(1,"acue");
			 if (mass) {
			     mfd.select(2,"stor");
				}
			 else {
			     mfd.select(2,"eng");
				}
			}
		 if ( pofnum == 2 ) {
		     mfd.select(1,"atck");
			 mfd.select(2,"eng");
			}
		 if ( pofnum == 3 ) {
		     mfd.select(1,"atck");
			 mfd.select(2,"elev");
			}
		 if ( pofnum == 4 ) {
		     mfd.select(1,"atck");
			 mfd.select(2,"elev");
			}
		 if ( pofnum == 5 ) {
		     mfd.select(1,"atck");
			 mfd.select(2,"eng");
			}
		},
	};

setlistener("/computers/phase-of-flight-num", mfd.pofsel);
setlistener("/controls/armament/master-arm", mfd.masscheck);

var controls = {
     gearLights: func(a) {
	     var switch = props.globals.getNode("/controls/switches/gear-lights");
		 var land = props.globals.getNode("/controls/switches/landing-lights");
		 var taxi = props.globals.getNode("/controls/switches/taxi-lights");
		 switch.setValue(a);
		 if ( a == 1 ) {
			 land.setBoolValue(1);
			 taxi.setBoolValue(0);
			 }
		 if ( a == 2 ) {
			 land.setBoolValue(0);
			 taxi.setBoolValue(0);
			 }
		 if ( a == 3 ) {
			 land.setBoolValue(0);
			 taxi.setBoolValue(1);
			 }
		},		     
	 formLights: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/formation-lights");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.25 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.25 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.5);
		 # rotary.setValue(newsetting);
		},
	 consoleDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/console-lighting");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.1 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.1 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.5);
		 # rotary.setValue(newsetting);
		},
	 glareshieldDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/glareshield-lighting");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.1 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.1 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.5);
		 # rotary.setValue(newsetting);
		},
     displayDim: func(a) {
	     var rotary = props.globals.getNode("/controls/rotary/display-brightness");
		 var setting = rotary.getValue();
		 var newsetting = 0;
		 if ( a == 1 ) {
		     if ( setting != 1 ) { newsetting = ( setting + 0.1 ) };
			 if ( setting == 1 ) { newsetting = 1 };
			}
		 if ( a == 0 ) {
		     if ( setting != 0 ) { newsetting = ( setting - 0.1 ) };
			 if ( setting == 0 ) { newsetting = 0 };
			}
		 interpolate(rotary, newsetting, 0.5);
		 # rotary.setValue(newsetting);
		},				
	 engineStart: func(b) {
	     var engswitch = props.globals.getNode("/controls/switches/engine-start");
		 if ( b == 0 ) { 
		     engswitch.setValue(0);
			 decu.engstop();
			}
		 if ( b == 1 ) { 
		     engswitch.setValue(2);
			 decu.start.switch();
			}
		 settimer( func { engswitch.setValue(1); }, 0.5);
		},
	 MASStoggle: func {
	     var mass = props.globals.getNode("/controls/rotary/MASS");
		 var pos = mass.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/rotary/MASS", 1, 0.25);
			 settimer( func { setprop("/controls/armament/master-arm", 1); }, 0.175 );
			}
		 if ( pos == 1 ) { 
		     interpolate("/controls/rotary/MASS", 0, 0.25);
			 setprop("/controls/armament/master-arm", 0);
			}
		},
	 leftLPCockCover: func {
	     var cock = props.globals.getNode("/controls/switches/lp-cock-left-cover");
		 var pos = cock.getValue();
		 if ( pos == 0 ) { 
		     interpolate("/controls/switches/lp-cock-left-cover", 1, 0.2);
			};
		 if ( pos == 1 ) { 
		     interpolate(cock, 0, 0.2);
			};
		},
	 armSeat: func {
	     var handle = props.globals.getNode("/controls/seat/arming-handle");
		 var pos = handle.getValue();
		  if ( pos == 0 ) { 
		     interpolate(handle, 1, 0.3);
			};
		 if ( pos == 1 ) { 
		     interpolate(handle, 0, 0.3);
			};
	    }
	}

