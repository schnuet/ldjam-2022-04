extends Activatable

var phoned = false;
var person_to_phone = null;
var player = null;

func start_action(p):
	player = p;
	player.state = "in_action";
	
	if phoned:
		player.state = "talking";
		yield(MessageSystem.show_message("player", "I already called someone."), "done");
		player.state = "idle";
		return
		
	else:
		person_to_phone = yield(OptionsScreen.show_options([
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
		
		$PhoneTimer.start(4);
		$Sound.play(0.0);

func _on_PhoneTimer_timeout():
	player.state = "talking";
	yield(MessageSystem.show_message("player", "I called " + person_to_phone.name + "."), "done");
	phoned = true;
	player.state = "idle";
