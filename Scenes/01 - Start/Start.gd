extends Node2D

func _ready():
	$Title/IntroAnimation.frame = 0;
	$Title/IntroAnimation.play();
	
	$CanvasLayer/HBoxContainer/StartButton.grab_focus();

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/02 - Game/Game.tscn");


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/99 - Credits/Credits.tscn");


func _on_IntroAnimation_animation_finished():
	$Title/IntroAnimation.playing = false;
	$Title/IdleAnimation.show();
	$Title/IntroAnimation.hide();
	$Title/IdleAnimation.play();
