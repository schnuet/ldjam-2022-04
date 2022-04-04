extends MomArea

func action():
	if Globals.sprinkler_top_on:
		yield(MessageSystem.show_message("mom", "The second one is also turned on...", "mad"), "done");
	else:
		yield(MessageSystem.show_message("mom", "Who turned the sprinkler on? I have to go around to not get wet...", "mad"), "done");
		
	return .action();
