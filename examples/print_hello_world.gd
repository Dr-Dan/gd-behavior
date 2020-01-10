tool
extends EditorScript

"""
Simple example
	
Usage:
	File > Run
	Check 'Output' panel
"""

const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Seq = GDB.Composites.Sequencer

class Print:
	extends "res://addons/GDBehavior/Base/BTAction.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

	func _exe(tick):
		print(msg)
		# !!! don't forget to return a result !!!
		return SUCCESS 


var tick = GDB.Tick.new()

func print_hello_world():
	var root = Seq.new([Print.new("Hello"), Print.new("World!")])
	var tree_runner = GDB.TreeRunner.new(root)
    
    # prints "Hello", "World!"; result = BTNode.SUCCESS
	var result = tree_runner.exe(tick)
	print(result == GDB.BTNode.SUCCESS)
    # root.exe(tick) # would also work as no running memory is required in tree
    
func _run():
	print_hello_world()