extends "../Room.gd"



func _on_Restart_pressed():
	Globals.reset();
	MusicPlayer.play_music("title");
	get_tree().reload_current_scene();


func _on_Credits_pressed():
	Globals.reset();
	MusicPlayer.play_music("title");
	get_tree().change_scene("res://Scenes/99 - Credits/Credits.tscn");


func _input(_event):
	if Input.is_action_just_released("action"):
		action_pressed = false;
		
	var mom = get_tree().get_nodes_in_group("mom")[0];
	if mom.active:
		return;
	
	var player_nodes = get_tree().get_nodes_in_group("player");
	if player_nodes.size() == 0:
		return;
	
	var player = player_nodes[0];
	
	if player.get_parent() != $TileMap:
		return;

	
	if player.state != "idle":
		return;
		
	if not action_pressed and Input.is_action_just_pressed("action"):
		player.state = "talking";
		yield(MessageSystem.show_message("bob", "I have to leave my room to delay mom!", "happy"), "done");
		yield(MessageSystem.show_message("bob", "No time for cleaning up!", "happy"), "done");
		player.state = "idle";
		action_pressed = true;
