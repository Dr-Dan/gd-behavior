extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	max_in = 1
	base_type="leaf"
	add_input()
	# var lbl = Label.new()
	# lbl.text = "In"
	# add_item(
	# 	lbl, 
	# 	{
	# 		left={type=0, color=Color.white},
	# 	})
