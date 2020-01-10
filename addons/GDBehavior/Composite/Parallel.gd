extends "res://addons/GDBehavior/Base/BTComposite.gd"

# amount of nodes returning SUCCESS required before exit
# fails if n_failed > n_children - success_count
var success_count: int

func _init(children:Array=[], success_count:int=1).(children, "parallel"):
	self.success_count = min(success_count, children.size())
	
func _exe(tick):
	var succ = 0
	var fail = 0

	for c in children:
		var result = c.exe(tick)
		if result == SUCCESS:
			succ += 1
		elif result == FAILURE:
			fail += 1
			
	var result = RUNNING
	if succ >= success_count:
		result = SUCCESS
	elif fail > children.size() - success_count:
		result = FAILURE
		return result	
	return result
	
func to_dict():
	return {success_count=success_count}
	
func from_dict(dict):
	success_count = dict.success_count
	return self		