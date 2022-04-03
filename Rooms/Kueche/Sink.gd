extends Activatable

func start_action(player):
	player.state = "in_action";
	
	if $AnimatedSprite.playing:
		$AnimatedSprite.stop();
		$AnimatedSprite.frame = 0;
		$AnimatedSprite.animation = "stopped";
	
	else:
		$AnimatedSprite.animation = "running";
		$AnimatedSprite.play();
	
	# yield(MessageSystem.show_message("player", ""), "done");
	
	player.state = "idle";
