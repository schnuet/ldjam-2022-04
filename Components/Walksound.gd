extends Area2D

export var stream:AudioStream;

func _ready():
	$Sound.stream = stream;

func _on_Walksound_area_entered(area):
	if area.name == "Player" or area.name == "Mom":
		$Sound.play();


func _on_Walksound_area_exited(area):
	$Sound.stop();
