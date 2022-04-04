extends MomArea


func action():
	var mom = get_tree().get_nodes_in_group("mom")[0];
	var oven = get_tree().get_nodes_in_group("oven")[0];
	
	if (
		Globals.ingredients_on_counter["Milk"] or 
		Globals.ingredients_on_counter["Eggs"] or 
		Globals.ingredients_on_counter["Flour"] or 
		Globals.ingredients_on_counter["Bowl"]
	):
		yield(MessageSystem.show_message("mom", "Why did my son leave groceries on the table?", "neutral"), "done");
	
	if oven.cake_burned:
		yield(MessageSystem.show_message("mom", "THIS LITTLE BRAT! Oh, I can´t wait to get to his room!", "mad"), "done");

	return .action();
