extends Area2D

signal arrived;

export var delay = 0;
export var active = true;

var state = "idle";
var waypoints = [];
var active_waypoint = null;
var handling_area = false;

var looking_dir = Vector2.DOWN;

func _ready():
	if !active:
		hide();
		
	if active:
		activate();

func _process(_delta):
	if delay > 0:
		return;
		
	if !active:
		return;
	
	if is_moving():
		return;
	
	if handling_area:
		return;
	
	if active_waypoint == null and waypoints.size() == 0:
		get_path_through_room();
		if waypoints.size() == 0:
			emit_signal("arrived");
			return;

	var area = get_next_mom_area();
	if area:
		$AnimatedSprite.stop();
		$AnimatedSprite.frame = 0;
		handle_area(area);
		return;
	
	area = get_current_mom_area();
	if area:
		$AnimatedSprite.stop();
		$AnimatedSprite.frame = 0;
		handle_area(area);
		return;
	
	if active_waypoint and (get_distance_to_waypoint(active_waypoint) < 2):
		active_waypoint = null;
	
	if active_waypoint == null:
		active_waypoint = waypoints.pop_front();
	
	if active_waypoint != null:
		var dir = get_waypoint_dir(active_waypoint);
		
		if dir == looking_dir:
			print(active_waypoint, global_position, dir);
			move(dir);
		else:
			looking_dir = dir;


func activate():
	active = true;
	show();
	if delay > 0:
		$DelayTween.interpolate_property(self, "delay", delay, 0, delay, Tween.TRANS_LINEAR);
		$DelayTween.start();


# AREAS

func get_current_mom_area():
	var areas = get_overlapping_areas();
	for area in areas:
		if area.is_in_group("mom-area") and area.enabled:
			return area;

func get_next_mom_area():
	var areas = $FrontArea.get_overlapping_areas();
	for area in areas:
		if area.is_in_group("mom-area") and area.enabled and area.standing_before:
			return area;

func handle_area(area):
	handling_area = true;
	
	if area.text != "":
		yield(MessageSystem.show_message("mom", area.text, area.emotion), "done");
	
	area.action();
	yield(area, "action_done");

	if area.get_node("newPath"):
		get_waypoints_from_path(area.get_node("newPath"));
	
	area.deactivate();
	
	handling_area = false;


# MOVING

func get_distance_to_waypoint(waypoint:Vector2):
	var dist = waypoint - global_position;
	return floor(abs(dist.x) + abs(dist.y));


func get_waypoint_dir(waypoint:Vector2):
	var dir = waypoint - global_position;
	
	if dir == Vector2.ZERO:
		return dir;
	elif (abs(dir.x) >= abs(dir.y)):
		dir.x = sign(dir.x) * 1;
		dir.y = 0;
	elif (abs(dir.y) > abs(dir.x)):
		dir.y = sign(dir.y) * 1;
		dir.x = 0;
	return dir;
	


func get_room() -> Node2D:
	var object = get_parent();
	while not object.is_in_group("room"):
		object = object.get_parent();
	return object;

func get_path_through_room():
	var mom_paths_node = get_room().get_node("MomPaths");
	var paths = mom_paths_node.get_children();
	
	if paths.size() == 0:
		print("no more path");
		return;
	
	var path:Path2D = paths.pop_front();
	get_waypoints_from_path(path);
	mom_paths_node.remove_child(path);
	

func get_waypoints_from_path(path:Path2D):
	active_waypoint = null;
	waypoints = [];
	var parent:Node2D = path.get_parent();
	for point_id in path.curve.get_point_count():
		var point = path.curve.get_point_position(point_id);
		var rounded_point = parent.to_global(point.round());
		waypoints.push_back(rounded_point);
	

func move(dir:Vector2):
	
	if dir == Vector2.ZERO:
		return;
	
	looking_dir = dir;
	
	state = "moving";
	
	var move_target = global_position + dir * Globals.GRID_SIZE;
	$MoveTween.interpolate_property(self, "global_position", global_position, move_target, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	$MoveTween.start();
	
	if !$AnimatedSprite.playing:
		$AnimatedSprite.play();
	
	if dir == Vector2.LEFT:
		$AnimatedSprite.scale.x = -abs($AnimatedSprite.scale.x);
	else:
		$AnimatedSprite.scale.x = abs($AnimatedSprite.scale.x);
	
	# set move animations
	if dir == Vector2.UP:
		if $AnimatedSprite.animation != "walk_up":
			$AnimatedSprite.animation = "walk_up";
	elif dir == Vector2.DOWN:
		if $AnimatedSprite.animation != "walk_down":
			$AnimatedSprite.animation = "walk_down";
	else:
		if $AnimatedSprite.animation != "walk_side":
			$AnimatedSprite.animation = "walk_side";
	
func on_move_done():
	state = "idle";

func _on_MoveTween_tween_all_completed():
	on_move_done();

func is_moving():
	return $MoveTween.is_active();
