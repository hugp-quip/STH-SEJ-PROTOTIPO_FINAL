extends Node2D


var offset  
var over_area : = false
var recent_area
signal cartaNãoColocadaEmSlot
signal cartaColocadaEmSlot(slot)

func _physics_process(_delta):
	global_position = get_global_mouse_position() - offset
	if Input.is_action_just_released("click"):
		recent_area = $Area2D.get_overlapping_areas()
		if recent_area.size() > 0:
			var node = recent_area[-1].get_parent()
			if node is CardDisplay and node.is_slot:
				cartaColocadaEmSlot.emit(node)
			else:  
				cartaNãoColocadaEmSlot.emit()
		else:
			cartaNãoColocadaEmSlot.emit()
		queue_free()

func atualizar(data) -> void:
	$CardDisplay.cardId = data
	$CardDisplay.atualizar()
