extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	var lbl = Label.new()
	lbl.text = "Root"
	add_item(
		lbl, 
		{
			right={type=1, color=Color.white},
		})
	# add_output()