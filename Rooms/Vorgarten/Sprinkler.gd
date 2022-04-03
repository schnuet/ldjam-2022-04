extends Activatable

var on = false;

func start_action(player):
	player.state = "talking";
	
	if not on:
		on = true;
		yield(MessageSystem.show_message("player", "I turned the sprinkler on!"), "done");
	else:
		on = false;
		yield(MessageSystem.show_message("player", "I turned the sprinkler off!"), "done");
	
	player.state = "idle";
