
var key = func(n) {
   var curr_entry = getprop("/instrumentation/MDEF/keypad/current-entry");
   var entry_plus = ( curr_entry + 1 );
   setprop("/instrumentation/MDEF/keypad/entry[" ~ curr_entry ~ "]", n);
   setprop("/instrumentation/MDEF/keypad/current-entry", entry_plus);
}

var clear = func {
   setprop("/instrumentation/MDEF/keypad/entry[0]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[1]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[2]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[3]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[4]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[5]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[6]", "~");
   setprop("/instrumentation/MDEF/keypad/entry[7]", "~");
   setprop("/instrumentation/MDEF/keypad/mag-true", "");
   setprop("/instrumentation/MDEF/keypad/kts-mach", "");
   setprop("/instrumentation/MDEF/keypad/current-entry", 0);
}

var tacan_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   setprop("/instrumentation/tacan/frequencies/selected-channel[1]", e1);
   setprop("/instrumentation/tacan/frequencies/selected-channel[2]", e2);
   setprop("/instrumentation/tacan/frequencies/selected-channel[3]", e3);
   setprop("/instrumentation/tacan/frequencies/selected-channel[4]", e4);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var chan_m1_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var e6 = getprop("/instrumentation/MDEF/keypad/entry[5]");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5 ~ e6;
   setprop("/systems/CAMU/channel-list/channel[8]/frequency", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var hdg_enter = func {

   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var e6 = getprop("/instrumentation/MDEF/keypad/entry[5]");
   var mt = getprop("/instrumentation/MDEF/keypad/mag-true");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5 ~ e6; 
   if ( mt != "" ) {
         setprop("/systems/autopilot/settings/heading-mode", mt );
         setprop("/systems/autopilot/settings/target-heading-deg", entry);
         setprop("/instrumentation/MDEF/keypad-page-selected", "");  
   clear();
   }
}

var hdg_true_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var e6 = getprop("/instrumentation/MDEF/keypad/entry[5]");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5 ~ e6;
   setprop("/systems/autopilot/settings/target-heading-true-deg", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");  
  clear();
}

var alt_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5;
   setprop("/systems/autopilot/settings/target-altitude-ft", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var agl_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5;
   setprop("/systems/autopilot/settings/target-altitude-agl-ft", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var spdkt_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5;
   setprop("/systems/autopilot/settings/target-speed-kt", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var spdm_enter = func {
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var entry = e1 ~ e2 ~ e3 ~ e4;
   setprop("/systems/autopilot/settings/target-speed-mach", entry);
   setprop("/instrumentation/MDEF/keypad-page-selected", "");
   clear();
}

var crs_enter = func {
   var step = getprop("/instrumentation/MDEF/keypad/step");
   var e1 = getprop("/instrumentation/MDEF/keypad/entry[0]");
   var e2 = getprop("/instrumentation/MDEF/keypad/entry[1]");
   var e3 = getprop("/instrumentation/MDEF/keypad/entry[2]");
   var e4 = getprop("/instrumentation/MDEF/keypad/entry[3]");
   var e5 = getprop("/instrumentation/MDEF/keypad/entry[4]");
   var mt = getprop("/instrumentation/MDEF/keypad/mag-true");
   var km = getprop("/instrumentation/MDEF/keypad/kts-mach");
   var entry = e1 ~ e2 ~ e3 ~ e4 ~ e5;
     if ( step == 1 ) {
		if ( entry != "~~~~~" ) {
		   setprop("/instrumentation/MDEF/keypad/course-mode/target-heading-deg", entry);
           setprop("/instrumentation/MDEF/keypad/course-mode/heading-mode", mt);
	       setprop("/instrumentation/MDEF/keypad/step", 2);  
		   }
		if (entry == "~~~~~" ) {
		   var blank = getprop("/systems/autopilot/settings/target-heading-deg");
		   setprop("/instrumentation/MDEF/keypad/course-mode/target-heading-deg", blank);
		   }
	   };
	 if ( step == 2 ) {
        setprop("/instrumentation/MDEF/keypad/course-mode/target-altitude-ft", entry);
	    setprop("/instrumentation/MDEF/keypad/step", 3);  
	   };
	 if ( step == 3 ) {
        if ( km == "kts" ) {setprop("/instrumentation/MDEF/keypad/course-mode/target-speed-kt", entry); }
	    if ( km == "mach" ) {setprop("/instrumentation/MDEF/keypad/course-mode/target-speed-mach", entry); }
		setprop("/instrumentation/MDEF/keypad/course-mode/kts-mach", km);  
		setprop("/instrumentation/MDEF/keypad/step", 4);  
	   };
	 if ( step == 4 ) {
	    var cmhdg = getprop("/instrumentation/MDEF/keypad/course-mode/target-heading-deg");
        var cmalt = getprop("/instrumentation/MDEF/keypad/course-mode/target-altitude-ft");
		var cmkts = getprop("/instrumentation/MDEF/keypad/course-mode/target-speed-kt");
		var cmmach = getprop("/instrumentation/MDEF/keypad/course-mode/target-speed-mach");
		var cmhdgmode = getprop("/instrumentation/MDEF/keypad/course-mode/heading-mode");
		var cmktsm = getprop("/instrumentation/MDEF/keypad/course-mode/kts-mach");
		setprop("/systems/autopilot/settings/target-heading-deg", cmhdg);
		setprop("/systems/autopilot/settings/heading-mode", cmhdgmode);
		setprop("/systems/autopilot/settings/target-altitude-ft", cmalt);
		setprop("/systems/autopilot/settings/kts-mach-select", cmktsm);
		if ( cmktsm == "kts" ) {
		   setprop("/systems/autopilot/settings/target-speed-kt", cmkts);
		   };
		if ( cmktsm == "mach" ) {
		   setprop("/systems/autopilot/settings/target-speed-mach", cmmach);
		   };
	    setprop("/instrumentation/MDEF/keypad/step", 1);
		setprop("/instrumentation/MDEF/keypad-page-selected", "");
	    };
	   clear();
			
}

var current_hdg = func {
   var maghdg = getprop("/orientation/heading-magnetic-deg");
   var truhdg = getprop("/orientation/heading-deg");
   var magtru = getprop("/systems/autopilot/settings/heading-mode");
   if ( magtru == "mag" ) { setprop("/systems/autopilot/settings/target-heading-deg", maghdg); }
   if ( magtru == "true" ) { setprop("/systems/autopilot/settings/target-heading-deg", truhdg); }
}

var rcp_hdg = func {
   var hdg = getprop("/systems/autopilot/settings/target-heading-deg");
   var hdgadjminus = ( hdg - 180 );
   var hdgadjplus = ( hdg + 180 );
   if ( hdg > 180 ) {
      setprop("/systems/autopilot/settings/target-heading-deg", hdgadjminus);
	  }
   else {
      setprop("/systems/autopilot/settings/target-heading-deg", hdgadjplus);
	  }
}
