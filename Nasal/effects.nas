# effects2.nas
# general effects for aircraft
# tiresmoke /engine-smoke / wingtip-vortex / contrail
# aok1 2010/11

#######################################################
### Tyresmoke (copied from seahawk --credits there) ###
#######################################################
# does not run in repeat?
 
var run_tyresmoke0 = 0;
var run_tyresmoke1 = 0;
var run_tyresmoke2 = 0;

var tyresmoke_0 = aircraft.tyresmoke.new(0);
var tyresmoke_1 = aircraft.tyresmoke.new(1);
var tyresmoke_2 = aircraft.tyresmoke.new(2);

# listeners
setlistener("gear/gear[0]/position-norm", func {
	var gear = getprop("gear/gear[0]/position-norm");
	
	if (gear == 1 ){
		run_tyresmoke0 = 1;
	}else{
		run_tyresmoke0 = 0;
	}

	},
	1,
	0);

setlistener("gear/gear[1]/position-norm", func {
	var gear = getprop("gear/gear[1]/position-norm");
	
	if (gear == 1 ){
		run_tyresmoke1 = 1;
	}else{
		run_tyresmoke1 = 0;
	}

	},
	1,
	0);

setlistener("gear/gear[2]/position-norm", func {
	var gear = getprop("gear/gear[2]/position-norm");
	
	if (gear == 1 ){
		run_tyresmoke2 = 1;
	}else{
		run_tyresmoke2 = 0;
	}

	},
	1,
	0);	
	
var tiresmoke = func {
	if (run_tyresmoke0){tyresmoke_0.update();}
	if (run_tyresmoke1){tyresmoke_1.update();}
	if (run_tyresmoke2){tyresmoke_2.update();}
	settimer(tiresmoke, 0);
}
tiresmoke();

############################################################
### engine-smoke (copied from buccaneer --credits there) ###
############################################################

n1_node = props.globals.getNode("engines/engine/n1", 1);
smoke_node = props.globals.getNode("engines/engine/smoking", 1);
smoke_node.setBoolValue(1);

smoke_0 = nil;
smoke_1 = nil;

Smoke = {
	new : func (number,
				){
		var obj = {parents : [Smoke] };
		obj.name = "smoke " ~ number;
		obj.n1 = props.globals.getNode("engines/engine[" ~ number ~"]/n1", 1);
		obj.smoking = props.globals.getNode("engines/engine[" ~ number ~"]/smoking", 1);
		obj.smoking.setBoolValue(0);
		obj.old_n1 = 0;
		return obj;
	},

	updateSmoking: func {		
		var n1 = me.n1.getValue();
		if (n1 == nil) {n1 = 0; }
		var smoke = me.smoking.getValue();
		var diff = 0;
		
		diff = math.abs(n1 - me.old_n1);
		
		if (n1 <= 65 or diff > 0.1) {
			smoke = 1;
		} else {
			smoke = 0;
		}	
		me.smoking.setBoolValue(smoke);
		me.old_n1 = n1;
	 },
}; 

var init_smoke = func {
	smoke_0 = Smoke.new(0);
	smoke_1 = Smoke.new(1);
	settimer(update, 1)
	}
	
var update = func {
	smoke_0.updateSmoking();
	smoke_1.updateSmoking();	
	settimer(update, 1)	
}
init_smoke();

######################
### wingtip-vortex ###
######################

var vortex = props.globals.getNode("sim/multiplay/generic/int[3]", 1);
var alpha_node = props.globals.getNode("orientation/alpha-deg");
var speed_node = props.globals.getNode("velocities/airspeed-kt");
var crashed_node = props.globals.getNode("sim/crashed");
var hum_node = props.globals.getNode("environment/relative-humidity");
var tempc_node = props.globals.getNode("environment/temperature-degc");
var ail_node = props.globals.getNode("controls/flight/aileron");
var elev_node = props.globals.getNode("controls/flight/elevator");

var wingtip = func {

	var alpha = alpha_node.getValue();
	var speed = speed_node.getValue();
	var tempc = tempc_node.getValue();
	var ail = ail_node.getValue();
	var elev = elev_node.getValue();
	var crashed = crashed_node.getValue();
	var hum = hum_node.getValue();

	if (speed > 120 and !crashed and tempc > 0) {
		#if (alpha > 8.6 or (hum > 98 and ail != 0 or elev != 0)) { 
		if (alpha > 8.6 or (hum > 98 and ail != 0)) {
			vortex.setValue(1);
		} else { 
			vortex.setValue(0);
		}
	} else { 
			vortex.setValue(0);
		}
	settimer(wingtip, 0.3)
}
wingtip();


## do a more frequent update for contrail
## hijacking update from contrail.nas

var pressure_Node = props.globals.getNode("environment/pressure-inhg");
var temperature_Node = props.globals.getNode("environment/temperature-degc");
var contrail_Node = props.globals.getNode("environment/contrail");
var contrail_temp_Node = props.globals.getNode("environment/contrail-temperature-degc");

contrail.updateContrail = func {
    var x = pressure_Node.getValue();
    var y = temperature_Node.getValue();
    var con_temp = -0.077 * x * x + 2.7188 * x - 64.36;
    contrail_temp_Node.setValue(con_temp);

    if (y < con_temp and y < -40){
            contrail_Node.setValue(1);
        } else {
            contrail_Node.setValue(0);
        }
     settimer(contrail.updateContrail,1);          
}

