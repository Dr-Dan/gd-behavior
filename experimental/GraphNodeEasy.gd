extends GraphNode

#enum ConnectType{
#	None,
#	One_to_One,
#	Many_to_One
#}

const EMPTY = {
	enabled=false,
	type=-1,
	color=Color.white}

#var type = ""
var max_out = 0
var max_in = 0
#var conn_type = ConnectType.None

export var start_out = 0
export var start_in = 0

func setup():
	start_in = clamp(start_in, 0, max_in)
	start_out = clamp(start_out, 0, max_out)
	for n in start_in:
		add_input()
	for n in start_out:
		add_output()
				
func on_output_connected():
	pass
	
func add_input():
	var lbl_out = Label.new()
	lbl_out.text = str(slot_count())
	lbl_out.align = Label.ALIGN_LEFT
	add_item(
		lbl_out,
		{
			left={type=0, color=Color.white},
		})

func add_output():
	var lbl_out = Label.new()
	lbl_out.text = str(slot_count()-1)
	lbl_out.align = Label.ALIGN_RIGHT
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

# TODO: should clear all or take min_idx
func clear_outputs():
	for i in range(slot_count()-1, 1, -1):
		var ch = get_child(i)
		remove_child(ch)
		ch.queue_free()

func add_outputs(n:int):
	for i in n:
		add_output()
		
func add_item(control, data={}, idx=-1):
	if idx == -1:
		idx = slot_count()
	add_child(control)
	_set_slot_data(idx, data)
	
func _set_slot_data(idx, data={}):
	var l = {}
	var r = {}
	
	if "left" in data:
		l = data.left
		l.enabled=true
	else:
		l = EMPTY
	
	if "right" in data:
		r = data.right
		r.enabled=true
	else:
		r = EMPTY
		
	set_slot(
		idx,
		l.enabled, l.type, l.color,
		r.enabled, r.type, r.color)

func slot_count():
	return get_child_count()
