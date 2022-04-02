extends Node2D

signal change_room(room_name, coordinates);

func deactivate():
	set_process(false);
	set_physics_process(false);
	hide();
	position = Vector2(50000, 10000);

func activate():
	set_process(false);
	set_physics_process(false);
	show();
	position = Vector2.ZERO;
