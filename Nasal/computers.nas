
# Phase of Flight Computer


var pof = {

     select: func(a) {
	     var num = props.globals.getNode("/computers/phase-of-flight-num");
	     num.setValue(a);
	 },
     monitor: func {
     	 var x = props.globals.getNode("computers/phase-of-flight-num").getValue();
		 var alt = props.globals.getNode("position/altitude-agl-ft").getValue();
		 var spd = props.globals.getNode("velocities/groundspeed-kt").getValue();
		 var gear1_wow = props.globals.getNode("gear/gear[1]/wow").getBoolValue();
		 var gear2_wow = props.globals.getNode("gear/gear[2]/wow").getBoolValue();
		 var gearpos = props.globals.getNode("gear/gear[0]/position-norm").getValue();
		 var mass = props.globals.getNode("controls/armament/master-arm").getBoolValue();
		 var throt = props.globals.getNode("systems/DECU/command-outputs/engine/throttle").getValue();
		 var canard = props.globals.getNode("systems/FCS/internal/canard-park");
		 
		 if (( gear1_wow ) and ( gear2_wow )) { var wow = 1; } else { var wow = 0; }
		 
		 # Canard Parking
		 
		 # Ground to Take-Off
		 if ( x == 1 ) { 
		     if (( spd > 80 ) and ( throt > 0.5 )) { pof.select(2); }
			 if (wow) {
		         if ( spd > 30 ) { canard.setBoolValue(0); }
		        }
			}
		 if ( x == 2 ) {
		     if ( ( gearpos == 0 ) ) { if ((throt > 0.5 ) and ( alt > 1000 )) { pof.select(3); } }
			}
		 if ( x == 3 ) {
             if (( gearpos > 0.2 ) and ( throt < 0.5 ) ) { pof.select(5); }
			 if ( mass ) { pof.select(4); }
			}
		 if ( x == 4 ) { 
             if ( !mass ) { pof.select(3); }
			 if (( gearpos > 0.2 ) and ( throt < 0.5 ) ) { pof.select(5); }
			}
		 if ( x == 5 ) {
		     if ( throt > 0.75 ) { pof.select(2); }
			 if ((wow) and ( spd < 60 )) { pof.select(1); }
			}
		settimer(pof.monitor, 0.5);
		}    
		
};

# Attack Computer

var attack = {
     loop: func {
	     var atk = props.globals.getNode("/computers/attack");
		 var mp = props.globals.getNode("/ai/models");
		     
		 var selind = atk.getNode("target-selected-index").getValue();
		 if ( selind > -1 ) {
		     var s = selind;
			 var mpnode = mp.getNode("multiplayer["~s~"]");
			 var sbearing = mpnode.getNode("bearing-to").getValue();
			 var srange = mpnode.getNode("distance-to-nm").getValue();
			 var sspeed = mpnode.getNode("velocities/true-airspeed-kt").getValue();
			 var valid = mpnode.getNode("valid").getBoolValue();

			 if ( valid ) {
			     atk.getNode("target-bearing-deg").setValue(sbearing);
			     atk.getNode("target-distance-nm").setValue(srange);
				 atk.getNode("target-tas-kt").setValue(sspeed);
				}
			 else {
			     atk.getNode("target-bearing-nm").setValue(0);
			     atk.getNode("target-distance-nm").setValue(0);
				 atk.getNode("target-tas-kt").setValue(0);
				}
			}			 
		},
	 
	};
	
var iff = {
     loop: func {
	     var atk = props.globals.getNode("/computers/attack");
		 var contacts = atk.getNode("contacts").getChildren();
		 foreach(x; contacts) {
		     var status = 0;
			 var i = x.getIndex();
			 var desig = x.getNode("IFF");
			 var squawk = props.globals.getNode("/instrumentation/transponder/id-code").getValue();
			 var mpnode = props.globals.getNode("/ai/models/multiplayer["~i~"]");
			 var codenode = mpnode.getNode("instrumentation/transponder/transmitted-id");
			 if ( codenode != nil ) {
			     var code = codenode.getValue();
				 if ( squawk == code ) { status = 1; }
				}
			 desig.setValue(status);
			} 
	    },
	};

var loop = func {
     iff.loop();
	 attack.loop();
	 settimer(loop,0.5);
	}
	

	
setlistener("/sim/signals/fdm-initialized", pof.monitor);
setlistener("/sim/signals/fdm-initialized", loop);
