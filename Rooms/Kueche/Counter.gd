extends Activatable



func start_action(player):
	if has_node("Eggs"):
		player.pickup(get_node("Eggs"));
		Globals.ingredients_on_counter["Eggs"] = false;
	if has_node("Flour"):
		player.pickup(get_node("Flour"));
		Globals.ingredients_on_counter["Flour"] = false;
	if has_node("Milk"):
		player.pickup(get_node("Milk"));
		Globals.ingredients_on_counter["Milk"] = false;
	if has_node("Bowl"):
		player.pickup(get_node("Bowl"));
		Globals.ingredients_on_counter["Bowl"] = false;

func drop(item, player):
	if has_node("Bowl"):
		player.state = "talking";
		var bowl = get_node("Bowl");
		bowl.drop(item);
		yield(MessageSystem.show_message("player", "I added the " + item.name + " to the bowl."), "done");
		player.state = "idle";
		return;
	if item.name == "Eggs" or item.name == "Flour" or item.name == "Bowl" or item.name == "Milk":
		add_child(item);
		item.position = Vector2(0, -16);
		Globals.ingredients_on_counter[item.name] = true;

func can_drop(item):
	if item.name != "Eggs" and item.name != "Flour" and item.name != "Bowl" and item.name != "Milk":
		return "This doesn't belong on the counter.";
	if has_node("Eggs") or has_node("Flour") or has_node("Milk"):
		return "There's no more space.";
	return "true";
