### Autopilot Modes


## Safety Settings for Autopilot

var startHDG = getprop("orientation/heading-magnetic-deg");
setprop("/systems/autopilot/settings/target-heading-deg", startHDG);
setprop("/systems/autopilot/settings/target-altitude-ft", 4000);
setprop("/systems/autopilot/settings/target-altitude-agl-ft", 1000);
setprop("/systems/autopilot/settings/target-pitch-deg", 0);
setprop("/systems/autopilot/settings/target-roll-deg", 0);
setprop("/systems/autopilot/settings/target-speed-kt", 350);
setprop("/systems/autopilot/settings/target-speed-mach", 1.2);
setprop("/systems/autopilot/settings/kts-mach-select", "kts");
setprop("/systems/autopilot/settings/heading-mode", "mag");
setprop("/systems/autopilot/settings/altitude-mode", "agl");
setprop("/systems/autopilot/locks", 0);

## Common AP Variables

# Feet per sec = (current-altitude - target-altitude) / seconds-to-target

var nav_altitude = func {

   var locked = getprop("/systems/autopilot/settings/nav-lock");
   if ( locked ) {
         var curr_alt = getprop("/position/altitude-ft");
         var des_alt = getprop("/systems/autopilot/internal/nav-altitude-ft");
         var time = getprop("/instrumentation/gps/wp/wp[1]/TTW-sec");
		 var des_fps = ( ( des_alt - curr_alt ) / time );
		 setprop("/systems/autopilot/internal/nav-fps", des_fps );
		 }
    settimer(nav_altitude, 0.3);
	}

setlistener("/sim/signals/fdm-initialized", nav_altitude);


## Basic Functions
var apCancel = func {
setprop("/systems/autopilot/locks/heading", "");
setprop("/systems/autopilot/locks/altitude", "");
}


var panic = func {
setprop("/systems/autopilot/settings/target-roll-deg", "0");
setprop("/systems/autopilot/locks/heading", "roll-hold");
setprop("/systems/autopilot/settings/target-pitch-deg", "0");
setprop("/systems/autopilot/locks/heading", "pitch-hold");
}

### New Work Starts Here! ###

var app = {
     go: func {
	     var dest = props.globals.getNode("/autopilot/route-manager/destination/airport").getValue();
		 if ( dest == nil ) {
		     # Make a bad noise
			}
		 else {
		     # Make a good noise
             me.loop();
			}
		},
	 loop: func {
	     var dist = props.globals.getNode("/autopilot/route-manager/distance-remaining-nm").getValue();
		},
	};
		

var loop = func {
     
	 var pof = props.globals.getNode("computers/phase-of-flight-num").getValue();
	 var ap = props.globals.getNode("systems/autopilot");
	 var fcs = props.globals.getNode("systems/FCS");
	 var alock = ap.getNode("locks/altitude");
	 var hlock = ap.getNode("locks/heading");
	 var slock = ap.getNode("locks/speed");
	 
	 var alt = props.globals.getNode("position/altitude-ft").getValue();
	 var wp = props.globals.getNode("autopilot/route-manager/wp/dist").getValue();
	 var gear = props.globals.getNode("gear/gear[0]/position-norm").getValue();
	 
	 if ( pof == 5 ) {
	     if ( ap.getNode("locks/heading") != nil ) {
		     if ( ( alt < 500 ) and ( wp < 0.1 ) ) {
			     fcs.getNode("internal/attitude/roll-deg").setValue(0);
				 hlock.setValue("");
				}
			}
					
    	 if ( alock.getValue() != nil ) {
		     if ( ( alt < 500 ) and ( wp < 0.1 ) ) {
				 alock.setValue("");
                 
				 if ( alock.getValue() == "app" ) {
				     
					}
				}
			}

    	 if ( slock.getValue() != nil ) {
		     if ( ( alt < 500 ) and ( wp < 0.05 ) ) {
				 
				 slock.setValue("");
				}
			}
			
		 if ( alock.getValue() == "app" ) {
		     if (( alt < 1000 ) and ( gear == 0 )) {
		         warnings.alert.trigger("landing-gear"); 
			    }
		    }	        
	    }
     settimer(loop,0.5);
    }
	
setlistener("/sim/signals/fdm-initialized", loop);