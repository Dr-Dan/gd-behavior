extends "res://experimental/GraphNodeEasy.gd"

func _ready():
	_set_slot_data(0, {
		right={type=0, color=Color.blue}})
		
	var lbl = Label.new()
	lbl.text = "Hello"
	add_item(
		lbl, 
		{
			right={type=0, color=Color.lightblue},
			left={type=0, color=Color.lightgreen},
		})
