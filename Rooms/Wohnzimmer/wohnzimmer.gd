extends "../Room.gd"

func _on_DoorVorgarten_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("change_room", "Vorgarten", Vector2(112, 496));


func _on_DoorKueche_area_entered(area):
	if area.is_in_group("player"):
		emit_signal("change_room", "Kueche", Vector2(688, 80));
