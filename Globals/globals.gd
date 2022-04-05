extends Node

const GRID_SIZE = 32;

var tv_channel = "off";
var phoned_person = "none";
var sprinkler_top_on = false;
var sprinkler_bottom_on = false;

var said_living_room_comment = false;

var said_holding_on_message = false;

var cake_on_table = false;

var ingredients_on_counter = {
	"Flour": true,
	"Eggs": true,
	"Milk": false,
	"Bowl": false
};

func reset():
	tv_channel = "off";
	phoned_person = "none";
	
	sprinkler_top_on = false;
	sprinkler_bottom_on = false;
	
	said_living_room_comment = false;
	
	cake_on_table = false;
	ingredients_on_counter = {
		"Flour": true,
		"Eggs": true,
		"Milk": false,
		"Bowl": false
	};

func set_player_position(pos:Vector2):
	var player = get_tree().get_nodes_in_group("player")
	
	if player:
		player.global_position = pos
