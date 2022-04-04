class_name Pickable

extends Area2D

func _ready():
	add_to_group("activatable");
	add_to_group("pickable");
	

func start_action(player):
	get_parent().remove_child(self);
	player.pickup(self);

func end_action(_player):
	pass

func on_drop():
	pass

func on_pickup():
	pass
