extends Activatable

var on = false;
var in_room = false;

func _ready():
	$SprinkledArea/CollisionShape2D2.disabled = true;
	$SprinkledArea.hide();

func start_action(player:Area2D):
	player.state = "talking";
	
	if not on:
		on = true;
		$Sound.play(0.0);
		$SprinkledArea/CollisionShape2D2.disabled = false;
		$AnimatedSprite.animation = "running";
		$SprinkledArea.show();
		$MomArea.activate();
		Globals.sprinkler_top_on = true;
		yield(MessageSystem.show_message("player", "I turned the sprinkler on!"), "done");
	else:
		on = false;
		$Sound.stop();
		$SprinkledArea/CollisionShape2D2.disabled = true;
		$AnimatedSprite.animation = "stopped";
		$SprinkledArea.hide();
		$MomArea.deactivate();
		Globals.sprinkler_top_on = false;
		yield(MessageSystem.show_message("player", "I turned the sprinkler off!"), "done");
	
	player.state = "idle";

func _on_Sound_finished():
	if in_room and on:
		$Sound.play(0.0);


func _on_Vorgarten_room_entered():
	in_room = true;
	if on:
		$Sound.play(0.0);

func _on_Vorgarten_room_left():
	in_room = false;
	$Sound.stop();
