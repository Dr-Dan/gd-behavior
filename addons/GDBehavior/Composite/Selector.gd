extends "res://addons/GDBehavior/Base/BTComposite.gd"

func _init(children:Array=[]).(children, "selector"):
	pass
    
func _exe(tick):
	var result = FAILURE
	for c in children:
		result = c.exe(tick)
		if result != FAILURE:
			break
	return result
