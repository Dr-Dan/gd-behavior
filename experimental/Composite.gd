extends "res://experimental/GraphNodeEasy.gd"

func _enter_tree():
	var lbl = Label.new()
	lbl.text = "In"
	add_item(
		lbl, 
		{
			left={type=0, color=Color.white},
		})
	add_output()

func add_output():
	var lbl_out = Label.new()
	lbl_out.text = "Out " + str(slot_count()-1)
	add_item(
		lbl_out, 
		{
			right={type=0, color=Color.white},
		})

func remove_output(idx):
	var n0 = get_child(idx+1)
	var n1 = get_child(idx+2)
	n1.text = n0.text
	
	remove_child(n1)
	clear_slot(idx+2)
