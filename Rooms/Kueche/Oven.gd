extends Activatable

var items_inside = [];

var state = "off";
var cake_done = false;
var cake_burned = false;

func drop(item:Node2D, player):
	player.state = "talking";
	
	items_inside.append(item);
	
	if item.name == "Egg":
		yield(MessageSystem.show_message("player", "I put the egg into the oven."), "done");
	
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
			
	elif state == "burned":
		yield(MessageSystem.show_message("player", "Oh no! The cake is burned!", "neutral"), "done");
		
	else:
		if items_inside.size() > 0:
			if items_inside[0].name == "Bowl" and items_inside[0].has_eggs and items_inside[0].has_milk and items_inside[0].has_flour:
				state = "baking";
				$AnimatedSprite.animation = "baking";
				yield(MessageSystem.show_message("player", "I turned on the oven."), "done");
				items_inside = [];
				$BakeTimer.start(30);
				$BurnTimer.start(70);
			else:
				player.pickup(items_inside.pop_back());
		
		else:
			yield(MessageSystem.show_message("player", "The oven is empty."), "done");

	player.state = "idle";


func _on_BakeTimer_timeout():
	cake_done = true;


func _on_BurnTimer_timeout():
	cake_burned = true;
	$AnimatedSprite.animation = "smoking";
