extends Sprite

var target:Vector2

var speech: String setget _set_speech
onready var label = $PanelContainer/Label

export var actor_name := "" setget _set_name, _get_name
export (Array, String) var greetings = [
	"Hello", "Good Day", "Yoyo-yo", "Wassuuuup", 
	"Aight", "Howdy", "EZ", "Hola", "Hey"]

func _ready():
	$NamePanel/Label.text = _get_name()
	
func _set_speech(val):
	if val == "":
		$PanelContainer.hide()
	else:
		$PanelContainer.show()	
		label.text = str(val)
	speech = val

func _set_name(s):
	actor_name = s
	$NamePanel/Label.text = s
	
func _get_name() -> String:
	if actor_name.empty():
		return name
	return actor_name
