extends Resource

const BTNode = preload("res://addons/GDBehavior/Base/BTNode.gd")
const Composite = preload("res://addons/GDBehavior/Base/BTComposite.gd")

var running = {}
var depth: int
var history = []

func enter_tree(root):
	write_node_event(root, "enter_tree")
	
func exit_tree(root, result):
	write_node_event(root, "exit_tree")
	if result != BTNode.RUNNING:
		exit_running()
		
# called immediately after a node has executed		
func exe(node, result):
	write_node_event(node, "exe_node")
	pass
	
func enter(node):
	write_node_event(node, "enter_node")
	
func exit(node):
	write_node_event(node, "exit_node")
		
func open(node):
	running[node] = -1
	write_node_event(node, "open_node")
	if node is Composite:
		depth += 1
	
func close(node):
	running.erase(node)
	write_node_event(node, "close_node")
	if node is Composite:
		depth -= 1

func exit_running():
	history.append({msg="clear-running", depth=depth})	
	for n in running:
		n._exit(self)		
	running = {}	

func write_node_event(node, msg:String):
	history.append({name=node.name, msg=msg, depth=depth})	