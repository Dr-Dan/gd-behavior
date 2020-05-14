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
	_set_text_value()
	emit_signal("value_entered", value)
	release_focus()

static func convert_input(input:String, _type:int):
	match _type:
		TYPE_STRING:
			return str(input)
		TYPE_INT:
			return int(input)
		TYPE_REAL:
			return float(input)
		TYPE_BOOL:
			if input in ["true", "True", "T", "1"]:
				return true
#			elif input in ["false", "False", "F", "0"]: 
			else:
				return false
	return null
