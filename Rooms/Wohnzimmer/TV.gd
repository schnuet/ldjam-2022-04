extends Area2D

func start_action(player):
	player.state = "talking";
	
	yield(MessageSystem.show_message("player", "Turn on the history channel."), "done");

	
	player.state = "idle";

func end_action(player):
	pass
