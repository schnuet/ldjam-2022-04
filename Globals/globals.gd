extends Node

const GRID_SIZE = 32;

var tv_channel = "none";
var phoned_person = "none";

func set_player_position(pos:Vector2):
	var player = get_tree().get_nodes_in_group("player")
	
	if player:
		player.global_position = pos
