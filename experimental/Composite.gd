extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	max_out = INF
	max_in = 1
	
	var lbl = Label.new()
	lbl.text = "In"
	add_item(
		lbl, 
		{
			left={type=0, color=Color.white},
		})
#	add_input()
	add_output()

func on_output_connected():
	add_output()
	
