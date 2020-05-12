extends PanelContainer

const Slot = preload("res://experimental/InfoPanelEditSlot.tscn")

onready var heading_label = $VBoxContainer/Heading/Label
onready var slots = $VBoxContainer/Slots

var current_node = null

var edit_slots = []

# func _ready():
#	 pass

func show_info(node):
	heading_label.text = node.title
	for c in slots.get_children():
		c.free()

	for a in node.args_export:
		var s = Slot.instance()
		s.key = a
		s.value = str(node.args_export[a])
		slots.add_child(s)
		s.connect("on_value_changed", self, "_set_value", [a, node])
		
func _set_value(value, key, node):
	node.args_export[key] = convert_input(value, node.args_type[key])
	# if node.set_export_arg(key, value):

func convert_input(input:String, type):
	match type:
		TYPE_STRING:
			return input
		TYPE_INT:
			return int(input)
		TYPE_BOOL:
			if input in ["true", "True", "T"]:
				return true
			elif input in ["false", "False", "F"]: 
				return false
	return null

# func set_export_arg(node, key, value):
# 	if key in node.args_type and typeof(value) == node.args_type[key]:
# 		args_export[key] = value
		
# 		return true
# 	return false
