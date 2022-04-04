extends MomArea

func action():
	var kitty = get_tree().get_nodes_in_group("kitty")[0];
	
	kitty.global_position = Vector2(528, 464);
	kitty.change_state("idle");
	
	return .action();
