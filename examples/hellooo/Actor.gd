extends Sprite

# This could alternatively be stored in the Tick
var time_waited = {}

var target:Vector2

var speech: String setget _set_speech
onready var label = $PanelContainer/Label

export (Array, String) var greetings = [
	"Hello", "Good Day", "Yoyo-yo", "Wassuuuup", 
	"Aight", "Howdy", "EZ", "Hola", "Hey"]

func _set_speech(val):
	if val == "":
		$PanelContainer.hide()
	else:
		$PanelContainer.show()	
		label.text = str(val)
	speech = val
