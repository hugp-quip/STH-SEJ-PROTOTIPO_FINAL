extends Sprite2D

class_name TempCartaDisplay

signal finished_auto_moving

var draggable := false
var slot_index : int
var position_goal : Vector2
var data : CartaRES

func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)

#func _physics_process(delta: float) -> void:

func drag_to_slot(slot: Panel) -> void :
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


func go_to_slot(slot: Panel) -> void:
	var vboxCont : SlotManager = slot.get_parent().get_parent()
	slot_index = vboxCont.find_slot(slot)
	print(slot)
	position_goal = slot.get_position_for_node2d()

#func go_to_slot_index(index: int) -> void:
