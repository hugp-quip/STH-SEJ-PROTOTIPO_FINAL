@tool
class_name NodeSlot extends Sprite2D


func _set(property: StringName, value: Variant) -> bool:
	if property == "scale" or property == "position":
		print(util.get_size(self))
		print(str(scale) + "/" + str(util.scale_to_same_size(util.carta_size, util.get_size(self))))
		scale = util.scale_to_same_size(util.carta_size, util.get_size(self))
		return true
	return false

func _ready() -> void:
	pass
	# print(get_rect())
	# print(util.scale_to_same_size(util.carta_size, get_rect().size))
#	global_scale = util.scale_to_same_size(util.carta_size, get_rect().size) 