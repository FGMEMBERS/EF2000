
## Additional Waypoint Code

var getWPData = func {

     var rmgr = props.globals.getNode("autopilot/route-manager");
	 var routepath = rmgr.getNode("file-path").getValue();
	 var data = io.read_properties(routepath);
	 
	 var wps = data.getNode("route").getChildren("wp");
	 
	 foreach (w; wps) {
	     
		 if ( w.getName() != "num" ) {
		 
		 var index = w.getIndex();
		 
		 # Class
		 var class = w.getNode("class").getValue();
		 if (class != nil) { props.globals.initNode("/autopilot/route-manager/route/wp["~index~"]/class", class, "STRING"); }
		 
		 # Time
		 var time = w.getNode("scheduled-time");
		 
		 var hour = time.getNode("hour").getValue();
		 var minute = time.getNode("minute").getValue();
		 var second = time.getNode("second").getValue();
		 if (hour != nil) { rmgr.initNode("route/wp["~index~"]/hour", class, "STRING"); }
		 if (minute != nil) { rmgr.initNode("route/wp["~index~"]/minute", class, "STRING"); }
		 if (second != nil) { rmgr.initNode("route/wp["~index~"]/second", class, "STRING"); }
		 
		 var daysec = (( hour * 3600 ) + ( minute * 60 ) + (second));
		 if (daysec != nil) { rmgr.initNode("route/wp["~index~"]/day-seconds", class, "STRING"); }
		}
		
		}
	}
	
var delay = func {
     settimer(getWPData, 1.5);
    }	 
	
setlistener("autopilot/route-manager/file-path", delay);
