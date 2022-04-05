extends Activatable

signal yeet_done;

var player = null;
var action_down = false;

var is_moving = false;
var is_yeeting = false;
var colliders = {};

var player_side = Vector2.ZERO;

var yeet_dir = Vector2.ZERO;

func _ready():
	add_collision_areas();
	add_move_tween();
	add_yeet_tween();
	add_collision_object();
	
func start_action(p):
	if not Globals.said_holding_on_message:
		Globals.said_holding_on_message = true;
		p.state = "talking";
		yield(MessageSystem.show_message("player", "To move the furniture, I'll have to keep holding it.", "neutral"), "done");
		p.state = "idle";
	
	if not action_down:
		action_down = true
		player = p
		if player.global_position.x < global_position.x - $CollisionShape2D.shape.extents.x:
			player_side = Vector2.RIGHT
		if player.global_position.x > global_position.x + $CollisionShape2D.shape.extents.x:
			player_side = Vector2.LEFT
		if player.global_position.y < global_position.y - $CollisionShape2D.shape.extents.y:
			player_side = Vector2.DOWN
		if player.global_position.y > global_position.y + $CollisionShape2D.shape.extents.y:
			player_side = Vector2.UP

func end_action(_p):
	action_down = false
	if not is_moving:
		player.state = "idle"

func _physics_process(_delta):
	if is_yeeting:
		return false;
	
	if action_down and not Input.is_action_pressed("action"):
		action_down = false;
		if not is_moving:
			player.state = "idle";
	
	if not is_moving and player and action_down:
		if Input.is_action_pressed("right"):
			move(Vector2.RIGHT);
		if Input.is_action_pressed("left"):
			move(Vector2.LEFT);
		if Input.is_action_pressed("down"):
			move(Vector2.DOWN);
		if Input.is_action_pressed("up"):
			move(Vector2.UP);

func move(dir:Vector2):
	if !is_dir_free(dir):
		return
	
	if dir != player_side:
		if not player.is_dir_free(dir):
			return
	
	player.state = "moving_thing";
	player.move(dir);
	do_move_self(dir);

func do_move_self(dir:Vector2):
	var target = global_position + dir * Globals.GRID_SIZE;
	get_node("MoveTween").interpolate_property(self, "global_position", global_position, target, 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	is_moving = true;
	$MoveTween.start();

func add_move_tween():
	var move_tween = Tween.new()
	move_tween.name = "MoveTween";
	move_tween.connect("tween_all_completed", self, "on_move_done");
	add_child(move_tween)
	
func on_move_done():
	is_moving = false;
	if player and !player.deactivated:
		if action_down:
			player.state = "in_action";
		else:
			player.state = "idle";




func force_push(dir:Vector2, do_move = true):
	var connected_pieces = [];
	
	# get all the furniture thats over the piece
	var bodies = colliders[dir].get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("furniture"):
			connected_pieces.push_back(body.get_parent());
		else:
			return false;
	
	for piece in connected_pieces:
		if not piece.force_push(dir, false):
			return false;
	
	if do_move:
		yeet_dir = dir;
		for piece in connected_pieces:
			piece.force_push(dir, true);
		
		yeet(dir);
	
	return self;


func yeet(dir:Vector2):
	print("yeet ", name);
	var target = global_position + dir * Globals.GRID_SIZE;
	get_node("YeetTween").interpolate_property(self, "global_position", global_position, target, 0.08, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0);
	is_yeeting = true;
	$YeetTween.start();

func add_yeet_tween():
	var yeet_tween = Tween.new()
	yeet_tween.name = "YeetTween";
	yeet_tween.connect("tween_all_completed", self, "on_yeet_done");
	add_child(yeet_tween);
	
func on_yeet_done():
	if not force_push(yeet_dir, false):
		is_yeeting = false;
		emit_signal("yeet_done");
	
	else:
		force_push(yeet_dir, true);



func add_collision_object():
	var collision_object = KinematicBody2D.new()
	collision_object.name = "CollisionObject"
	collision_object.add_to_group("furniture");
	var collision_object_shape = CollisionShape2D.new()
	collision_object_shape.self_modulate = Color.chartreuse;
	collision_object_shape.shape = RectangleShape2D.new()
	collision_object_shape.shape.extents.x = $CollisionShape2D.shape.extents.x - 2;
	collision_object_shape.shape.extents.y = $CollisionShape2D.shape.extents.y - 2;
	collision_object.add_child(collision_object_shape);
	add_child(collision_object)
	

func add_collision_areas():
	add_col_area(Vector2.DOWN);
	add_col_area(Vector2.LEFT);
	add_col_area(Vector2.UP);
	add_col_area(Vector2.RIGHT);

func add_col_area(dir:Vector2):
	var col_area = Area2D.new()
	# col_area.visible = false
	colliders[dir] = col_area;
	add_child(col_area)
	var colshape = CollisionShape2D.new()
	col_area.add_child(colshape)
	colshape.shape = RectangleShape2D.new()
	
	var width = $CollisionShape2D.shape.extents.x;
	var height = $CollisionShape2D.shape.extents.y;
	
	if dir.y != 0:
		colshape.shape.extents.x = width - 2;
		colshape.shape.extents.y = Globals.GRID_SIZE / 2 - 2;
		col_area.position += dir * height;
		col_area.position += dir * Globals.GRID_SIZE / 2;
	
	elif dir.x != 0:
		colshape.shape.extents.x = Globals.GRID_SIZE / 2 - 2;
		colshape.shape.extents.y = height - 2;
		col_area.position += dir * width;
		col_area.position += dir * Globals.GRID_SIZE / 2;

func is_dir_free(dir:Vector2):
	if colliders[dir].get_overlapping_bodies().size() > 0:
		return false;
	return true;
