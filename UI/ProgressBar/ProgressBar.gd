extends Node2D

signal done

var texture_80 = preload("res://UI/ProgressBar/status_0.png");
var texture_60 = preload("res://UI/ProgressBar/status_1.png");
var texture_40 = preload("res://UI/ProgressBar/status_2.png");
var texture_20 = preload("res://UI/ProgressBar/status_3.png");
var texture_00 = preload("res://UI/ProgressBar/status_4.png");
var current_texture = texture_80;

export var value = 100 setget set_value;

func _ready():
	$Tween.interpolate_property(self, "value", 100, 0, 150, Tween.TRANS_LINEAR);
	$Tween.start();
	
	update_rect();

func set_value(val):
	value = val;
	update_rect();

func update_rect():
	
	if value >= 80:
		current_texture = texture_80;
	elif value >= 60:
		current_texture = texture_60;
	elif value >= 40:
		current_texture = texture_40;
	elif value >= 20:
		current_texture = texture_20;
	else:
		current_texture = texture_00;
	
	if is_inside_tree() and $Control/NinePatchRect:
		$Control/NinePatchRect.texture = current_texture;
		
		var height = ceil(455 * value / 100);
		$Control/NinePatchRect.set_size(Vector2(43, height));
		$Control/NinePatchRect.set_position(Vector2(0, 455 - height));
		


func _on_Tween_tween_all_completed():
	emit_signal("done");
