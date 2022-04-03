extends Activatable

var took_rake = false;
var took_watercan = false;
var took_pot = false;

func start_action(player):
	player.state = "in_action";
	
	if !took_rake:
		player.pickup($Rake);
		took_rake = true;
	
	elif !took_watercan:
		player.pickup($WaterCan);
		took_watercan = true;
	
	elif !took_pot: 
		player.pickup($FlowerPot);
		took_pot = true;
		
	else:
		yield(MessageSystem.show_message("player", "There are no more tools in there."), "done");
	
	player.state = "idle";
