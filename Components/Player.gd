extends Area2D

onready var target:Vector2 = global_position;
var GRID_SIZE = 32;

var state = "idle";
var action_object = null

var action_pressed = false;

signal change_room(room_name, player_position)

func _physics_process(delta):
	if state == "moving_thing":
		return;
	
	if action_pressed and not Input.is_action_pressed("action"):
		action_pressed = false;
		if action_object:
			action_object.end_action(self);
	
	if state != "idle":
		return
		
	if action_object and Input.is_action_pressed("action"):
		action_object.start_action(self);
		action_pressed = true;
			
	else:
		var move_action_is_pressed = (
			Input.is_action_pressed("down") or
			Input.is_action_pressed("up") or
			Input.is_action_pressed("left") or
			Input.is_action_pressed("right")
		)
		
		
		if move_action_is_pressed:
			var move_dir = Vector2.ZERO;
			
			if Input.is_action_pressed("down"):
				move_dir = Vector2.DOWN;
			elif Input.is_action_pressed("up"):
				move_dir = Vector2.UP;
			elif Input.is_action_pressed("left"):
				move_dir = Vector2.LEFT;
			elif Input.is_action_pressed("right"):
				move_dir = Vector2.RIGHT;
			
			if is_dir_free(move_dir):
				move(move_dir)
			
			$ActionArea.position = move_dir * Globals.GRID_SIZE;

func is_dir_free(dir:Vector2):
	if dir == Vector2.LEFT and $MoveColliders/ColliderLeft.get_overlapping_bodies().size() > 0:
		return false;
	if dir == Vector2.RIGHT and $MoveColliders/ColliderRight.get_overlapping_bodies().size() > 0:
		return false;
	if dir == Vector2.DOWN and $MoveColliders/ColliderDown.get_overlapping_bodies().size() > 0:
		return false;
	if dir == Vector2.UP and $MoveColliders/ColliderUp.get_overlapping_bodies().size() > 0:
		return false;
	return true;
			
func move(dir:Vector2):
	target = global_position + dir * GRID_SIZE;
	$MoveTween.interpolate_property(self, "global_position", global_position, target, 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	state = "moving";
	$MoveTween.start();
	
func on_move_done():
	state = "idle";
	var areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("door"):
			emit_signal("change_room", area.room_name, area.player_position);
			global_position = area.player_position;
			
	
func _on_Tween_tween_all_completed():
	on_move_done();


# ACTION AREA

func _on_ActionArea_area_entered(area):
	if area.is_in_group("activatable"):
		action_object = area;

func _on_ActionArea_area_exited(area):
	if area == action_object:
		action_object = null
