
static func get_default(type:int):
	return convert_input("", type)

static func convert_input(input:String, _type:int):
	match _type:
		TYPE_STRING:
			return str(input)
		TYPE_INT:
			return int(input)
		TYPE_REAL:
			return float(input)
		TYPE_BOOL:
			if input.to_lower() in ["true", "t", "1"]:
				return true
#			elif input in ["false", "False", "F", "0"]: 
			else:
				return false
	return null
