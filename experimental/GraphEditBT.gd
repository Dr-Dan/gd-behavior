extends "GraphEditBody.gd"

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")

const LeafType = preload("res://experimental/Leaf.gd")

var graph_nodes = {}

# TODO: move to context menu class
var context_menus = {
	leaves=null,
	composites=null,
	decorators=null
}

var node_types = {
	leaves=[],
	composites=[],
	decorators=[]
}


func _ready():
	context_menus["leaves"] = context_menu.create_submenu("leaves", "Leaves")
	context_menus["composites"] = context_menu.create_submenu("composites", "Composites")
	context_menus["decorators"] = context_menu.create_submenu("decorators", "Decorators")

	for c in context_menus:
		context_menus[c].connect("index_pressed", self, "_menu_item_pressed", [c])

func _menu_item_pressed(i, type):
	var nd = null
	match type:
		"composites":
			nd = Composite.instance()
		"decorators":
			nd = Decorator.instance()
		"leaves":
			nd = Leaf.instance()

	if nd != null:
		var d = node_types[type][i].display_name
		nd.set_name(d)
		nd.title = d
		nd.offset = context_menu.rect_position
		add_child(nd)
		nd.type = node_types[type][i].node_name

# func get_default(primitive_type):
# 	match primitive_type:
# 		TYPE_STRING:
# 			return ""
# 		TYPE_INT:
# 			return 0
func _input(event):
	if event is InputEventKey and not event.pressed and  event.scancode == KEY_A:
		var r = get_nodes_dfs_data(get_root_connection().to)
		for i in r:
			print(i)
#		print(r[0].children[0].name)
		# print(get_connection_list())
		
func add_leaf(node_name, display_name, args={}):
	context_menus["leaves"].add_item(display_name)
	node_types["leaves"].append({node_name=node_name, display_name=display_name, args=args})
	
func add_composite(node_name, display_name, args={}):
	context_menus["composites"].add_item(display_name)
	node_types["composites"].append({node_name=node_name, display_name=display_name, args=args})
	
func add_decorator(node_name, display_name, args={}):
	context_menus["decorators"].add_item(display_name)
	node_types["decorators"].append({node_name=node_name, display_name=display_name, args=args})
	
func get_nodes_dfs(root):
	var nodes = [get_node(root)]
	var children = get_links_out(root)
	for c in children:
		var next = get_node(c.to)
		if next is LeafType:
			nodes.append(next)
		else:
			nodes += get_nodes_dfs(c.to)

	return nodes

# result.children_ids is the offset from parent to child not absolute position in data
func get_nodes_dfs_data(root, i=[0]):
	var node = get_node(root)
	var nodes = [{index=i[0], node_name=node.type, args=node.args, children_nodes=[], children=[]}]
	var temp_i = i[0]
	for c in get_links_out(root):
		i[0] += 1
		nodes[0].children.append(i[0]-temp_i)
		nodes[0].children_nodes.append(get_node(c.to))
		var next = get_node(c.to)
		if next is LeafType:
			nodes.append({index=i[0], node_name=next.type, args=node.args})
		else:
			nodes += get_nodes_dfs_data(c.to)

	return nodes
	
# connection list looks like: {from:Root, from_port:0, to:Leaf, to_port:0}
func get_root_connection():
	for c in get_connection_list():
		if c.from == "Root":
			return c
	return null
