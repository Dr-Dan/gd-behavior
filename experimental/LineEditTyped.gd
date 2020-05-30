extends LineEdit

const Utils = preload("res://experimental/Utils.gd")

signal value_entered(value)

enum InputType {
	None=-1, 
	Str=TYPE_STRING,
	Int=TYPE_INT,
	Bool=TYPE_BOOL,
	Float=TYPE_REAL
	}

export (InputType) var type = InputType.Str
var value

func _ready():
	connect("text_entered", self, "_update_value")

	connect("focus_entered", self, "_set_text_value")
	connect("focus_exited", self, "_set_text_value")
	
	
func _gui_input(event):
	if event is InputEventKey:
		accept_event()
		
func _set_text_value():
	if value != null:
		text = str(value)
	else:
		text = ""

func _update_value(txt):
	value = Utils.convert_input(txt, type)
	_set_text_value()
	emit_signal("value_entered", value)
	release_focus()
