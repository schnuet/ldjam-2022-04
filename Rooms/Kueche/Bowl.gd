extends Pickable

var has_milk = false;
var has_eggs = false;
var has_flour = false;

func drop(item):
	add_child(item);
	item.deactivate();
	item.visible = false;
	
	if item.name == "Milk":
		has_milk = true;
	if item.name == "Eggs":
		has_eggs = true;
	if item.name == "Flour":
		has_flour = true;
	
	item.get_node("Sound").play();
