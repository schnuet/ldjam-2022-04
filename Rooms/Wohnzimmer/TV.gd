extends Area2D

func start_action(player):
	player.state = "in_action";
	# player.state = "talking";
	
	var chosen_channel = yield(OptionsScreen.show_options([
		{
			"text": "Turn on the history channel",
			"channel_name": "history channel",
			"id": "history"
		},
		{
			"text": "Turn on the Xbox 360",
			"channel_name": "Xbox",
			"id": "xbox"
		},
		{
			"text": "Turn on the housewife channel",
			"channel_name": "housewife channel",
			"id": "housewife"
		}
	]), "done");
	
	yield(MessageSystem.show_message("player", "I turned on the " + chosen_channel.channel_name + "."), "done");
	
	Globals.tv_channel = chosen_channel.id;
	
	player.state = "idle";

func end_action(_player):
	pass
