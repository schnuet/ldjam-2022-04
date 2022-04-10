class_name Activatable

extends Area2D

var arrow_spriteframes = preload("res://UI/Arrow/ArrowSpriteFrames.tres");
onready var arrow_sprite = AnimatedSprite.new();

func _init():
	add_to_group("activatable");

func _ready():
	arrow_sprite.name = "Arrow";
	arrow_sprite.frames = arrow_spriteframes;
	arrow_sprite.frame = 0;
	arrow_sprite.scale = Vector2(0.3, 0.3);
	arrow_sprite.position = Vector2(0, -20);
	arrow_sprite.animation = "animated";
	arrow_sprite.self_modulate = Color(1, 1, 1, 0.2);
	add_child(arrow_sprite);

func highlight_arrow():
	arrow_sprite.self_modulate = Color(1, 1, 1, 1);
	arrow_sprite.play();
	
func dehighlight_arrow():
	arrow_sprite.self_modulate = Color(1, 1, 1, 0.2);
	arrow_sprite.frame = 0;
	arrow_sprite.stop();

func start_action(_player):
	pass

func end_action(_player):
	dehighlight_arrow();

func deactivate():
	get_node("CollisionShape2D").disabled = true;
