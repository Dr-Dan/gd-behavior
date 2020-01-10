# GDBehavior

An addon for writing behavior trees in GDScript.
Written in Godot 3.1.

## Influences
* https://github.com/godot-addons/godot-behavior-tree-plugin
* [Behavior Trees in Robotics and AI](https://arxiv.org/pdf/1709.00084.pdf)

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

[Examples](https://github.com/Dr-Dan/gd-behavior/blob/master/examples)

Result constants are defined in the BTNode class (SUCCESS, FAILURE, RUNNING).

Base node types (Action, Conditional, Composite, Decorator) are in GDBehavior/Base folder.

### A Simple Action
```gdscript
class Print:
	extends "res://addons/GDBehavior/Base/BTAction.gd"
	var msg

	func _init(msg).("print"):
		self.msg = msg

    func _exe(tick):
        print(msg)
        return SUCCESS
```

Override the _exe function to apply an action's effects then return a result on completion.

_open, _closed, _enter, _exit functions are also inherited from BTAction<-BTNode


If you are going to use composites with memory (i.e. SequencerMem) then:
* Call Tick.exit_tree(root, result) after each pass of the tree.
* Or use TreeRunner.exe(tick) which will do so automatically


<!-- [Saving and Loading]((https://github.com/Dr-Dan/gd-behavior/blob/master/examples/SaveLoad/ExampleRunner.gd)) -->

## Later...

- [x] Save/load
- [x] Conditional, Action Node types
- [x] Decorator type
- [ ] Logger
- [ ] Documentation
- [ ] Tree Generation (GOAP, PPA)
- [ ] Resume from last running node