extends Node2D

"""
An example showing the save system. 
Note that nodes need to be defined in seperate files as the script-path needs to be saved.
Also if a file is moved or renamed post-save, loading will fail.
"""

# ================================================================		
const Tick = preload("res://addons/GDBehavior/Tick.gd")

class TestTick:
	extends Tick
	
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

const MeetsCond = preload("res://addons/GDBehavior/Decorator/MeetsConditions.gd")
const AlwaysCond = preload("res://examples/SaveLoad/Actions/AlwaysCondition.gd")

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
		Wait.new(1.0)])
		
	var speak = SeqMem.new([
		MeetsCond.new(
			Speak.new(), [AlwaysCond.new(true)]),
		Wait.new(2.0),
		StopSpeaking.new(),
		Wait.new(3.0),		
		])
		
	var root = Parallel.new([goto, speak], 2)
		
	var data_save = SaveLoad.to_data(root)
	root = SaveLoad.from_data(data_save)
	
	var data_load = SaveLoad.to_data(root)
		
	for i in range(data_save.size()):
		for key in data_save[i]:
			assert(data_save[i][key] == data_load[i][key])
				
	var test_filename = "bt_save_test"
	var saved = SaveLoad.save_tree(root, test_filename)
	assert(saved)
	var root_loaded = SaveLoad.load_tree(test_filename)
	assert(root_loaded)
	var destroyed = SaveLoad.delete_tree(test_filename)
	assert(destroyed)
	tree_runner = BTRunner.new(root_loaded)


func test_actor_goto(delta):
	for t in ticks:
		t.delta = delta
		tree_runner.exe(t)