extends "GraphEditBody.gd"

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")

const LeafType = preload("res://experimental/Leaf.gd")

const LEAF = "leaf"
const COMPOSITE = "composite"
const DECORATOR = "decorator"

var graph_nodes = {}

var node_types = {
	LEAF:[],
	COMPOSITE:[],
	DECORATOR:[]
}


func _ready():
	context_menu.create_submenu(LEAF, "Leaves")
	context_menu.create_submenu(COMPOSITE,"Composites")
	context_menu.create_submenu(DECORATOR,"Decorators")
	context_menu.connect("on_menu_item_chosen", self, "_menu_item_pressed")

func _menu_item_pressed(submenu_name, submenu_idx):
	var node_data = node_types[submenu_name][submenu_idx]
	create_node(submenu_name, node_data, context_menu.rect_position)

func create_node(type, data, offset=Vector2()):
	var nd = get_instance(type)
	if nd != null:
		nd.set_name(data.display_name)
		nd.title = data.display_name
		nd.offset = offset
		nd.type = data.node_name
		nd.args_export = data.args_export.duplicate()
		nd.args_type = data.args_type.duplicate()
		add_child(nd)
		return nd
	return null

func get_instance(type):
	var nd = null
	match type:
		LEAF:
			nd = Leaf.instance()
		COMPOSITE:
			nd = Composite.instance()
		DECORATOR:
			nd = Decorator.instance()
	return nd
	
func get_node_data(type, node_name):
	for n in node_types[type]:
		if n.node_name == node_name:
			return n
	return null

func add_node_type(node_name, node_type, display_name, args_type={}, args_export={}):
	context_menu.get_submenu(node_type).add_item(display_name)
	node_types[node_type].append({
		node_name=node_name, display_name=display_name, args_type=args_type, args_export=args_export})
		
func add_leaf(node_name, display_name, args_type={}, args_export={}):
	add_node_type(node_name, LEAF, display_name, args_type, args_export)

func add_composite(node_name, display_name, args_type={}, args_export={}):
	add_node_type(node_name, COMPOSITE, display_name, args_type, args_export)

func add_decorator(node_name, display_name, args_type={}, args_export={}):
	add_node_type(node_name, DECORATOR, display_name, args_type, args_export)

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
	var nodes = [{index=i[0], name=node.type, args_export=node.args_export, args_type=node.args_type, children_nodes=[], children=[]}]
	var temp_i = i[0]
	for c in get_links_out(root):
		i[0] += 1
		nodes[0].children.append(i[0]-temp_i)
		nodes[0].children_nodes.append(get_node(c.to))
		var next = get_node(c.to)
		if next is LeafType:
			nodes.append({index=i[0], name=next.type, args_export=next.args_export, args_type=node.args_type})
		else:
			nodes += get_nodes_dfs_data(c.to, i)

	return nodes
	
# connection list looks like: {from:Root, from_port:0, to:Leaf, to_port:0}
func get_root_connection():
	for c in get_connection_list():
		if c.from == "Root":
			return c
	return null
