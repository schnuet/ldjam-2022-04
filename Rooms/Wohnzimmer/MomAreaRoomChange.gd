extends MomArea

func action():
	var game = get_tree().get_nodes_in_group("game")[0];
	var mom = get_tree().get_nodes_in_group("mom")[0];
	
	mom.waypoints = [];
	
	mom.get_parent().remove_child(mom);
	game.get_node("Rooms/Kueche/TileMap").add_child(mom);
	mom.position = Vector2(720, 80);
	game.change_room("Kueche", Vector2.ZERO);
	return .action();
