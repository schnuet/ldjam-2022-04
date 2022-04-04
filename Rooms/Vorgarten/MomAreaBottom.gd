extends MomArea

func action():
	get_parent().get_node("MomAreaTop").deactivate();
	return .action();
