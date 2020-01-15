extends "res://addons/GDBehavior/Base/BTComposite.gd"

func _init(children:Array=[]).(children, "sequencer-memory"):
	pass
	
func _open(tick):
	tick.running[self] = 0
		
func _exe(tick):
	var result = SUCCESS
	var idx = tick.running[self]

	for i in range(idx, children.size(), 1):
		tick.running[self] = i
		var next = children[i]
		result = next.exe(tick)
		if result != SUCCESS:
			break
	return result