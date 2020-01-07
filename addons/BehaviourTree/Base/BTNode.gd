extends Resource

const FAILURE = "failure"
const SUCCESS = "success"
const RUNNING = "running"

var name:String
func _init(name:String):
	assert(not name.empty())
	self.name = name

func exe(tick):
	tick.enter(self)
	
	if not self in tick.running:
		tick.open(self)
		_open(tick)

	var result = _exe(tick)
	assert(result != null) # Did you remember to return a result?..
	tick.exe(self, result)
	
	if _should_close(result):
		tick.close(self)
		_close(tick)
		
	_exit(tick)
	tick.exit(self)
	
	return result

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

func _should_close(result):
	return result != RUNNING