extends PanelContainer

signal on_value_changed(value)

onready var key_edit = $Slot/Label
onready var value_edit = $Slot/TextEdit

var key: String setget set_key
var value: String setget set_value

func _ready():
	value_edit.connect("value_entered", self, "_on_value_changed")
	# focus_mode = Control.FOCUS_ALL
		
func set_key(key):
	key = key
	key_edit.text = key
	
func set_value(val):
	value = val
	value_edit.text = str(val)
	value_edit.value = val

func _on_value_changed(value):
	emit_signal("on_value_changed", value)
