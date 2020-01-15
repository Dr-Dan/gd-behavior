extends Resource

const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")

var running = {}

func enter_tree(root):
	pass
	
func exit_tree(root, result):
	if result != BTNode.RUNNING:
		exit_running()
		
func exe(node):
	pass
	
func on_result(node, result):
	pass

func enter(node):
	pass
	
func exit(node):
	pass
		
func open(node):
	running[node] = -1
	
func close(node):
	running.erase(node)

func exit_running():
	for n in running:
		n._exit(self)		
	running = {}	