extends Node2D

var current_room = null;
onready var rooms = get_tree().get_nodes_in_group("room");

onready var player = get_tree().get_nodes_in_group("player")[0];

func _ready():
	make_rooms_inactive();
	
	change_room("Zimmer", Vector2(400, 272));

func change_room(room_name:String, player_position:Vector2):
	if current_room:
		deactivate_room(current_room);
	
	player.global_position = player_position;

	var room = get_node("Rooms/" + room_name);
	
	activate_room(room, current_room);
	current_room = room;

func activate_room(room:Node2D, room_from):
	var old_room_name = "";
	if room_from:
		old_room_name = room_from.name;
	
	room.activate();

func deactivate_room(room:Node2D):
	room.deactivate();


func make_rooms_inactive():
	for room in rooms:
		deactivate_room(room);


func _on_Vorgarten_change_room(room_name, player_position:Vector2):
	change_room(room_name, player_position);


func _on_Kueche_change_room(room_name, player_position:Vector2):
	change_room(room_name, player_position);


func _on_Wohnzimmer_change_room(room_name, player_position:Vector2):
	change_room(room_name, player_position);


func _on_Zimmer_change_room(room_name, player_position:Vector2):
	change_room(room_name, player_position);


func _on_Player_change_room(room_name, player_position):
	change_room(room_name, player_position);
