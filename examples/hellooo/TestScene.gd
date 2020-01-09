extends Node2D

"""
An example where actors walk around and say something if within range.
Nodes are defined in script for tutorial purposes. This is not a requirement.
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
const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")

# Note: using time_waited[self] would overwrite if using an object multiple times in the tree.
# It would have the same effect on the running list
# this is fine: Parallel.new([WaitDelta.new(2), WaitDelta.new(2)], 2)
# this is not: var w = WaitDelta.new(2)  ...  Parallel.new([w,w], 2)

# Classes extending BTNode should override functions beginning with _ i.e. _exe, _open

class WaitDelta:
	extends BTNode
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

const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")
const Composites = preload("res://addons/GDBehavior/Composites.gd")
const Decorators = preload("res://addons/GDBehavior/Decorators.gd")
const SeqMem = Composites.SequencerMem
const SelMem = Composites.SelectorMem
const Parallel = Composites.Parallel
const Succeeder = Decorators.Succeeder

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
	var speak = SelMem.new([
		IsSpeaking.new(),
		SeqMem.new([
			ActorInRange.new(80.0, actors),
			SayRandom.new(),
			WaitDelta.new(2.5),
			StopSpeaking.new()])])
			
	var goto = SeqMem.new([
		GotoRandom.new(vp_sz, 80.0),
		WaitDelta.new(2.0),
		ColorRandom.new()])
		
	var root = Parallel.new([Succeeder.new(speak), goto], 2)
	tree_runner = BTRunner.new(root)
	
# Note: this could also be handled from each actor's _process(delta) function
func test_actor_goto(delta):
	for t in ticks:
		t.delta = delta
		# TreeRunner returns an integer for SUCCESS, FAILURE, RUNNING
		tree_runner.exe(t)