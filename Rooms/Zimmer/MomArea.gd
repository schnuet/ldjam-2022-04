extends MomArea

func action():
	
	yield(MessageSystem.show_message("mom", "Bob... I've got a bone to pick with you.", "mad"), "done");
	
	yield(MessageSystem.show_message("player", "Thank you for playing!", "mad"), "done");
	
	return .action();