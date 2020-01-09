extends "res://addons/GDBehavior/Base/BTAction.gd"

var area: Vector2
var spd: float

func _init(area:Vector2=Vector2.ZERO, spd=40.0).("goto_pos"):
	self.area = area
	self.spd = spd
	
func _open(tick):
	tick.actor.target = random_pos()

func _exe(tick):
	var acc = tick.delta * spd
	var d = tick.actor.target - tick.actor.position
	if d.length() < acc:
		tick.actor.position = tick.actor.target
		return SUCCESS
	else:
		var vel = d.normalized() * acc
		tick.actor.position += vel
	return RUNNING
			
func random_pos():
	var x = randf() * area.x
	var y = randf() * area.y
	return Vector2(x,y)
	
func to_dict():
	return {area=var2str(area), spd=spd}
	
func from_dict(dict):
	area = str2var(dict.area)
	spd = dict.spd
	return self	