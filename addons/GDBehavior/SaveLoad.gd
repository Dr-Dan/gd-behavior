extends Resource

"""

"""

const Utils = preload("res://addons/GDBehavior/Utils.gd")

static func save_data(data, filename:String):
	var save_game = File.new()
	assert(filename != "")
	save_game.open(filename, File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	if save_game.file_exists(filename):
		return true
	return false
	
static func save_tree(root, filename:String):
	var data = Utils.to_data(root)
	return save_data(root, filename)
	

static func load_data(filename):
	var save_game = File.new()
	if not save_game.file_exists(filename):
		return null # Error! We don't have a save to load.

	save_game.open(filename, File.READ)
	var data = parse_json(save_game.get_line())
	save_game.close()
	return data
	
static func load_tree(filename):
	var data = load_data(filename)
	return Utils.from_data(data)
	

static func delete_file(filename:String):
	var dir = Directory.new()
	if dir.file_exists(filename):
		dir.remove(filename)
		return true
	return false
				
