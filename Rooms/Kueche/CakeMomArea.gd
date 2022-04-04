extends MomArea

func action():
	var cake = get_tree().get_nodes_in_group("cake")[0];
	
	if cake.get_parent().name == "Table":
		yield(MessageSystem.show_message("mom", "Bob made me a cake!", "happy"), "done");
		yield(MessageSystem.show_message("mom", "What a nice little boy.", "happy"), "done");
		yield(MessageSystem.show_message("mom", "I might eat a bit before I go to his room.", "happy"), "done");
	
	return .action();
