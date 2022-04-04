extends Activatable

func start_action(player):
	if has_node("Eggs"):
		player.pickup(get_node("Eggs"));
	if has_node("Flour"):
		player.pickup(get_node("Flour"));
	if has_node("Milk"):
		player.pickup(get_node("Milk"));
	if has_node("Bowl"):
		player.pickup(get_node("Bowl"));

func drop(item, player):
	if has_node("Bowl"):
		var bowl = get_node("Bowl");
		bowl.drop(item);
		yield(MessageSystem.show_message("player", "I added the " + item.name + " to the bowl."), "done");
		return;
	if item.name == "Eggs" or item.name == "Flour" or item.name == "Bowl" or item.name == "Milk":
		add_child(item);
		item.position = Vector2(0, -16);

func can_drop(item):
	if item.name != "Eggs" and item.name != "Flour" and item.name != "Bowl" and item.name != "Milk":
		return "This doesn't belong on the counter.";
	if has_node("Eggs") or has_node("Flour") or has_node("Milk"):
		return "There's no more space.";
	return "true";
