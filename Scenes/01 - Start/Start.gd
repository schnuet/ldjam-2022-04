extends Node2D

func _ready():
	$Title/IntroAnimation.frame = 0;
	$Title/IntroAnimation.play();

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/02 - Game/Game.tscn");


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/99 - Credits/Credits.tscn");


func _on_IntroAnimation_animation_finished():
	$Title/IntroAnimation.playing = false;
	$Title/IdleAnimation.show();
	$Title/IntroAnimation.hide();
	$Title/IdleAnimation.play();

func _input(_event):
	if not $CanvasLayer/VBoxContainer.get_focus_owner():
		if Input.is_action_pressed("action"):
			_on_StartButton_pressed();
		if Input.is_action_just_released("ui_focus_next"):
			$CanvasLayer/VBoxContainer/StartButton.grab_focus();
