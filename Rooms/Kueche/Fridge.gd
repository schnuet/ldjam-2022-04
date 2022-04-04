extends Activatable

var has_milk = true;

func start_action(player):
	player.state = "action";
	
	if has_milk:
		player.state = "talking";
		yield(MessageSystem.show_message("player", "There's milk here."), "done");
		player.pickup($Milk);
		has_milk = false;
	else:
		yield(MessageSystem.show_message("player", "Fridge is empty."), "done");
		yield(MessageSystem.show_message("player", "Mom didn't buy food."), "done");
	
	player.state = "idle";
