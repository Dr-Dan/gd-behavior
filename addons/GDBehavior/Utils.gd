const Composite = preload("res://addons/GDBehavior/Base/BTComposite.gd")

static func get_nodes_dfs(root:Composite):
	var nodes = [root]
	for c in root.children:
		if c is Composite:
			nodes += get_nodes_dfs(c)
		else:
			nodes.append(c)
			    
	return nodes
	
# result.children is the offset from parent to child not absolute position in data
static func get_nodes_dfs_data(root:Composite, depth=0, i=[0]):
	var nodes = [{node=root, depth=depth, children=[], index=i[0]}]
	depth += 1
	var temp_i = i[0]
	for c in root.children:
		i[0] += 1
		nodes[0].children.append(i[0]-temp_i)
		if c is Composite:
			nodes += get_nodes_dfs_data(c, depth, i)
		else:
			nodes.append({node=c, depth=depth, index=i[0]})
	return nodes

# ================================================================		

static func to_data(root:Composite):
	var nodes = get_nodes_dfs_data(root)
	var result = []
	var actions = {}
	var i = 0
	for n in nodes:
		var nd = n.node
		if not nd.name in actions:
			actions[nd.name] = nd.get_script().resource_path
		var nd_data = {name=nd.name, id=n.index}

		if nd.has_method("to_dict"):
			var args = nd.to_dict()
			for k in args:
				nd_data[k] = args[k]

		if nd is Composite:
			var args = nd.to_dict()
			for k in args:
				nd_data[k] = args[k]
			var children = []
			nd_data["children"] = n.children
		i+=1
		result.append(nd_data)

	return {tree=result, actions=actions}

static func from_data(data):
	var nodes = []
	var actions = data.actions
	for i in range(data.tree.size()-1, -1, -1):
		var nd_data = data.tree[i]
		var script = load(actions[nd_data.name])
		var node
		if "children" in nd_data:
			var children = []
			for j in nd_data.children:
				children.append(nodes[nodes.size()-j])
			node = script.new().from_dict(nd_data)
			node.set_children(children)
		else:
			node = script.new().from_dict(nd_data)
		node.name = nd_data.name
		nodes.append(node)

	return nodes.back()

