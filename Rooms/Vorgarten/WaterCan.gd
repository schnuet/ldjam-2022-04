extends Pickable

func on_drop():
	$MomArea.activate();

func on_pickup():
	$MomArea.deactivate();
