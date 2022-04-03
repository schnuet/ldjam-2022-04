extends Activatable

var items_inside = [];

func drop(item:Node2D, player):
	player.state = "talking";
	
	items_inside.append(item);
	
	if item.name == "Egg":
		yield(MessageSystem.show_message("player", "I put the egg into the oven."), "done");
	
	player.state = "idle";

func start_action(player):
	player.state = "talking";
	if items_inside.size() > 0:
		player.pickup(items_inside.pop_back());
	
	else:
		yield(MessageSystem.show_message("player", "The oven is empty."), "done");
	player.state = "idle";
