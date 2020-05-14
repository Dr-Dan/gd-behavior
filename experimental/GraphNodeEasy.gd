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

var base_type = ""
var type = ""

# represent args that have been set, possible args are stored in graph
var args_export = {}
var args_type = {}

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
	
func add_input(_type=0):
	var lbl_out = Label.new()
	lbl_out.text = "In"
	# lbl_out.text = str(slot_count())
	lbl_out.align = Label.ALIGN_LEFT
	add_item(
		lbl_out,
		{
			left={type=_type, color=Color.white},
		})

func add_output(_type=1):
	var lbl_out = Label.new()
	lbl_out.text = str(slot_count()-1)
	lbl_out.align = Label.ALIGN_RIGHT
	add_item(
		lbl_out,
		{
			right={type=_type, color=Color.white},
		})

# NOTE: this behaviour only applies to multi-output nodes
# consider lifting this up to GraphNodeBT
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

func to_data():
	return {
		base_type=base_type,
		type=type,
		display_name=title,
		args_export=args_export,
		args_type=args_type,
		offset_x=offset.x,
		offset_y=offset.y,
		}

func from_data(data):
	# set_name(data.node_type)
	title = data.display_name
	type = data.type
#	base_type = data.base_type
	
	if "args_type" in data:
		args_type = data.args_type

	if "args_export" in data:
		args_export = data.args_export
	# else:
	# 	args_export = data.args_type
		
#	offset.x = data.offset_x
#	offset.y = data.offset_y
	return self
