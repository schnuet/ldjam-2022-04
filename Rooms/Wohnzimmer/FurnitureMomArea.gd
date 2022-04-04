extends MomArea

func action():
	if not Globals.said_living_room_comment:
		yield(MessageSystem.show_message("mom", "What the hell happened to my living room?", "neutral"), "done");
		Globals.said_living_room_comment = true;
	
	else:
		yield(MessageSystem.show_message("mom", "You're in the way.", "neutral"), "done");
	
	var furniture = get_parent();
	
	var mom = get_tree().get_nodes_in_group("mom")[0]
	
	var order = [];
	if mom.looking_dir == Vector2.DOWN:
		order = [Vector2.RIGHT, Vector2.LEFT, Vector2.DOWN, Vector2.UP];
	elif mom.looking_dir == Vector2.UP:
		order = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN];
	elif mom.looking_dir == Vector2.RIGHT:
		order = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT];
	elif mom.looking_dir == Vector2.LEFT:
		order = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT];
	
	var obj = false;
	for order_dir in order:
		obj = furniture.force_push(order_dir);
		if obj:
			break;
	
	if obj:
		yield(obj, "yeet_done");
		
	
	return .action();
