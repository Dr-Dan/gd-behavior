extends Node

const BTNode = preload("res://addons/BehaviourTree/Base/BTNode.gd")
const BTDecorator = preload("res://addons/BehaviourTree/Base/BTDecorator.gd")
const BTComposite = preload("res://addons/BehaviourTree/Base/BTComposite.gd")

const BTRunner = preload("res://addons/BehaviourTree/TreeRunner.gd")

const Tick = preload("res://addons/BehaviourTree/Tick.gd")
	
class Composites:
	const Parallel = preload("res://addons/BehaviourTree/Composite/Parallel.gd")
	const Sequencer = preload("res://addons/BehaviourTree/Composite/Sequencer.gd")
	const SequencerMem = preload("res://addons/BehaviourTree/Composite/SequencerMemory.gd")
	const Selector = preload("res://addons/BehaviourTree/Composite/Selector.gd")
	const SelectorMem = preload("res://addons/BehaviourTree/Composite/SelectorMemory.gd")

class Decorators:
	const Succeeder = preload("res://addons/BehaviourTree/Decorator/Succeeder.gd")
	const Invert = preload("res://addons/BehaviourTree/Decorator/Invert.gd")