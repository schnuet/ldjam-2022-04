extends Node

const GRID_SIZE = 32;

var title_theme = preload("res://Assets/Music/Hold Up Mom Title Theme.ogg");
var mom_theme = preload("res://Assets/Music/Hold Up Mom Mom Theme.ogg");
var current_music = "";

onready var music_player = AudioStreamPlayer.new();

func _ready():
	# add music player
	get_tree().root.call_deferred("add_child", music_player);
	play_music("title");
	


func set_player_position(pos:Vector2):
	var player = get_tree().get_nodes_in_group("player")
	
	if player:
		player.global_position = pos


func play_music(music_name:String):
	if current_music == music_name:
		return;
	
	music_player.stop();
		
	if music_name == "mom":
		music_player.stream = title_theme;
	if music_name == "title":
		music_player.stream = mom_theme;
		
	music_player.play();
