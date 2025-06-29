extends Node2D

class_name CartaInspect

func atualizar(data) -> void:
	$CardDisplay.cardId = data
	$CardDisplay/Carta.queue_free()
	$CardDisplay.atualizar()
	$CardDisplay.mouse_filter = 2
	# $CardDisplay.disconnect("mouse_entered", $CardDisplay.on_mouse_entered)
	# $CardDisplay.disconnect("mouse_exited", $CardDisplay.on_mouse_entered)

