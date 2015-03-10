
## EF2000 FCS Nasal

print("Initialising Flight Control System...");

var powersource = "/systems/electrical/outputs/FCS" ; 
var fcs_branch = "/systems/FCS" ;

var pout = 0;
var rout = 0;
var wow = 0;

var FCS = props.globals.getNode(fcs_branch);
var att = FCS.getNode("internal/attitude");

# Functions

var init = func {
     settimer(loop, 5);
	}
		
var loop = func {

    # Zero variables
	 
	 wow = 0;
	 
	 pout = 1.3;
	 rout = 0;
	 
	 var rollrate = 2;

     var pof = props.globals.getNode("computers/phase-of-flight-num").getValue();
     var gear = props.globals.getNode("gear");
     var gearl = gear.getNode("gear[1]/wow").getValue();
     var gearr = gear.getNode("gear[2]/wow").getValue();
   
    # Weight on Wheels
   
     if ( gearl and gearr ) {
         wow = 1;
	    } 
   
   # Pitch & Roll
   
     var p = att.getNode("pitch-deg").getValue();
     var pa = att.getNode("pitch-adjust").getValue();
     var r = att.getNode("roll-deg").getValue();
     var ra = att.getNode("roll-adjust").getValue();
     var inverted = att.getNode("inverted").getBoolValue();
   
   # Check Phase of Flight and Weight on Wheels
   
     if ( pof > 1 ) { 
	     pout = ( p +  pa ); 	 
	    }
		
     if (!wow) {
	     rout = ( r + ( ra * rollrate ));
        }
       
     setprop("/systems/FCS/internal/attitude/pitch-deg", pout);
     setprop("/systems/FCS/internal/attitude/roll-deg", rout);
   
    # ...and repeat!
   
   settimer(loop,0.033);
   }
   
settimer(init, 10);