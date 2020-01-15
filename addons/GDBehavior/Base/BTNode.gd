extends Resource

const FAILURE = -1
const SUCCESS = 1
const RUNNING = 2

var name:String
func _init(name:String):
	assert(not name.empty())
	self.name = name

func exe(tick):
	tick.enter(self)
	
	if not self in tick.running:
		tick.open(self)
		_open(tick)

	tick.exe(self) 
	var result = _exe(tick)
	assert(result != null) # Did you remember to return a result?..
	tick.on_result(self, result) 
	
	if _should_close(result):
		tick.close(self)
		_close(tick)
		
	_exit(tick)
	tick.exit(self)
	
	return result

# ========================================
# Extend these

func _exe(tick):
	return SUCCESS

func _enter(tick):
	pass

func _exit(tick):
	pass
	
func _open(tick):
	pass

func _close(tick):
	pass	

# ========================================

func _should_close(result):
	return result != RUNNING
	
# ========================================

func to_dict():
	return {}
	
func from_dict(dict):	
	return self