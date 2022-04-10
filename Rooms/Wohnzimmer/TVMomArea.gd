extends MomArea

func action():
	var mom = get_tree().get_nodes_in_group("mom")[0];
	
	var sprite = mom.get_node("AnimatedSprite");
	
	sprite.animation = "walk_down";
	sprite.stop();
	sprite.frame = 0;
	
	if Globals.tv_channel == "housewife":
		yield(MessageSystem.show_message("mom", "Oh, the housewife channel, I really enjoy their stuff! I might watch a bit...", "happy"), "done");
	if Globals.tv_channel == "history":
		yield(MessageSystem.show_message("mom", "Oh, the history channel, I don’t really enjoy their stuff... I just turn it off!", "neutral"), "done");
	if Globals.tv_channel == "xbox":
		yield(MessageSystem.show_message("mom", "Oh, my son forgot to turn his Nintendo off, He is just like his father!", "mad"), "done");
		Globals.aggro_b_xbox = 1;
	
	return .action();
	
