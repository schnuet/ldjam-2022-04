extends Node2D


func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/02 - First/First.tscn");


func _on_Credits_pressed():
	get_tree().change_scene("res://Scenes/99 - Credits/Credits.tscn");
