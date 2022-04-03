extends CanvasLayer

signal done

var writing = false;
var waiting = false;

var action_pressed = false;

func _ready():
	$Control/Label.percent_visible = 0;
	$Control/Label.hide();
	$Control/Tween.connect("tween_all_completed", self, "message_fully_visible");
	$Control/Timer.connect("timeout", self, "show_message_done");

func show_message(character_name:String, text:String, emotion:String = ""):
	print(character_name, ":", text);
	writing = true;
	$Control/Label.percent_visible = 0;
	$Control/Label.text = text;
	$Control/Label.show();
	$Control/Tween.interpolate_property($Control/Label, "percent_visible", 0, 1, text.length() * 0.02, Tween.TRANS_LINEAR, Tween.EASE_IN, 0);
	$Control/Tween.start();
	return self

func message_fully_visible():
	$Control/Timer.start(3);
	writing = false;
	waiting = true;
	
func show_message_done():
	$Control/Label.hide();
	$Control/Label.percent_visible = 0;
	waiting = false;
	emit_signal("done");

func _input(_event):
	if not (writing or waiting):
		return
	if Input.is_action_just_pressed("action"):
		action_pressed = true
	if action_pressed and Input.is_action_just_released("action"):
		action_pressed = false;
		if writing:
			$Control/Tween.stop_all();
			$Control/Label.percent_visible = 1;
			message_fully_visible();
		if waiting:
			$Control/Timer.stop();
			show_message_done();
			
