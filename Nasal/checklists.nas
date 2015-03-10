
# Settings
var stepTime = 1.5; # Time between each step, before delay, in seconds

props.globals.initNode("/sim/autostart/step", 0, "INT");

var controls = props.globals.getNode("controls");
var buttons = controls.getNode("buttons");
var switches = controls.getNode("switches");
var instruments = props.globals.getNode("instrumentation");
var light = props.globals.getNode("sim/time/sun-angle-rad");

 var num=0; var name=1; var go=2; var delay=3; var alert=4;
 var power = [
     [0,"null",0,-1.5,"Executing Power-Up checklist..."],
     [1,"Battery Switch on",func {
	     controls.getNode("electric/battery-switch").setBoolValue(1);
		},0,0],
	 [2,"Left MHDD on",func {
	     instruments.getNode("MFD[1]/stand-by").setBoolValue(0);
		},2,0],
	 [3,"APU Button on",func {
	     buttons.getNode("APU").setBoolValue(1);
		},3.5,0],
     [4,"Centre & Right MHDDs on",func {
	     instruments.getNode("MFD[0]/stand-by").setBoolValue(0);
		 instruments.getNode("MFD[2]/stand-by").setBoolValue(0);
		},9.5,0],
	 [5,"Voice, Radios and MIDS on",func {
	     settimer ( func { switches.getNode("voice").setBoolValue(1); }, 0.1 ); 
		 settimer ( func { switches.getNode("rad-1-power").setBoolValue(1); }, 0.5 ); 
		 settimer ( func { switches.getNode("rad-2-power").setBoolValue(1); }, 0.9 ); 
         # settimer ( func { switches.getNode("MIDS-power").setBoolValue(1); }, 1.3 ); 
		},11.0,0],
	];

var engineStart = [	
     [0,"null",0,-1,"Executing Engine Start checklist..."],
	 [1,"LP Cocks open",func {
		 var lcock = switches.getNode("lp-cock-left");
		 settimer( func { avionics.controls.leftLPCockCover(); }, 0.5);
		 settimer( func { lcock.setBoolValue(1); }, 1.25);
		 settimer( func { avionics.controls.leftLPCockCover(); }, 2.0);
	    },0.5,0],
	 [2,"Boost Pumps on",func {
	     switches.getNode("boost-pump-left").setBoolValue(1);
		 switches.getNode("boost-pump-right").setBoolValue(1);
		},4,0],	 
	 [3,"Engine Start",func {
	     avionics.controls.engineStart(1);
		},5.5,0],
	];
	
var taxi = [
     [0,"null",0,-1,"Executing Taxi checklist..."],
	 [1,"Navigation lights on",func {
	     switches.getNode("navigation-lights").setBoolValue(1);
		},1,0],
	 [2,"Arm Ejection Seat", func {
	     pos = controls.getNode("seat/arming-handle").getValue();
		 if ( pos != 1 ) {
		     avionics.controls.armSeat();
			};}, 1.75,0],
	 [3,"Taxi Lights on",func {
	     var lx = light.getValue();
		 if ( lx > 1.55 ) {
		     avionics.controls.gearLights(3);
			}
		},3,0],
	];
	
var takeoff = [
     [0,"null",0,0,"Executing Take-off checklist..."],
	 [1,"Strobes on",func {
	     switches.getNode("strobe-lights").setBoolValue(1);
		},-1,0],
	 [2,"Landing Lights on",func {
		 avionics.controls.gearLights(1);
	    },1,0],
	 [3,"Master Armament Safety Switch on",func { # Conditional: Weapons Loaded
		 var stations = props.globals.getNode("computers/weapons/stores");
	     var bvraam = stations.getNode("BVRAAM").getValue();
		 var mraam = stations.getNode("MRAAM").getValue();
		 var sraam = stations.getNode("SRAAM").getValue();
		 var smoke = stations.getNode("smoke").getBoolValue();
		 if (( bvraam + mraam + sraam > 0) and (!smoke)) {
		     avionics.controls.MASStoggle();
		    };
	    },1,0],
	 [4,"Canard Unpark",func {
		 props.globals.getNode("systems/FCS/internal/canard-park").setBoolValue(0);
	    },0,0],
	];
	
var autostart = func {
     screen.log.write("Auto starting");
	 group.power();
	 settimer( func { group.engineStart(); }, 20);
	 settimer( func { group.taxi(); }, 50);
	}
	
var group = {
     power: func {
    	 foreach (x; power) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 if ( alert != 0 ) {
		     screen.log.write(alert);
			}
		 }
	     setprop("/sim/autostart/step", 1);
	},
	engineStart: func {
    	 foreach (x; engineStart) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 if ( alert != 0 ) {
		     screen.log.write(alert);
			}
		 }
		 setprop("/sim/autostart/step", 2);
	},
	taxi: func {
    	 foreach (x; taxi) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 if ( alert != 0 ) {
		     screen.log.write(alert);
			}
		 }
		 setprop("/sim/autostart/step", 3);
	},
	takeoff: func {
    	 foreach (x; takeoff) {
	         var delay = x[3];
		     var alert = x[4];
		     var timer = ( stepTime + delay );
		     var name = x[1];
		     var num = x[0];
		 print("Running... "~name~" - Timer: "~timer);
		 if ( x[2] != 0 ) {
		     settimer( x[2], timer);
		     }
		 if ( alert != 0 ) {
		     screen.log.write(alert);
			}
		 }
		 setprop("/sim/autostart/step", 4);
	}
}

