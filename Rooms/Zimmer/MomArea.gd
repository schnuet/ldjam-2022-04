extends MomArea

func action():
	
	yield(MessageSystem.show_message("mom", "Bob... I've got a bone to pick with you.", "mad"), "done");
	
	yield(MessageSystem.show_message("bob", "Thank you for playing!", "happy"), "done");
	
	
	var cl = get_tree().get_nodes_in_group("end-canvas-layer")[0];
	cl.visible = true;
	
	return .action();
