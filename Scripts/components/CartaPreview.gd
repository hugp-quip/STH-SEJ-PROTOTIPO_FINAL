extends Node2D

class_name CartaPreview

var offset  
var over_area : = false
signal cartaNãoColocadaEmSlot
signal cartaColocadaEmSlot(slot)
signal cartaColocadaEmCarta(carta)

func _ready() -> void:
	get_node("CardDisplay").get_node("Carta").queue_free()
	get_node("CardDisplay").get_node("Descrição_do_acontecimento").size = Vector2(0, 0)

func _physics_process(_delta):
	global_position = get_global_mouse_position() - offset
	if Input.is_action_just_released("click"):
	
		var recent_area : Array[Area2D] = $Area2D.get_overlapping_areas()
		if recent_area.size() <= 0:
			cartaNãoColocadaEmSlot.emit()

		var card_with_mouse : CardDisplay = findNodeWithMouse(recent_area)

		if card_with_mouse is CardDisplay and card_with_mouse != null:
			if card_with_mouse.is_slot:
			
				cartaColocadaEmSlot.emit(card_with_mouse)

			elif card_with_mouse.draggable:
			
				cartaColocadaEmCarta.emit(card_with_mouse)
			else:
				cartaNãoColocadaEmSlot.emit()

		else: 
			
				cartaNãoColocadaEmSlot.emit()

		queue_free()

func findNodeWithMouse(recent_area : Array[Area2D]) -> CardDisplay:

	for area  in recent_area:
		var cardDiplay : CardDisplay = area.get_parent()
		if cardDiplay != null and cardDiplay.is_mouse:
			return cardDiplay
	return null

func atualizar(data : int) -> void:
	$CardDisplay.cardId = data
	$CardDisplay.atualizar()
