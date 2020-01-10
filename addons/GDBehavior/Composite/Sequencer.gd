extends "res://addons/GDBehavior/Base/BTComposite.gd"

func _init(children:Array=[]).(children, "sequencer"):
	pass
    
func _exe(tick):
	var result = SUCCESS
	for c in children:
		result = c.exe(tick)
		if result != SUCCESS:
			break
	return result