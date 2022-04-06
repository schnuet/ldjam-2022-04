extends Node2D

var current_room = null;

onready var rooms = get_tree().get_nodes_in_group("room");
onready var player = get_tree().get_nodes_in_group("player")[0];

func _ready():
	make_rooms_inactive();
	
	$Rooms.remove_child(player);
	change_room("Zimmer", Vector2(432, 304)); # change to Kueche
	
	player.state = "talking";
	
	yield(MessageSystem.show_message("player", "Oh no! Mom comes home and my room is dirty!", "neutral"), "done");
	yield(MessageSystem.show_message("player", "I've got to delay her arrival!", "neutral"), "done");
	
	player.state = "idle";

func change_room(room_name:String, player_position:Vector2):
	if current_room:
		deactivate_room(current_room);
	
	if player_position != Vector2.ZERO:
		player.global_position = player_position;
	
	var room = get_node("Rooms/" + room_name);
	
	activate_room(room);
	current_room = room;
	print("change room", room.name);

func activate_room(room:Node2D):
	room.get_node("TileMap").add_child(player);
	room.activate();

func deactivate_room(room:Node2D):
	room.deactivate();
	var tilemap = room.get_node("TileMap");
	if tilemap and player.get_parent() == tilemap:
		tilemap.remove_child(player);


func make_rooms_inactive():
	for room in rooms:
		deactivate_room(room);

func _on_Player_change_room(room_name, player_position):
	change_room(room_name, player_position);


func _on_ProgressBar_done():
	# delete player
	player.deactivate();
	
	print("progressbar done");
	change_room("Vorgarten", Vector2.ZERO);
	MusicPlayer.play_music("mom");
	
	yield(MessageSystem.show_message("mom", "Bob! I'm back!", "happy"), "done");
	
	$Rooms/Vorgarten/TileMap/Mom.activate();
	
	$Rooms/Zimmer/Boy.visible = true;
	
