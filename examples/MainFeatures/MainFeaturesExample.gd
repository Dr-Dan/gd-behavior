extends Node2D

"""
An example where actors walk around and say something if within range.
"""

# ================================================================		
# The tick
# 	passed to each node as they execute
# 	handles the running memory and closing hanging nodes
#	useful for extracting information about execution for logging
# 	also used to get outside info to the running node as shown below
const Tick = preload("res://addons/GDBehavior/Tick.gd")

class TestTick:
	extends Tick
	
	# time_waited could also be an actor variable
	# inversely all actor data could reside in the tick
	var time_waited = {}
	var delta: float
	var actor
	
	func _init(actor):
		self.actor = actor
		
# ================================================================		
# CUSTOM NODES
const BTAction = preload("res://addons/GDBehavior/Base/BTAction.gd")

# Note: using time_waited[self] would overwrite if using an object multiple times in the tree.
# It would have the same effect on the running list
# this is fine: Parallel.new([WaitDelta.new(2), WaitDelta.new(2)], 2)
# this is not: var w = WaitDelta.new(2)  ...  Parallel.new([w,w], 2)

# Classes extending BTAction should override functions beginning with _ i.e. _exe, _open

class WaitDelta:
	extends BTAction
	var duration: float

	func _init(duration_secs:float).("wait_delta_time"):
		self.duration = duration_secs
		
	func _open(tick):
		tick.time_waited[self] = 0.0

	func _exe(tick):
		tick.time_waited[self] += tick.delta
		if tick.time_waited[self] > duration:
			return SUCCESS
		return RUNNING

class GotoRandom:
	extends BTAction
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
		
class ColorRandom:
	extends BTAction

	func _init().("color random"):
		pass

	func _exe(tick):
		tick.actor.self_modulate = random_color()
		return SUCCESS

	func random_color():
		return Color(randf(), randf(), randf())

class StopSpeaking:
	extends BTAction
	
	func _init().("stop speaking"):
		pass

	func _exe(tick):
		tick.actor.speech = ""
		return SUCCESS

class SayRandom:
	extends BTAction

	func _init().("say random greeting"):
		pass
		
	func _exe(tick):
		var gr = tick.actor.greetings
		var i = randi() % gr.size()
		tick.actor.speech = gr[i]
		return SUCCESS


# ================================================================		
# CONDITIONALS
const BTCondition = preload("res://addons/GDBehavior/Base/BTCondition.gd")

# work similarly to BTAction except _validate is overriden instead of _exe
# unlike _exe; _validate returns a bool
class AlwaysCondition:
	extends BTCondition
	var value:bool

	func _init(value:bool).("is speaking?"):
		self.value = value

	func _validate(tick):
		return value	
			
class ActorInRange:
	extends BTCondition
	
	var distance: float
	var actors = []
	
	func _init(distance, actors:Array).("actor in range?"):
		self.distance = distance
		self.actors = actors

	func _validate(tick):
		for a in actors:
			if a == tick.actor: continue
			if tick.actor.position.distance_to(a.position) < distance:
				return true
		return false
		
class IsSpeaking:
	extends BTCondition

	func _init().("is speaking?"):
		pass

	func _validate(tick):
		if tick.actor.speech != "":
			return true
		return false
	
				
# ================================================================		

func _ready() -> void:
	setup_actor_goto()

func _process(delta):
	test_actor_goto(delta)
		
# ================================================================		

const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")
const Composites = preload("res://addons/GDBehavior/Composites.gd")
const Decorators = preload("res://addons/GDBehavior/Decorators.gd")
const SeqMem = Composites.SequencerMem
const Parallel = Composites.Parallel
const Succeeder = Decorators.Succeeder

const MultiCondition = Decorators.MultiCondition
const Invert = Decorators.Invert

onready var actors = $Actors.get_children()

var ticks = []
var tree_runner

func setup_actor_goto():
	var vp_sz = get_viewport_rect().size
	for a in actors:
		var tick = TestTick.new(a)
		ticks.append(tick)
		a.position = Vector2(randf() * vp_sz.x, randf() * vp_sz.y)
	
	# Setup behaviours
	var speak = SeqMem.new([
		# Multi-Condition decorator
		MultiCondition.new(
			# if all return SUCCESS
			[Invert.new(IsSpeaking.new()), ActorInRange.new(80.0, actors)],	
			# do this. (can be any type of node.)
			SayRandom.new()), 
		WaitDelta.new(2.5),
		StopSpeaking.new()
	])
			
	var goto = SeqMem.new([
		GotoRandom.new(vp_sz, 120.0),
		WaitDelta.new(2.0),
		ColorRandom.new()
	])
		
	# Succeeder will stop any FAILUREs from interrupting parallel node
	# a RUNNING result will still get through however
	var root = Parallel.new([Succeeder.new(speak), goto], 2)
	tree_runner = BTRunner.new(root)
	
# Note: here for convenience. This can also be handled from each actor's _process(delta) function
func test_actor_goto(delta):
	for t in ticks:
		t.delta = delta
		# TreeRunner returns an integer for SUCCESS, FAILURE, RUNNING
		tree_runner.exe(t)