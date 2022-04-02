extends "../Room.gd"


func _on_DoorWohnzimmer_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("change_room", "Wohnzimmer", Vector2(112, 80));
