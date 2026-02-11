extends Node

var _delta := 0.0
var _pdelta := 0.0

func crit_lerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _delta), 0.0, 1.0))

func crit_plerp(speed: float) -> float:
	return(clamp(1.0 - exp(-speed * _pdelta), 0.0, 1.0))

# Get all children recursively
func get_all_children(node: Node, arr := []) -> Array:
	arr.push_back(node)
	for _child in node.get_children():
		arr = get_all_children(_child, arr)
	return(arr)

# Togglable debug printing with class/node prefixes
func pdebug(text: String, source := "") -> void:
	var line := text
	if source != "":
		line = "[" + source + "] " + line
	print(line)

# Unwrap a vector string in the form "x, y, z" to a typed Vector3
func unwrap_vec3_str(vector3_string: String) -> Vector3:
	var uvec := vector3_string.split(",") # unwrapped vector
	if uvec.size() != 3:
		return(Vector3.ZERO)
	return(Vector3(float(uvec[0]), float(uvec[1]), float(uvec[2])))

func _process(delta: float) -> void: _delta = delta

func _physics_process(delta: float) -> void: _pdelta = delta
