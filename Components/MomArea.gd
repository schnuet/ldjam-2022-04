class_name MomArea

extends Area2D

signal action_done;

export var areaname = "";
export var text = "";
export var emotion = "neutral";

export var enabled = false;
export var standing_before = false;

var action_timer = Timer.new();

func _ready():
	action_timer.one_shot = true;
	action_timer.connect("timeout", self, "emit_signal", ["action_done"]);
	add_child(action_timer);

	if not is_in_group("mom-area"):
		add_to_group("mom-area");
	
	if enabled:
		activate();
	else:
		deactivate();

func action():
	action_timer.start(0.1);
	return self;

func activate():
	enabled = true;
	show();
	get_node("CollisionShape2D").disabled = false;

func deactivate():
	enabled = false;
	hide();
	get_node("CollisionShape2D").disabled = true;
