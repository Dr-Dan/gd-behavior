extends Resource

"""
# Type 1
structure = [
	{id=0, name="Seq", children=[1,2], script="res://..."},
	{id=1, name="Print", msg="Hello", script="res://..."},
	{id=2, name="Print", msg="World!", script="res://..."},
]
"""

const Composite = preload("res://addons/GDBehavior/Base/BTComposite.gd")
const Decorator = preload("res://addons/GDBehavior/Base/BTDecorator.gd")

static func save_tree(root:Composite, filename:String):
	var data = to_data(root)
	var save_game = File.new()
	assert(filename != "")
	filename = "user://%s.save" % filename
	save_game.open(filename, File.WRITE)
	for d in data:
		save_game.store_line(to_json(d))
	save_game.close()
	if save_game.file_exists(filename):
		return true
	return false
	
static func load_tree(filename):
	var save_game = File.new()
	filename = "user://%s.save" % filename
	if not save_game.file_exists(filename):
		return [] # Error! We don't have a save to load.

	save_game.open(filename, File.READ)
	var nodes = []
	while not save_game.eof_reached():
		var line = parse_json(save_game.get_line())
		if line == null: continue
		nodes.append(line)
		
	return from_data(nodes)
	
static func delete_tree(tree_name:String):
	var result = false
	# TODO: move to validate func
	if not tree_name.empty() and not tree_name.begins_with("."):
		result = _delete_file(tree_name)
		return result
	return false
		
static func _delete_file(save_name:String):
	var dir = Directory.new()
	var file_path = "user://%s.save" % save_name
	if dir.file_exists(file_path):
		dir.remove(file_path)
		return true
	return false
					
static func to_data(root:Composite):
	var nodes = get_nodes_dfs(root)
	var result = []
	var i = 0
	for nd in nodes:
		var nd_data = {name=nd.name, script=nd.get_script().resource_path}
		if nd.has_method("to_dict"):
			var args = nd.to_dict()
			for k in args:
				nd_data[k] = args[k]

		if nd is Composite:
			var args = nd.to_dict()
			for k in args:
				nd_data[k] = args[k]
			var children = []
			for ch in nd.children:
				var index = nodes.find(ch)
				children.append(index-i)
			nd_data["children"] = children
		i+=1
		result.append(nd_data)

	return result

static func from_data(data):
	var nodes = []
	for i in range(data.size()-1, -1, -1):
		var nd_data = data[i]
		var script = load(nd_data.script)
		var node
		if "children" in nd_data:
			var children = []
			for j in nd_data.children:
				children.append(nodes[nodes.size()-j])
			# TODO: shouldn't rely on single argument constructors for composites
			# At the least, all nodes should have arg-less constructor			
			node = script.new().from_dict(nd_data) # .with_children(children)?
			node.set_children(children)
		else:
			node = script.new().from_dict(nd_data)
		node.name = nd_data.name
		nodes.append(node)

	return nodes.back()


static func get_nodes_dfs(root:Composite):
	var nodes = [root]
	for c in root.children:
		if c is Composite:
			nodes += get_nodes_dfs(c)
		else:
			nodes.append(c)
			    
	return nodes