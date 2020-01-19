extends Resource

"""

"""

const Utils = preload("res://addons/GDBehavior/Utils.gd")

static func save_tree(root, filename:String):
	var data = Utils.to_data(root)
	var save_game = File.new()
	assert(filename != "")
	save_game.open(filename, File.WRITE)
	save_game.store_line(to_json(data))
	save_game.close()
	if save_game.file_exists(filename):
		return true
	return false
	
static func load_tree(filename):
	var save_game = File.new()
	if not save_game.file_exists(filename):
		return [] # Error! We don't have a save to load.

	save_game.open(filename, File.READ)
	var data = parse_json(save_game.get_line())
	save_game.close()
	return Utils.from_data(data)
	

static func delete_file(filename:String):
	var dir = Directory.new()
	if dir.file_exists(filename):
		dir.remove(filename)
		return true
	return false
				