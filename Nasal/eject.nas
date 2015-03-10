
# Eject

props.globals.initNode("eject/clock", 0, "DOUBLE");
props.globals.initNode("eject/canopy/jettison", 0, "BOOL");
props.globals.initNode("eject/canopy/forces/force-lb", 0, "DOUBLE");
props.globals.initNode("eject/canopy/forces/force-azimuth-deg", 90, "DOUBLE");
props.globals.initNode("eject/canopy/forces/force-elevation-deg", 90, "DOUBLE");

var ejectprop = props.globals.getNode("eject");
var clockprop = ejectprop.getNode("clock");
var controls = props.globals.getNode("controls/seat");

var eject = {
     eject: func { 
	     # Check variables
		 var armed = controls.getNode("arming-handle").getValue();
		 if (armed) {
		     # Start the clock loop
			clock();
			}
	    },
     canopy: func { 
         var forcelbs = ejectprop.getNode("canopy/forces/force-lb");
		 forcelbs.setValue(800);
		 ejectprop.getNode("canopy/jettison").setBoolValue(1);
		 settimer( func {
		     interpolate(forcelbs, 0, 1);
			}, 0.4);
		},
	};
	
var clock = func {
	 var curr = clockprop.getValue();
	 var new = ( curr + 0.0333 );
	 clockprop.setValue(new);
     settimer(clock, 0.033);
	}
     
