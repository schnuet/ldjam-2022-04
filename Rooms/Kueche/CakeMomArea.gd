extends MomArea

func action():
	if Globals.cake_on_table == true:
		yield(MessageSystem.show_message("mom", "Bob made me a cake!", "happy"), "done");
		yield(MessageSystem.show_message("mom", "What a nice little boy.", "happy"), "done");
		yield(MessageSystem.show_message("mom", "I might eat a bit before I go to his room.", "happy"), "done");
		Globals.aggro_d = 2;
	
	return .action();
