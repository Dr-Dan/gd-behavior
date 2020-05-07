extends GraphNode

enum Side{
	Right,
	Left
}

const EMPTY = {
	enabled=false, 
	type=-1, 
	color=Color.white}

# could be better kept externally??
var links = []

func slot_count():
	return get_child_count()

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
		
	links.append(data)
	
func clear_slot(idx):
	.clear_slot(idx)
	links.remove(idx)
