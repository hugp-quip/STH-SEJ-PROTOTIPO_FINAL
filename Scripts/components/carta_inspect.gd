extends Node2D

class_name CartaInspect

func atualizar(data) -> void:
	$CardDisplay.cardId = data
	$CardDisplay/Carta.queue_free()
	$CardDisplay.atualizar()
	$CardDisplay.mouse_filter = 2
	$CardDisplay.get_node("Descrição_do_acontecimento").size = Vector2(0, 0)
	$CardDisplay.is_slot = true
	$CardDisplay.is_mouse = true
	# $CardDisplay.disconnect("mouse_entered", $CardDisplay.on_mouse_entered)
	# $CardDisplay.disconnect("mouse_exited", $CardDisplay.on_mouse_entered)

