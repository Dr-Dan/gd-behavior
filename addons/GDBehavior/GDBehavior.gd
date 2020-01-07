extends Node

const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")
const BTDecorator = preload("res://addons/GDBehavior/Base/BTDecorator.gd")
const BTComposite = preload("res://addons/GDBehavior/Base/BTComposite.gd")

const BTRunner = preload("res://addons/GDBehavior/TreeRunner.gd")

const Tick = preload("res://addons/GDBehavior/Tick.gd")
	
class Composites:
	const Parallel = preload("res://addons/GDBehavior/Composite/Parallel.gd")
	const Sequencer = preload("res://addons/GDBehavior/Composite/Sequencer.gd")
	const SequencerMem = preload("res://addons/GDBehavior/Composite/SequencerMemory.gd")
	const Selector = preload("res://addons/GDBehavior/Composite/Selector.gd")
	const SelectorMem = preload("res://addons/GDBehavior/Composite/SelectorMemory.gd")

class Decorators:
	const Succeeder = preload("res://addons/GDBehavior/Decorator/Succeeder.gd")
	const Invert = preload("res://addons/GDBehavior/Decorator/Invert.gd")