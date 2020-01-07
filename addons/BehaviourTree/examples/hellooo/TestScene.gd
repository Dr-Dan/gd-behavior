extends Node2D

# ================================================================		
const Tick = preload("res://addons/BehaviourTree/Tick.gd")

class TestTick:
	extends Tick
	
	var delta: float
	var actor
	
	func _init(actor):
		self.actor = actor
		
# ================================================================		
# CUSTOM ACTIONS
const BTNode = preload("res://addons/BehaviourTree/Base/BTNode.gd")

class WaitDelta:
	extends BTNode
	var duration: float
	var timer_index:int
	func _init(duration_secs:float, timer_index:int=0).("wait_delta_time"):
		self.duration = duration_secs
		self.timer_index = timer_index
		
	func _open(tick):
		set_time(tick, 0.0)
		
	func _exe(tick):
#		var t = tick.actor.time_waited
		tick.actor.time_waited[timer_index] += tick.delta
#		set_time(tick, t)
		if tick.actor.time_waited[timer_index] > duration:
			return SUCCESS
		return RUNNING

	func set_time(tick, t):
		tick.actor.time_waited[timer_index] = t

class GotoRandom:
	extends BTNode
	var area: Vector2
	var stop_dist: float
	var spd: float
	
	func _init(area:Vector2, spd=40.0, stop_dist=8.0).("goto_pos"):
		self.area = area
		self.stop_dist = stop_dist
		self.spd = spd
		
	func _open(tick):
		tick.actor.target = random_pos()

	func _exe(tick):
		var d = tick.actor.target - tick.actor.position
		if d.length() < stop_dist:
			return SUCCESS
		else:
			var vel = d.normalized() * tick.delta * spd
			tick.actor.position += vel.round()
		return RUNNING
				
	func random_pos():
		var x = randf() * area.x
		var y = randf() * area.y
		return Vector2(x,y)
		
class ColorRandom:
	extends BTNode

	func _init().("color random"):
		pass

	func _exe(tick):
		tick.actor.self_modulate = random_color()
		return SUCCESS

	func random_color():
		return Color(randf(), randf(), randf())

class StopSpeaking:
	extends BTNode
	
	func _init().("stop speaking"):
		pass

	func _exe(tick):
		tick.actor.speech = ""
		return SUCCESS

class SayRandom:
	extends BTNode

	func _init().("say random greeting"):
		pass
		
	func _exe(tick):
		var gr = tick.actor.greetings
		var i = randi() % gr.size()
		tick.actor.speech = gr[i]
		return SUCCESS

# CONDITIONALS
				
class ActorInRange:
	extends BTNode
	
	var distance: float
	var actors = []
	
	func _init(distance, actors:Array).("actor in range?"):
		self.distance = distance
		self.actors = actors

	func _exe(tick):
		for a in actors:
			if a == tick.actor: continue
			if tick.actor.position.distance_to(a.position) < distance:
				return SUCCESS
		return FAILURE
		
class IsSpeaking:
	extends BTNode

	func _init().("is speaking?"):
		pass

	func _exe(tick):
		if tick.actor.speech != "":
			return SUCCESS
		return FAILURE
				
# ================================================================		

func _ready() -> void:
	setup_actor_goto()

func _process(delta):
	test_actor_goto(delta)
		
# ================================================================		

const BT = preload("res://addons/BehaviourTree/BehaviourTree.gd")
const SeqMem = BT.Composites.SequencerMem
const SelMem = BT.Composites.SelectorMem
const Parallel = BT.Composites.Parallel
const Succeeder = BT.Decorators.Succeeder

onready var actors = $Actors.get_children()

var ticks = []
var wait_runner

func setup_actor_goto():
	var vp_sz = get_viewport_rect().size
	for a in actors:
		var tick = TestTick.new(a)
		ticks.append(tick)
		a.position = Vector2(randf() * vp_sz.x, randf() * vp_sz.y)
	
	# Setup behaviours
	var speak = SelMem.new([
		IsSpeaking.new(),
		SeqMem.new([
			ActorInRange.new(64.0, actors),
			SayRandom.new(),
			WaitDelta.new(2.5, 0),
			StopSpeaking.new()])])
			
	var goto = SeqMem.new([
		GotoRandom.new(vp_sz, 80.0),
		WaitDelta.new(2.0, 1),
		ColorRandom.new()])
		
	var act = Parallel.new([Succeeder.new(speak), goto], 2)
	wait_runner = BT.BTRunner.new(act)
	
func test_actor_goto(delta):
	for t in ticks:
		t.delta = delta
		wait_runner.exe(t)