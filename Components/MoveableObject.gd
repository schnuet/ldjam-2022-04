extends Area2D

var player = null
var action_down = false

var is_moving = false;
var colliders = {};

var player_side = Vector2.ZERO

func _ready():
	add_collision_areas();
	add_move_tween();
	add_collision_object();
	
func start_action(p):
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
	

func _physics_process(_delta):
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
	is_moving = false
	player.state = "idle"

func add_collision_object():
	var collision_object = StaticBody2D.new()
	collision_object.name = "CollisionObject"
	var collision_object_shape = CollisionShape2D.new()
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
	col_area.visible = false
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
