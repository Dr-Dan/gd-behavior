extends Resource

var running = {}

func enter_tree(root):
	pass
	
func exit_tree(root, result):
	pass
		
func exe(node, result):
	pass
	
func enter(node):
	pass
	
func exit(node):
	pass
		
func open(node):
	running[node] = -1
	
func close(node):
	running.erase(node)