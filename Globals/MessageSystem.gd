extends CanvasLayer

signal done

var writing = false;
var waiting = false;

var action_pressed = false;
var char_talking = "player";
var char_text = "";

func _ready():
	hide();
	$Control/Label.percent_visible = 0;
	$Control/Label.hide();
	$Control/Tween.connect("tween_all_completed", self, "message_fully_visible");
	$Control/Timer.connect("timeout", self, "show_message_done");

func show_message(character_name:String, text:String, emotion:String = "happy"):
	if character_name == "player":
		character_name = "bob";
	
	char_talking = character_name;
	$Control/Head.animation = character_name + "-" + emotion;
	
	$Control/Label.percent_visible = 0;
	$Control/Label.text = text;
	
	if character_name == "bob":
		$Control/Head.position.x = 746;
	else:
		$Control/Head.position.x = 784;
	
	print(character_name, ":", text);
	writing = true;
	show();
	$Control/SpeechBubble.frame = 0;
	$Control/SpeechBubble.show();
	$Control/SpeechBubble.play();
	$Control/Head.show();
	$Control/Head.play();
	
	return self

func _on_SpeechBubble_animation_finished():
	$Control/Label.show();
	$Control/Tween.interpolate_property($Control/Label, "percent_visible", 0, 1, $Control/Label.text.length() * 0.02, Tween.TRANS_LINEAR, Tween.EASE_IN, 0);
	$Control/Tween.start();
	

func message_fully_visible():
	$Control/Timer.start(3);
	writing = false;
	waiting = true;
	
func show_message_done():
	$Control/SpeechBubble.hide();
	$Control/Head.hide();
	$Control/Label.hide();
	$Control/Label.percent_visible = 0;
	waiting = false;
	hide();

func _input(_event):
	if (char_talking != "bob") and (char_talking != "player"):
		return;
		
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
			


func _on_MessageSystem_visibility_changed():
	if not visible:
		emit_signal("done");
