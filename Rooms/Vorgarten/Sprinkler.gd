extends Activatable

var on = false;

func _ready():
	$SprinkledArea/CollisionShape2D2.disabled = true;
	$SprinkledArea.hide();

func start_action(player):
	player.state = "talking";
	
	if not on:
		on = true;
		$SprinkledArea/CollisionShape2D2.disabled = false;
		$AnimatedSprite.animation = "running";
		$SprinkledArea.show();
		$MomArea.activate();
		Globals.sprinkler_top_on = true;
		yield(MessageSystem.show_message("player", "I turned the sprinkler on!"), "done");
	else:
		on = false;
		$SprinkledArea/CollisionShape2D2.disabled = true;
		$AnimatedSprite.animation = "stopped";
		$SprinkledArea.hide();
		$MomArea.deactivate();
		Globals.sprinkler_top_on = false;
		yield(MessageSystem.show_message("player", "I turned the sprinkler off!"), "done");
	
	player.state = "idle";
