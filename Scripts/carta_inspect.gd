extends Node2D

func atualizar(data) -> void:
	$CardDisplay.cardId = data
	$CardDisplay/Carta.queue_free()
	$CardDisplay.atualizar()
