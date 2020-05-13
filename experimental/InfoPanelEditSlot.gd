extends PanelContainer

signal on_value_changed(value)

onready var key_edit = $Slot/Label
onready var value_edit = $Slot/TextEdit

var key: String setget set_key
var value: String setget set_value

var next = {}

func _ready():
	value_edit.connect("text_changed", self, "_on_value_changed")
	
func _process(delta):
	if not next.empty():
		key_edit.text = next.key
		value_edit.text = next.value
		next = {}
		
func set_key(val):
	key = val
	next["key"] = val
	
func set_value(val):
	value = val
	next["value"] = val

func _on_value_changed(text):
	emit_signal("on_value_changed", text)
