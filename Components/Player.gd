extends Area2D

var state = "idle";
var look_direction = Vector2.DOWN;

var action_object = null; # possible to do action with (in range)
var current_action_object = null; # in direct interaction

var action_pressed = false;
var carried_pickup = null;
var deactivated = false;

signal change_room(room_name, player_position);


func deactivate():
	hide();
	deactivated = true;

func _physics_process(_delta):
	if deactivated:
		return;
		
	if is_moving():
		return;
	
	if state == "moving_thing":
		return;
	
	if state == "talking":
		return
	
	# released action
	if action_pressed and not Input.is_action_pressed("action"):
		action_pressed = false;
		if current_action_object:
			current_action_object.end_action(self);
			current_action_object = null;
		return
	
	if state == "in_action":
		$AnimatedSprite.animation = "idle";
		return;
	
	if state == "idle" or state == "moving":
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
			
			var available_action = action_in_range();
			if available_action:
				current_action_object = available_action;
				available_action.start_action(self);
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
				state = "moving";
				move(look_direction)
			
			$ActionArea.position = look_direction * Globals.GRID_SIZE;
			return;
	
	state = "idle";
	$AnimatedSprite.animation = "idle";


# MOVING

func get_areas_in_dir(dir:Vector2):
	var areas = [];
	if dir == Vector2.LEFT:
		areas = $MoveColliders/ColliderLeft.get_overlapping_areas()
	if dir == Vector2.RIGHT:
		areas = $MoveColliders/ColliderRight.get_overlapping_areas()
	if dir == Vector2.DOWN:
		areas = $MoveColliders/ColliderDown.get_overlapping_areas()
	if dir == Vector2.UP:
		areas = $MoveColliders/ColliderUp.get_overlapping_areas()
	return areas;

func get_bodies_in_dir(dir:Vector2):
	var bodies = [];
	if dir == Vector2.LEFT:
		bodies = $MoveColliders/ColliderLeft.get_overlapping_bodies()
	if dir == Vector2.RIGHT:
		bodies = $MoveColliders/ColliderRight.get_overlapping_bodies()
	if dir == Vector2.DOWN:
		bodies = $MoveColliders/ColliderDown.get_overlapping_bodies()
	if dir == Vector2.UP:
		bodies = $MoveColliders/ColliderUp.get_overlapping_bodies()
	
	return bodies;

func is_dir_free(dir:Vector2):
	var bodies = get_bodies_in_dir(dir);
	var areas = get_areas_in_dir(dir);
	
	if bodies.size() > 0:
		return false;
		
	for area in areas:
		if area.is_in_group("pickable") and carried_pickup != area:
			return false;
		
	return true;

func move(dir:Vector2):
	var move_target = global_position + dir * Globals.GRID_SIZE;
	$MoveTween.interpolate_property(self, "global_position", global_position, move_target, 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	$MoveTween.start();
	
	if dir == Vector2.LEFT:
		$AnimatedSprite.scale.x = -abs($AnimatedSprite.scale.x);
	elif dir == Vector2.RIGHT:
		$AnimatedSprite.scale.x = abs($AnimatedSprite.scale.x);
	
	if dir == Vector2.UP:
		if $AnimatedSprite.animation != "walk_back":
			$AnimatedSprite.animation = "walk_back";
	else:
		if $AnimatedSprite.animation != "walk_side":
			$AnimatedSprite.animation = "walk_side";

func _on_Tween_tween_all_completed():
	if state == "moving":
		on_move_done();
	
func on_move_done():
	# activate END areas
	var areas = get_overlapping_areas()
	for area in areas:
		if area.is_in_group("door"):
			print("player change room", area)
			emit_signal("change_room", area.room_name, area.player_position);
			global_position = area.player_position;


func is_moving():
	return $MoveTween.is_active();


# PICKUP

func pickup(item:Node2D):
	if item.get_parent():
		item.get_parent().remove_child(item);
	$PickupPosition.add_child(item);
	carried_pickup = item;
	carried_pickup.position = Vector2.ZERO;
	carried_pickup.on_pickup();

func drop():
	if not carried_pickup:
		return
	
	var dropped_on_area = false;
	
	var areas_on_drop = get_areas_in_dir(look_direction);
	for area in areas_on_drop:
		if area.is_in_group("dropzone"):
			var no_drop_message = area.can_drop(carried_pickup);
			if no_drop_message == "true":
				$PickupPosition.remove_child(carried_pickup);
				dropped_on_area = area;
				area.drop(carried_pickup, self);
				carried_pickup = null;
			else:
				state = "talking";
				yield(MessageSystem.show_message("player", no_drop_message, "neutral"), "done");
				state = "idle";
				return false;
	
	# drop on floor:
	if not dropped_on_area:
		$PickupPosition.remove_child(carried_pickup);
		get_parent().add_child(carried_pickup);
		carried_pickup.global_position = global_position + look_direction * Globals.GRID_SIZE;
		carried_pickup.on_drop();
		carried_pickup = null;
	
	


func can_drop(dir:Vector2):
	var areas = [];
	if dir == Vector2.LEFT:
		areas = $MoveColliders/ColliderLeft.get_overlapping_areas();
	if dir == Vector2.RIGHT:
		areas = $MoveColliders/ColliderRight.get_overlapping_areas();
	if dir == Vector2.DOWN:
		areas = $MoveColliders/ColliderDown.get_overlapping_areas();
	if dir == Vector2.UP:
		areas = $MoveColliders/ColliderUp.get_overlapping_areas();
	
	for area in areas:
		if area == carried_pickup:
			continue;
		# ALWAYS drop on dropzones
		if area.is_in_group("dropzone"):
			return true;
		if area.is_in_group("pickable"):
			return false;
		if area.is_in_group("movable"):
			return false;
		if area.is_in_group("undroppable"):
			return false;
	return true;


# ACTION AREA

func action_in_range():
	if action_object:
		return action_object;

	var areas = [];
	areas.append_array($MoveColliders/ColliderLeft.get_overlapping_areas());
	areas.append_array($MoveColliders/ColliderRight.get_overlapping_areas());
	areas.append_array($MoveColliders/ColliderDown.get_overlapping_areas());
	areas.append_array($MoveColliders/ColliderUp.get_overlapping_areas());
	for area in areas:
		if area.is_in_group("activatable"):
			return area;

func _on_ActionArea_area_entered(area):
	if area.is_in_group("activatable"):
		action_object = area;
		action_object.highlight_arrow();

func _on_ActionArea_area_exited(area):
	if area == action_object:
		action_object.dehighlight_arrow();
		action_object = null
