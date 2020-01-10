extends "res://addons/GDBehavior/Base/BTComposite.gd"

func _init(child, name:String).([child], name):
#	assert(child != null)
	pass
	
func _exe(tick):
	return children[0].exe(tick)
	
func _get_child():
	return children[0]