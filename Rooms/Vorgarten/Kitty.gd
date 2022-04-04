extends Activatable


func start_action(player):
	player.state = "in_action";
	
	var action = yield(OptionsScreen.show_options([
		{
			"text": "Pet the kitty",
			"id": "pet"
		},
		{
			"text": "Scare the kitty",
			"id": "scare"
		}
	]), "done");
	
	if action.id == "pet":
		yield(MessageSystem.show_message("player", "She likes that."), "done");
	
	elif action.id == "scare":
		yield(MessageSystem.show_message("player", "She ran away in the tree!"), "done");
		$CollisionShape2D.disabled = true;
		
		get_parent().get_node("KittyMomAreas/MomArea").activate();
		get_parent().get_node("KittyMomAreas/MomArea2").activate();
		
		global_position = Vector2(592, 304);
		
		remove_child($StaticBody2D);
		change_state("angry");
		var parent = get_parent();
		parent.remove_child(self);
		parent.get_parent().add_child(self);
	
	player.state = "idle";

func change_state(state:String):
	if state == "angry":
		$AnimatedSprite.animation = "angry";
	
	if state == "idle":
		$AnimatedSprite.animation = "idle";
