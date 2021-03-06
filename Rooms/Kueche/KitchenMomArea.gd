extends MomArea


func action():
	var mom = get_tree().get_nodes_in_group("mom")[0];
	
	mom.looking_dir = Vector2.LEFT;
	mom.get_node("AnimatedSprite").animation = "walk_side";
	mom.get_node("AnimatedSprite").scale.x = -abs(mom.get_node("AnimatedSprite").scale.x);
	
	if (
		Globals.ingredients_on_counter["Milk"] or 
		Globals.ingredients_on_counter["Eggs"] or 
		Globals.ingredients_on_counter["Flour"] or 
		Globals.ingredients_on_counter["Bowl"]
	):
		yield(MessageSystem.show_message("mom", "Why did my son leave groceries on the counter?", "neutral"), "done");
		Globals.aggro_d = 1;
	
	if Globals.cake_burned:
		yield(MessageSystem.show_message("mom", "What's that horrible smell?", "mad"), "done");
		yield(MessageSystem.show_message("mom", "THIS LITTLE BRAT! Oh, I can´t wait to get to his room!", "mad"), "done");
		Globals.aggro_d = 3;

	return .action();
