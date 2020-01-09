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

func _ready() -> void:
	setup_actor_goto()

func _process(delta):
	test_actor_goto(delta)
		
# ================================================================		

const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Composites = preload("res://addons/GDBehavior/Composites.gd")
const SeqMem = Composites.SequencerMem
const Parallel = Composites.Parallel

const Wait = preload("res://examples/SaveLoad/Actions/WaitDelta.gd")
const GotoRandom = preload("res://examples/SaveLoad/Actions/GotoRandom.gd")
const Speak = preload("res://examples/SaveLoad/Actions/SayRandom.gd")
const StopSpeaking = preload("res://examples/SaveLoad/Actions/StopSpeaking.gd")
const Print = preload("res://examples/SaveLoad/Actions/Print.gd")

const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

onready var actors = $Actors.get_children()

var ticks = []
var tree_runner: BTRunner

func setup_actor_goto():
	var vp_sz = get_viewport_rect().size
	for a in actors:
		var tick = TestTick.new(a)
		ticks.append(tick)
		a.position = Vector2(randf() * vp_sz.x, randf() * vp_sz.y)
	
	var goto = SeqMem.new([
			GotoRandom.new(vp_sz, 400.0),
			Wait.new(0.0)])
		
	var speak = SeqMem.new([
		Speak.new(),
		Wait.new(2.0),
		StopSpeaking.new(),
		Wait.new(3.0),
		Print.new("I will now speak...")])
	var root = Parallel.new([goto, speak], 2)
		
	print("\nSAVED TREE")
	var data_save = SaveLoad.to_data(root)
	for d in data_save:
		print(d)

	root = SaveLoad.from_data(data_save)
	var data_load = SaveLoad.to_data(root)
	print("\nLOADED TREE")
	for d in data_load:
		print(d)
	print("\n")
	
	var test_filename = "bt_save_test"
	var saved = SaveLoad.save_tree(root, test_filename)
	assert(saved)
	var root_loaded = SaveLoad.load_tree(test_filename)
	tree_runner = BTRunner.new(root_loaded)

# Note: this could also be handled from each actor's _process(delta) function
func test_actor_goto(delta):
	for t in ticks:
		t.delta = delta
		# TreeRunner returns an integer for SUCCESS, FAILURE, RUNNING
		tree_runner.exe(t)