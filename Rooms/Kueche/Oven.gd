extends Activatable

var items_inside = [];

var state = "off";
var cake_done = false;

func drop(item:Node2D, player):
	player.state = "talking";
	
	items_inside.append(item);
	
	$UseSound.play(0.0);
	
	if item.name == "Egg":
		yield(MessageSystem.show_message("player", "I put the egg into the oven."), "done");
	if item.name == "Milk":
		yield(MessageSystem.show_message("player", "I put the milk into the oven."), "done");
	if item.name == "Flour":
		yield(MessageSystem.show_message("player", "I put the flour into the oven."), "done");
	if item.name == "Bowl":
		yield(MessageSystem.show_message("player", "I put the bowl into the oven."), "done");
		yield(MessageSystem.show_message("player", "I sure hope I don't forget to turn it on!"), "done");
	
	player.state = "idle";

func can_drop(item):
	if item.name != "Eggs" and item.name != "Flour" and item.name != "Bowl" and item.name != "Milk":
		return "This doesnt belong in there.";
	if item.name == "Bowl":
		if !item.has_eggs or !item.has_milk or !item.has_flour:
			return "I'm still missing ingredients.";
	return "true";

func start_action(player):
	player.state = "talking";
	
	if state == "baking":
		if not cake_done:
			yield(MessageSystem.show_message("player", "The cake is not done yet.", "neutral"), "done");
		else:
			yield(MessageSystem.show_message("player", "The cake is done!"), "done");
			player.pickup($Cake);
			state = "off";
			$AnimatedSprite.animation = "out";
			yield(MessageSystem.show_message("player", "Let's put it on the table."), "done");
			
			$BurnTimer.stop(); # prevent burning.
			
	elif state == "burned":
		yield(MessageSystem.show_message("player", "Oh no! The cake is burned!", "neutral"), "done");
		
	else:
		if items_inside.size() > 0:
			if items_inside[0].name == "Bowl" and items_inside[0].has_eggs and items_inside[0].has_milk and items_inside[0].has_flour:
				state = "baking";
				$AnimatedSprite.animation = "baking";
				yield(MessageSystem.show_message("player", "I turned on the oven."), "done");
				yield(MessageSystem.show_message("player", "Let's wait for it to be done."), "done");
				items_inside = [];
				$BakeTimer.start(30);
				$BurnTimer.start(70);
			else:
				var item_to_pickup = items_inside.pop_back();
				player.pickup(item_to_pickup);
		
		else:
			yield(MessageSystem.show_message("player", "The oven is empty."), "done");

	player.state = "idle";


func _on_BakeTimer_timeout():
	cake_done = true;


func _on_BurnTimer_timeout():
	if state == "baking":
		Globals.cake_burned = true;
		state = "burned";
		$AnimatedSprite.animation = "smoking";
		
		if is_player_in_kitchen() or is_mom_in_kitchen():
			$BurnSound.play(0.0);


func _on_Kueche_room_entered():
	if Globals.cake_burned:
		$BurnSound.play(0.0);

func _on_Kueche_room_left():
	$BurnSound.stop();


func _on_BurnSound_finished():
	if is_player_in_kitchen() or is_mom_in_kitchen():
		$BurnSound.play(0.0);



func is_player_in_kitchen():
	var players = get_tree().get_nodes_in_group("player");
	
	if players.size() == 0:
		return false;
		
	var player = players[0];
	return player.get_parent().get_parent().name == "Kueche";
	

func is_mom_in_kitchen():
	var moms = get_tree().get_nodes_in_group("mom");
	
	if moms.size() == 0:
		return false;
		
	var mom = moms[0];
	return mom.get_parent().get_parent().name == "Kueche";
