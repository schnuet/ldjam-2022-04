extends Activatable

func can_drop(item):
	if item.name != "Cake":
		return "Only cake belongs on this table.";
	
	return "true";

func drop(item, _player):
	Globals.cake_on_table = true;
	add_child(item);
	item.position = Vector2(0, -38);
	item.get_node("CollisionShape2D").disabled = true;
