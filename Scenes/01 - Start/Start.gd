extends Node2D

var bg_is_up = true;

func _ready():
	start_bg_anim();

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


func _on_Timer_timeout():
	$Title/IntroAnimation.frame = 0;
	$Title/IntroAnimation.play();

func start_bg_anim():
	if bg_is_up:
		bg_is_up = false;
		$MoveTween.interpolate_property($TitleScreenControl, "position:y", 0, -1024, 20, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1);
		$MoveTween.start();
	else:
		bg_is_up = true;
		$MoveTween.interpolate_property($TitleScreenControl, "position:y", -1024, 0, 20, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1);
		$MoveTween.start();


func _on_MoveTween_tween_all_completed():
	start_bg_anim();
