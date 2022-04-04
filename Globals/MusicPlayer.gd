extends AudioStreamPlayer

var title_theme = preload("res://Assets/Music/Hold Up Mom Title Theme.ogg");
var mom_theme = preload("res://Assets/Music/Hold Up Mom Mom Theme.ogg");
var current_music = "";

func _ready():
	play_music("title");

func play_music(music_name:String):
	if current_music == music_name:
		return;
	
	stop();
	
	if music_name == "mom":
		stream = mom_theme;
	if music_name == "title":
		stream = title_theme;
		
	play();
