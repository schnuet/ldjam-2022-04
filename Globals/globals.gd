extends Node

const GRID_SIZE = 32;

var tv_channel = "off";
var phoned_person = "none";
var sprinkler_top_on = false;
var sprinkler_bottom_on = false;

func set_player_position(pos:Vector2):
	var player = get_tree().get_nodes_in_group("player")
	
	if player:
		player.global_position = pos
