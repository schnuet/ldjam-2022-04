extends Area2D

var chosen_channel_id = "off";

func start_action(player):
	player.state = "in_action";
	# player.state = "talking";
	
	var options = [];
	if chosen_channel_id != "history":
		options.append({
			"text": "Turn on the history channel",
			"name": "history channel",
			"id": "history"
		});
	if chosen_channel_id != "xbox":
		options.append({
			"text": "Turn on the Xbox 360",
			"name": "Xbox",
			"id": "xbox"
		});
	if chosen_channel_id != "housewife":
		options.append({
			"text": "Turn on the housewife channel",
			"name": "housewife channel",
			"id": "housewife"
		});
	if chosen_channel_id != "off":
		options.append({
			"text": "Turn TV off",
			"name": "off",
			"id": "off"
		});
	
	var chosen_channel = yield(OptionsScreen.show_options(options), "done");
	
	chosen_channel_id = chosen_channel.id;
	
	if chosen_channel_id != "off":
		$Sprite.animation = "on";
		yield(MessageSystem.show_message("player", "I turned on the " + chosen_channel.name + "."), "done");
	else:
		$Sprite.animation = "off";
		yield(MessageSystem.show_message("player", "I turned the TV off."), "done");
	
	Globals.tv_channel = chosen_channel.id;
	
	player.state = "idle";

func end_action(_player):
	pass
