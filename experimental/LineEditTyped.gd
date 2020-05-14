extends LineEdit

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
	
func _set_text_value():
	if value != null:
		text = str(value)
	else:
		text = ""

func _update_value(txt):
	value = convert_input(txt, type)
	if value != null:
		text = str(value)
	else:
		text = ""
	emit_signal("value_entered", value)
	release_focus()

static func convert_input(input:String, _type):
	match _type:
		TYPE_STRING:
			return input
		TYPE_INT:
			return int(input)
		TYPE_REAL:
			return float(input)
		TYPE_BOOL:
			if input in ["true", "True", "T"]:
				return true
#			elif input in ["false", "False", "F"]: 
			else:
				return false
	return null
