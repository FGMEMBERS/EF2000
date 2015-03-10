
props.globals.initNode("/orientation/inverted", 0, "BOOL");

## Fuel Probe

var fuel_probe = func {
   var fuel_probe_switch = getprop("controls/switches/fuel-probe");
   if ( fuel_probe_switch == 1 ) { interpolate("/sim/multiplay/generic/float[10]", 1, 6.5); }
   if ( fuel_probe_switch == 0 ) { interpolate("/sim/multiplay/generic/float[10]", 0, 6.5); }
   }
   
setlistener("/controls/switches/fuel-probe", fuel_probe);

## Canopy

var canopy_time = 8;
var canopy = func {
   var canopy_switch = getprop("controls/switches/canopy");
   if ( canopy_switch == 1 ) { interpolate("/canopy/position-norm", 1, canopy_time); }
   if ( canopy_switch == 0 ) { interpolate("/canopy/position-norm", 0, canopy_time); }
   }

# Canopy Sound

var canopy_sound = func {
   var int = getprop("/sim/current-view/internal");
   var can_pos = getprop("/canopy/position-norm");
      if (int) { var notext = 0 } else { var notext = 1 };
	  var vol_out = ( can_pos + notext );
	  setprop("/sim/sound/canopy-view-modifier", vol_out);
   settimer(canopy_sound, 0.05);
}

setlistener("/controls/switches/canopy", canopy);
setlistener("/sim/signals/fdm-initialized", canopy_sound);

## Lights
 
# Strobe

strobe_switch = props.globals.getNode("/sim/multiplay/generic/float[3]");
aircraft.light.new("/sim/model/EF2000/lights/strobe-upper", [0.02, 1.8]);
aircraft.light.new("/sim/model/EF2000/lights/strobe-lower", [0.02, 2.2]);

# Inverted Property

var invpos = func {
   rolldeg = getprop("/orientation/roll-deg");
   if ( ( rolldeg < -150 ) or ( rolldeg > 150 ) ) {
      setprop("/orientation/inverted", 1); }
   else {
      setprop("/orientation/inverted", 0); }
   settimer(invpos,0.25);
   }

setlistener("/sim/signals/fdm-initialized", invpos);

props.globals.initNode("/sim/time/aura-setting", 0.2, "DOUBLE");
var lightaura = func {
	 var rad = getprop("/sim/time/sun-angle-rad");
	 var fact = ((( 1 / rad ) * 1.25) - 0.25);
	 setprop("/sim/time/aura-dimming", fact);
	 settimer(lightaura, 2);
	 }
setlistener("/sim/signals/fdm-initialized", lightaura);

# Fuel Vent

var fuel_vent = func {
   fvalt = getprop("/position/altitude-ft");
   fvspd = getprop("/velocities/groundspeed-kt");
   fvinv = getprop("/orientation/inverted");
   fvdump = getprop("/consumables/fuel/dump-valve");
   if ((fvalt > 400) and (fvspd > 100)) {
      if ((fvinv) or (fvdump)) {
	     setprop("/sim/multiplay/generic/int[19]", 1);
		 }
	  else {
	     setprop("/sim/multiplay/generic/int[19]", 0);
	     }
	 }
   settimer(fuel_vent, 1);
   }

setlistener("/sim/signals/fdm-initialized", fuel_vent);   

# Canard Park

var canard_park = func {
   var park_angle = 0.8;
   var enable = getprop("/systems/FCS/internal/canard-park");
   var wow = getprop("/gear/gear[0]/wow");
   if (enable and wow) { 
      setprop("/systems/FCS/internal/canard-parked", 1);
      interpolate("/systems/FCS/internal/canard-park-angle", park_angle, 6);
	  }
   if (!enable) {
      interpolate("/systems/FCS/internal/canard-park-angle", 0, 3);
	  settimer( func { 
	     setprop("/systems/FCS/internal/canard-parked", 0);
		 }, 4);
   }
}
   
setlistener("/systems/FCS/internal/canard-park", canard_park);

# Dialogs



   