extends Pickable

func on_pickup():
	$MomArea.deactivate();

func on_drop():
	$MomArea.activate();
