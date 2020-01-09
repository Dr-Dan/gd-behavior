# GDBehavior

An addon for writing behavior trees in GDScript.
Written in Godot 3.1.

Influenced by https://github.com/godot-addons/godot-behavior-tree-plugin.

Also [Behavior Trees in Robotics and AI](https://arxiv.org/pdf/1709.00084.pdf)

## Philosophy

* Simple
* Extendable
* Good for:
  * learning
  * rapid prototyping
  * experimentation

## Installation
Download from the Godot Asset Store or clone and place into the 'addons' folder in your project.

```gdscript
# Not enabled
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
var seq = GDB.Composites.Sequencer.new(children)

# Enabled from Plugins menu
var seq = GDBehavior.Composites.Sequencer.new(children)
```
## Usage

Result constants are defined in the BTNode class (SUCCESS, FAILURE, RUNNING).

```gdscript
const GDB = preload("res://addons/GDBehavior/GDBehavior.gd")
const Tick = preload("res://addons/GDBehavior/Tick.gd")

# define an action
class Print:
	extends "res://addons/GDBehavior/Base/BTAction.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

    func _exe(tick):
        print(msg)

const Seq = preload("res://addons/GDBehavior/Composite/Sequencer.gd")
var tick = Tick.new()
func print_hello_world():
    var root = Seq.new([Print.new("Hello"), Print.new("World!")])
    var tree_runner = BTRunner.new(root)
    
    # prints "Hello", "World!"; result = BTNode.SUCCESS
    var result = tree_runner.exe(tick)
    
    # root.exe(tick) # would also work as no memory is required
    # tick.exit_tree(root, result) # will clear memory if required
    
```

[Examples](https://github.com/Dr-Dan/gd-behavior/blob/master/examples)

If you are going to use composites with memory (i.e. SequencerMem) then:
* Call Tick.exit_tree(root, result) after each pass of the tree.
* Or use TreeRunner.exe(tick) which will do so automatically


<!-- [Saving and Loading]((https://github.com/Dr-Dan/gd-behavior/blob/master/examples/SaveLoad/ExampleRunner.gd)) -->

## Later...

- [x] Save/load
- [x] Conditional, Action Node types
- [ ] Decorator type
- [ ] Logger/Tree-debugging
- [ ] Documentation
- [ ] Tree Generation (GOAP, PPA)