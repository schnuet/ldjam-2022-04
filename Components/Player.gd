extends Area2D

onready var target:Vector2 = global_position;

var state = "idle";
var look_direction = Vector2.DOWN;
var action_object = null

var action_pressed = false;

var carried_pickup = null;

signal change_room(room_name, player_position);

func _physics_process(delta):
	if state == "moving_thing":
		return;
	
	if state == "talking":
		return
	
	# released action
	if action_pressed and not Input.is_action_pressed("action"):
		action_pressed = false;
		if action_object:
			action_object.end_action(self);
	
	if state != "idle":
		return
	
	# Look direction update
	if Input.is_action_pressed("down"):
		look_direction = Vector2.DOWN;
	elif Input.is_action_pressed("up"):
		look_direction = Vector2.UP;
	elif Input.is_action_pressed("left"):
		look_direction = Vector2.LEFT;
	elif Input.is_action_pressed("right"):
		look_direction = Vector2.RIGHT;
	
	if Input.is_action_pressed("action") and not action_pressed:
		if carried_pickup:
			if can_drop(look_direction):
				drop();
				action_pressed = true;
			return;
			
		if action_object:
			action_object.start_action(self);
			action_pressed = true;
			return;
	
	# Moving
	var move_action_is_pressed = (
		Input.is_action_pressed("down") or
		Input.is_action_pressed("up") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")
	);
	if move_action_is_pressed:
		if is_dir_free(look_direction):
			move(look_direction)
		
		$ActionArea.position = look_direction * Globals.GRID_SIZE;


# MOVING

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
	target = global_position + dir * Globals.GRID_SIZE;
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


# PICKUP

func pickup(item:Node2D):
	$PickupPosition.add_child(item);
	carried_pickup = item;
	carried_pickup.position = Vector2.ZERO;

func drop():
	if not carried_pickup:
		return
	$PickupPosition.remove_child(carried_pickup);
	get_parent().add_child(carried_pickup);
	carried_pickup.global_position = global_position + look_direction * Globals.GRID_SIZE;
	carried_pickup = null;
	

func can_drop(dir:Vector2):
	var bodies = [];
	var areas = [];
	if dir == Vector2.LEFT:
		bodies = $MoveColliders/ColliderLeft.get_overlapping_bodies();
		areas = $MoveColliders/ColliderLeft.get_overlapping_areas();
	if dir == Vector2.RIGHT:
		bodies = $MoveColliders/ColliderRight.get_overlapping_bodies();
		areas = $MoveColliders/ColliderRight.get_overlapping_areas();
	if dir == Vector2.DOWN:
		bodies = $MoveColliders/ColliderDown.get_overlapping_bodies();
		areas = $MoveColliders/ColliderDown.get_overlapping_areas();
	if dir == Vector2.UP:
		bodies = $MoveColliders/ColliderUp.get_overlapping_bodies();
		areas = $MoveColliders/ColliderUp.get_overlapping_areas();
	
	for area in areas:
		if area.is_in_group("movable"):
			return false;
		if area.is_in_group("undroppable"):
			return false;
	return true;


# ACTION AREA

func _on_ActionArea_area_entered(area):
	if area.is_in_group("activatable"):
		action_object = area;

func _on_ActionArea_area_exited(area):
	if area == action_object:
		action_object = null
