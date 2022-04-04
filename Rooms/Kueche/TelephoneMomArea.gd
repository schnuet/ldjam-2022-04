extends MomArea

func action():
	
	var telephone = get_tree().get_nodes_in_group("telephone")[0];
	var mom = get_tree().get_nodes_in_group("mom")[0];
	
	telephone.get_node("AnimatedSprite").animation = "ringing";
	
	yield(MessageSystem.show_message("mom", "Oh, the telephone is ringing?", "happy"), "done");
	
	yield(mom.move(Vector2.LEFT), "move_done");
	yield(mom.move(Vector2.LEFT), "move_done");
	yield(mom.move(Vector2.UP), "move_done");
	
	if Globals.phoned_person == "police":
		yield(MessageSystem.show_message("mom", "Hello? Who is on the-?", "happy"), "done");
		yield(MessageSystem.show_message("mom", "OH, the police?!? Sorry, must be a misconception. *click*", "neutral"), "done");
		yield(MessageSystem.show_message("mom", "Why did he call the police? I better hurry to his room!", "neutral"), "done");
		 
	if Globals.phoned_person == "friend":
		yield(MessageSystem.show_message("mom", "Hello? Who is on the-?", "happy"), "done");
		yield(MessageSystem.show_message("mom", "HEY! How are you gurl? Sure we can meet soon bla bla bla...", "happy"), "done");
		yield(MessageSystem.show_message("mom", "I also saw this soap bla bla bla...", "happy"), "done");
		yield(MessageSystem.show_message("mom", "Yeah, you too!", "happy"), "done");
		yield(MessageSystem.show_message("mom", "Bye!", "happy"), "done");
		 
	if Globals.phoned_person == "football":
		yield(MessageSystem.show_message("mom", "Hello? Who is on the- ", "happy"), "done");
		yield(MessageSystem.show_message("mom", "oh... yeah... no, I am not interested in football. Bye.", "mad"), "done");
		 

	
	
	return .action();
