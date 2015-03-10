
## DECMU


# Reheat

## Afterburner
# Due to the possible connection* to generic autopilot reheat wants to set in on autothrottle 
# (only if engaged via /autopilot/locks/speed-with-throtle). Preventing this.
# With added friction to gears in yasim there is no need for reverser anymore. It is used for the chute,
# since there is no chute declared in yasim and so no drag.
# 
# * autopilotconnectors below in this file allow one to use 'regular' ap/menu/shortcuts for 
# pitch-hold, speed-with-throttle, wings-level and altitude-hold which triggers the systems-ap

var engine 		= props.globals.getNode("controls/engines").getChildren("engine");
var throttle	= props.globals.getNode("controls/engines/engine[0]/throttle");

var no_reheat = func {
	foreach(e; engine) {		 
		var burner = e.getNode("reheat", 1);
		if (burner.getValue()) burner.setValue(0);
	}
}

var reheat = func {
	var reheat_ok = getprop("/systems/autopilot/settings/allow-reheat");
	var autothrottle= (getprop("/autopilot/locks/speed/speed-with-throttle") or
		getprop("/systems/autopilot/locks/speed/speed-with-throttle"));
		
	if (autothrottle and !reheat_ok) {
		foreach(e; engine) {		 
			var burner = e.getNode("reheat", 1);
			var throttle = e.getNode("throttle", 1);	
			burner.setValue(0);	
			throttle.setValue(0.98);
		}
	} else {
		foreach(e; engine) {		 
			burner = e.getNode("reheat", 1);
			burner.setValue(1);
		}	
	}
}

# the reverse of below (listener on [0]) doesn't keep the values in sync	
setlistener("controls/engines/engine[1]/throttle", func {
	var reverser	= getprop("/controls/engines/engine[0]/reverser");
	var t = throttle.getValue();
	if (reverser) {	
		no_reheat();		
		if (t > 0.5) {
			foreach(e; engine) {
			var throttle = e.getNode("throttle", 1);
			throttle.setValue(0.5);
			}
		}		
	} else {
		if (t < 0.99 ) {
			no_reheat();
		} else {
			reheat();		
		}
	}			 
});


      


   
  