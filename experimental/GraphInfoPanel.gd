extends PanelContainer

signal on_value_changed(node_name, key, value)

const Slot = preload("res://experimental/InfoPanelEditSlot.tscn")

onready var heading_label = $VBoxContainer/Heading/Label
onready var slots = $VBoxContainer/Slots

# TODO: remove the node, store only the required data
#var current_node = null

var edit_slots = []

# USES: args_type, args_export, 
# could use name in signal
# TODO: take name, arg types and arg values
func show_info(node):
	heading_label.text = node.title
	for c in slots.get_children():
		c.free()

	for a in node.args_type:
		var s = Slot.instance()
		slots.add_child(s)
		
		s.key = a
		if a in node.args_export:
			s.value = str(node.args_export[a])
		else:
			s.value = ""
		s.value_edit.type = int(node.args_type[a])
		s.connect("on_value_changed", self, "_set_value", [a, node])
		
# TODO: use signal for this, 
func _set_value(value, key, node):
	if is_instance_valid(node):
		node.args_export[key] = value
