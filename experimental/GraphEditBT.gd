extends "GraphEditBody.gd"

# signal on_node_selected(node, args_type)

const Composite = preload("res://experimental/Composite.tscn")
const Decorator = preload("res://experimental/Decorator.tscn")
const Leaf = preload("res://experimental/Leaf.tscn")
const NodeFactory = preload("res://experimental/GraphNodeFactory.gd")
const SaveLoad = preload("res://addons/GDBehavior/SaveLoad.gd")

const LEAF = "leaf"
const COMPOSITE = "composite"
const DECORATOR = "decorator"

var node_factory = NodeFactory.new()

var save_btn
var load_btn

var node_types = {
	LEAF:[],
	COMPOSITE:[],
	DECORATOR:[]
}

var name2file = {}

func _ready():
	add_valid_connection_type(0,1)
	# context_menu.connect("on_menu_item_chosen", self, "_menu_item_pressed")

	context_menu.create_submenu(LEAF, "Leaves")
	context_menu.create_submenu(COMPOSITE,"Composites")
	context_menu.create_submenu(DECORATOR,"Decorators")

	node_factory.add_base_type(LEAF, Leaf)
	node_factory.add_base_type(COMPOSITE, Composite)
	node_factory.add_base_type(DECORATOR, Decorator)

	save_btn = Button.new()
	save_btn.text = "Save"
	get_zoom_hbox().add_child(save_btn)
	
	load_btn = Button.new()
	load_btn.text = "Load"
	get_zoom_hbox().add_child(load_btn)

func _menu_item_pressed(submenu_name, submenu_idx):
	var node_data = node_types[submenu_name][submenu_idx]
	var node = node_factory.create_node(node_data, context_menu.rect_position+scroll_offset)
	if node != null:
		add_node_obj(node)
		


func add_node_type(base_type, type_name, display_name, filepath, args_type={}):
	context_menu.get_submenu(base_type).add_item(display_name)
	
	var data = {
		type_name=type_name,
		base_type=base_type,
		display_name=display_name,
		args_type=args_type,
		# args_export=args_export,
		filepath=filepath,
	}
	node_types[base_type].append(data)
	name2file[type_name] = filepath

# connection list looks like: [{from:"Source", from_port:0, to:"Dest", to_port:0}, ...]
func get_root_connection():
	for c in get_connection_list():
		if c.from == "Root":
			return c
	return null


# result.children_ids is the offset from parent to child not absolute position in data
func get_nodes_dfs_data_graph(root, i=[0]):
	var node = get_node(root)
	var data = node.graph_data()
	data["index"] = i[0]
	
	var links_out = get_links_out(root)
	if links_out.size() > 0:
		data["children"] = []
	var nodes = [data]
	
	for c in links_out:
		i[0] += 1
		data["children"].append(i[0]-data["index"])
		nodes += get_nodes_dfs_data_graph(c.to, i)

	return nodes

func get_nodes_dfs_data_bt(root, i=[0]):
	var node = get_node(root)
	var data = node.bt_data()
	data["index"] = i[0]
	
	var links_out = get_links_out(root)
	if links_out.size() > 0:
		data["children"] = []
	var nodes = [data]
	
	for c in links_out:
		i[0] += 1
		data["children"].append(i[0]-data["index"])
		nodes += get_nodes_dfs_data_bt(c.to, i)

	return nodes
	
func to_dict():
	var d = {tree=[], graph=[], nodes={}}
	var r = get_root_connection()
	if r != null:
		d['tree'] = get_nodes_dfs_data_bt(r.to)
		d['graph'] = get_nodes_dfs_data_graph(r.to)
		d['nodes'] = name2file.duplicate()
	return d
	
# USES: children, offset
func from_dict(data):
	clear_nodes()
	var nodes = []
	var start_pos = Vector2()
	for i in range(data.graph.size()-1, -1, -1):
		var nd_data = data.graph[i]
		var offset = Vector2(nd_data.offset_x, nd_data.offset_y)
		var node
		if "children" in nd_data:
			node = node_factory.create_node(nd_data, offset)
			add_node_obj(node)

			for j in nd_data.children:
				# current node is last added
				var c = nodes[nodes.size()-j]
				connect_nodes_easy(node.name, c.name)
		else:
			node = node_factory.create_node(nd_data, offset)
			add_node_obj(node)
			
		nodes.append(node)
	for d in data.nodes:
		name2file[d] = data.nodes[d]

	connect_nodes_easy($Root.name, nodes.back().name)
	return nodes.back()


# SAVING + LOADING
func save_graph(_filename:String):
	var dir = Directory.new()
	if dir.dir_exists(_filename.get_base_dir()):
		var data = to_dict()
		if not data.tree.empty():
			var saved = SaveLoad.save_data(data, _filename)
			if saved:
				print("saved [%s]" % _filename)
				return true
				
	else:
		print("directory [%s] not found" % _filename)
	print("failed to save [%s]" % _filename)
	return false

func load_graph(_filename:String):
	var dir = Directory.new()
	if dir.dir_exists(_filename.get_base_dir()):
		var data_loaded = SaveLoad.load_data(_filename)
		if data_loaded != null:
			from_dict(data_loaded)
			print("loaded [%s]" % _filename)
			selected = []
		else:
			print("could not load [%s]" % _filename)
	else:
		print("directory [%s] not found" % _filename)
