extends Node2D

var action_pressed = false;

signal room_entered;
signal room_left;

func deactivate():
	set_process(false);
	set_physics_process(false);
	hide();
	position = Vector2(50000, 10000);
	emit_signal("room_left");

func activate():
	set_process(false);
	set_physics_process(false);
	show();
	position = Vector2.ZERO;
	emit_signal("room_entered");
