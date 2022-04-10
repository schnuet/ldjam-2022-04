extends MomArea

func action():
	var game = get_tree().get_nodes_in_group("game")[0];
	var mom = get_tree().get_nodes_in_group("mom")[0];
	
	var rooms = game.get_node("Rooms"); 
	var room_wohnzimmer = rooms.get_node("Wohnzimmer");
	var room_vorgarten = rooms.get_node("Vorgarten");
	
	rooms.remove_child(room_wohnzimmer);
	rooms.remove_child(room_vorgarten);
	
	mom.active_waypoint = null;
	mom.waypoints = [];
	
	mom.get_parent().remove_child(mom);

	game.change_room("Zimmer", Vector2.ZERO);
	game.get_node("Rooms/Zimmer/TileMap").add_child(mom);
	mom.position = Vector2(80, 80);
	
	var progress_bar = game.get_node("ProgressBar");
	progress_bar.pause();
	Globals.time_delayed = progress_bar.value / 100.0 * 135;
	
	return .action();
