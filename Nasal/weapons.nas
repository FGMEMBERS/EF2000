

# Armament Control Subsystem

# MP armament types

#mp_broadcast.BroadcastEventChannel.new("sim/multiplay/generic/string[4]");

var weights = props.globals.getNode("sim").getChildren("weight");




props.globals.initNode("/computers/weapons/stores/SRAAM", 0, "INT");
props.globals.initNode("/computers/weapons/stores/MRAAM", 0, "INT");
props.globals.initNode("/computers/weapons/stores/BVRAAM", 0, "INT");
props.globals.initNode("/computers/weapons/stores/cannon-rounds", 1).alias(props.globals.getNode("/systems/weapons/cannon/rounds"));
props.globals.initNode("/computers/weapons/stores/smoke", 0, "BOOL");

var init = func {
	 foreach (var s; weights) {
	 
	     var station = props.globals.getNode("computers/weapons/stations");
         	 
	     var stindex = s.getIndex();
		 var id = s.getNode("name").getValue();
	     props.globals.initNode("/sim/weight["~stindex~"]/mp-type-number", 0, "INT");
		 props.globals.initNode("/computers/weapons/stations/selected", -1, "INT");
		 props.globals.initNode("/computers/weapons/stations/station["~stindex~"]/load", "", "STRING");
		 props.globals.initNode("/computers/weapons/stations/station["~stindex~"]/name", id, "STRING");
		 props.globals.initNode("/computers/weapons/stations/station["~stindex~"]/type", "", "STRING");
		 props.globals.initNode("/computers/weapons/stations/station["~stindex~"]/mfd-type-number", 0, "INT");
		 props.globals.initNode("/systems/ACS/power", 0, "BOOL");
		 setlistener("/sim/weight["~stindex~"]/selected", report);
		 }
	 setlistener("/systems/electrical/outputs/acs", psu);
	 setlistener("/controls/armament/trigger", fire.cannon);
	}
	
var psu = func {
     var power = props.globals.getNode("/systems/electrical/outputs/acs");
     var serv = props.globals.getNode("/systems/ACS/serviceable");
	 var on = props.globals.getNode("/systems/ACS/power");
     var volts = power.getValue();
	 var working = serv.getBoolValue();
	 if ((working) and (volts > 100)) {
	     on.setBoolValue(1);
		 }
	 else {
	     on.setBoolValue(0);
		 }
	}
	
var report = func { 
     print("Something reported."); 
	     scan();
}

var mpscan = func {
     foreach (var b; weights) {
	     var loadind = b.getIndex();
		 var load = b.getNode("selected").getValue();
		 var mpind = ( loadind + 4 );
        }
	}

var scan = func {
     foreach (var a; weights) {
	     var loadind = a.getIndex();
		 var load = a.getNode("selected").getValue();
		 var mpind = ( loadind + 4 );
		
		 setprop("/computers/weapons/stations/station["~loadind~"]/load", load);
		 if ( load == "none" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(0);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "");
			    }
			}
		 if ( load == "Smokewinder" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(2);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "smoke");
			    }
			}
		 if ( load == "AIM-9" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(3);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "sraam");
			    }
			}
		 if ( load == "AMRAAM" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(6);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "sraam");
			    }
			}
		 if ( load == "1000l Droptank" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(7);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "fuel");
			    }
			}
			
		 if ( load == "2000l Droptank" ) {
		     var on = props.globals.getNode("/systems/ACS/power").getBoolValue();
			 a.getNode("mp-type-number").setValue(8);
			 if (on) {
			     setprop("/computers/weapons/stations/station["~loadind~"]/type", "fuel");
			    }
			}
		}
		
		# Add up and analyse the stores 
		
		var stations = props.globals.getNode("/computers/weapons/stations/").getChildren("station");
		var stores = props.globals.getNode("computers/weapons/stores");
		
	    var sraam = stores.getNode("SRAAM");
		var mraam = stores.getNode("MRAAM");
		var bvraam = stores.getNode("BVRAAM");
	    var smoke = stores.getNode("smoke");
		
	    sraam.setValue(0);
		mraam.setValue(0);
		bvraam.setValue(0);
		smoke.setBoolValue(0);
		
		foreach (var x; stations) {
		   var name = x.getNode("load").getValue();
		   var mfdtypenum = x.getNode("mfd-type-number");
		   mfdtypenum.setValue(0);
			
		   if ( name == "Smokewinder" ) {
		         smoke.setBoolValue(1);
				 mfdtypenum.setValue(4);
			} 
		   
		   if ( name == "AIM-9" ) {
			 var sraam_qty = sraam.getValue();
			 var newqty = ( sraam_qty + 1 );
			 sraam.setValue(newqty);
			 mfdtypenum.setValue(1);
			}
		   
		   if ( name == "ASRAAM" ) {
			     var sraam_qty = sraam.getValue();
			     var newqty = ( sraam_qty + 1 );
			     sraam.setValue(newqty);
				 mfdtypenum.setValue(1);
			}
			
			if ( name == "IRIS-T" ) {
			 var sraam_qty = sraam.getValue();
			 var newqty = ( sraam_qty + 1 );
			 sraam.setValue(newqty);
			 mfdtypenum.setValue(1);
			}
			
			if ( name == "AMRAAM" ) {
			 var mraam_qty = mraam.getValue();
			 var newqty = ( mraam_qty + 1 );
			 mraam.setValue(newqty);
			 mfdtypenum.setValue(2);
			}
			
			if ( name == "Meteor" ) {
			 var bvraam_qty = bvraam.getValue();
			 var newqty = ( bvraam_qty + 1 );
			 bvraam.setValue(newqty);
			 mfdtypenum.setValue(3);
			}		
		
			if ( name == "1000l Droptank" ) {
			 var bvraam_qty = bvraam.getValue();
			 var newqty = ( bvraam_qty + 1 );
			 bvraam.setValue(newqty);
			 mfdtypenum.setValue(5);
			}
			
			if ( name == "2000l Droptank" ) {
			 var bvraam_qty = bvraam.getValue();
			 var newqty = ( bvraam_qty + 1 );
			 bvraam.setValue(newqty);
			 mfdtypenum.setValue(6);
			}
		
		# To be continued
		
	    }
	
	}
  
	 
var pulse = func(x) {
     var loadtype = getprop("/computers/weapons/stations/station["~x~"]/type");
	 if ( loadtype == "smoke") {
	     var smokeon = getprop("/systems/weapons/display-smoke");
		 if (smokeon) { setprop("/systems/weapons/display-smoke", 0); }
		 if (!smokeon) { setprop("/systems/weapons/display-smoke", 1); }
	    }
	}
	 
var release = func {
     var masslive = getprop("/controls/armament/master-arm");
	 if (masslive) {		 
		 var sel = getprop("/computers/weapons/stations/selected");
		 if ( sel > -1 ) {
		     weapons.pulse(sel);
			 }
	    }
	 else {
	     warnings.alert.trigger("mass-not-live");
		}
    }

		
var fire = {
     cannon: func {
	     var serv = props.globals.getNode("/systems/weapons/cannon/serviceable").getBoolValue();
	     var volts = props.globals.getNode("/systems/electrical/outputs/armament/cannon").getValue();
	     var hydr = 280; # Temporary value until HYD system coded
	     var mass = props.globals.getNode("/controls/armament/master-arm").getBoolValue();
	     var rounds = props.globals.getNode("/systems/weapons/cannon/rounds").getValue();
		 var trigger = props.globals.getNode("/controls/armament/trigger", 1).getBoolValue();
		 
		 if (serv) {
		     if ((volts > 100) and (hydr > 250)) {
			     if (mass) {
				     if ( rounds > 0 ) {
                         fire.cannon_rounds();
						}
					 else {
					     setprop("/systems/weapons/cannon/firing", 0);
						}
					}
				 else {
				     warnings.alert.trigger("mass-not-live");
					}
				}
	        }
		},
     cannon_rounds: func {
		 var rounds = props.globals.getNode("/systems/weapons/cannon/rounds").getValue();
		 var trigger = props.globals.getNode("/controls/armament/trigger").getBoolValue();
		 var newrds = ( rounds - 1 );
		 setprop("/systems/weapons/cannon/rounds", newrds);
		 
		 if ((trigger) and (newrds > 0)) { 
		     settimer(fire.cannon_rounds, 0.033); 
			 setprop("/systems/weapons/cannon/firing", 1);
			}
		 else {
		     setprop("/systems/weapons/cannon/firing", 0);
			 }
	 },
	 missile: func {
	     print("Can't, sorry.");
	    }
	 
	};

setlistener("sim/signals/fdm-initialized", init);
