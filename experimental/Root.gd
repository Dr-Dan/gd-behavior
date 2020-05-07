extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	var lbl = Label.new()
	lbl.text = "Root"
	add_item(
		lbl, 
		{
			right={type=0, color=Color.white},
		})
