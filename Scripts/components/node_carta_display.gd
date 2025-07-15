

@tool
class_name NodeCartaDisplay extends Sprite2D

signal finished_auto_moving

var draggable := false
var slot_index : int
var position_goal : Vector2
var data : CartaRES

# func _set(property: StringName, value: Variant) -> bool:
# 	if property == "scale" or property == "position":
# 		#print(util.get_size(self))
# 		#print(str(scale) + "/" + str(util.scale_to_same_size(util.carta_size, util.get_size(self))))
# 		#scale = util.scale_to_same_size(util.carta_size, util.get_size(self))
# 		return true
# 	return false


func _ready() -> void:
	#print(get_rect().size * scale)
	pass
	# print(get_rect())
	# print(util.scale_to_same_size(util.carta_size, get_rect().size))
	# global_scale = util.scale_to_same_size(util.carta_size, get_rect().size) 

func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)

func scale_to_same_size(reference_size : Vector2, old_size : Vector2) -> Vector2:
	return Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y)
	

#func _physics_process(delta: float) -> void:

func drag_to_slot(slot: Sprite2D) -> void :
	var vboxCont : SlotManager = slot.get_parent().get_parent()
	slot_index = vboxCont.find_slot(slot)
	print(slot)
	print(slot.get_position_for_node2d())
	global_position = slot.get_position_for_node2d()

func move_at_start() -> void:
	global_position.x = lerp(global_position.x, position_goal.x, 0.1)
	global_position.y = lerp(global_position.y, position_goal.y, 0.1)
	print(global_position, position_goal)
	if ceilf(global_position.y) >= position_goal.y:
		finished_auto_moving.emit()
		draggable = true

func updateUI(_data: CartaRES) -> void:
	get_node("UIHandler").update(_data)


func go_to_slot(slot: Sprite2D) -> void:
	var vboxCont : SlotManager = slot.get_parent().get_parent()
	slot_index = vboxCont.find_slot(slot)
	print(slot)
	position_goal = slot.get_position_for_node2d()

#func go_to_slot_index(index: int) -> void:
