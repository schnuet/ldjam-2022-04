extends Activatable

var phoned = false;

func start_action(player):
	player.state = "in_action";
	
	if phoned:
		player.state = "talking";
		yield(MessageSystem.show_message("player", "I already called someone."), "done");
		
	else:
	
		var person_to_phone = yield(OptionsScreen.show_options([
			{
				"text": "Call the Police",
				"id": "police",
				"name": "the police"
			},
			{
				"text": "Call your moms best friend",
				"id": "friend",
				"name": "Karen"
			},
			{
				"text": "Call the football salesman",
				"id": "football",
				"name": "Mr. Beast, the football salesman"
			}
		]), "done");
		
		Globals.phoned_person = person_to_phone.id;
		$TelephoneMomArea.activate();
		
		player.state = "talking";
		yield(MessageSystem.show_message("player", "I called " + person_to_phone.name + "."), "done");
		
		phoned = true;
		
	player.state = "idle";
