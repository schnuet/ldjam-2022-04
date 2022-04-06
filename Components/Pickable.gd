class_name Pickable

extends Activatable

func _ready():
	add_to_group("activatable");
	add_to_group("pickable");
	

func start_action(player):
	get_parent().remove_child(self);
	player.pickup(self);

func end_action(_player):
	pass

func on_drop():
	if has_node("Sound"):
		get_node("Sound").play();

func on_pickup():
	pass
