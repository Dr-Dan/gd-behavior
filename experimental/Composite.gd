extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	max_out = INF
	max_in = 1
	base_type="composite"
	
	add_input(1)
	add_output()

func on_output_connected():
	add_output()
	
