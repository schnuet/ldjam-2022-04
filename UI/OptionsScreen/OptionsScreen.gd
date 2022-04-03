extends CanvasLayer

signal done();

var button_theme = preload("res://UI/OptionsScreen/ButtonTheme.tres");

func _ready():
	clear();

func show_options(options:Array):
	for option in options:
		create_option(option);
	
	$VBoxContainer.set_anchors_and_margins_preset(Control.PRESET_CENTER,Control.PRESET_MODE_MINSIZE);
	show();
	
	var first_button:Button = $VBoxContainer.get_children()[0];
	first_button.grab_focus();
	
	return self;

func create_option(option:Dictionary):
	var button = Button.new();
	button.text = option.text;
	button.theme = button_theme;
	button.connect("pressed", self, "on_option_choose", [option]);
	$VBoxContainer.add_child(button);

func on_option_choose(option):
	clear();
	emit_signal("done", option);

func clear():
	var buttons = $VBoxContainer.get_children();
	for button in buttons:
		$VBoxContainer.remove_child(button);
	hide();
