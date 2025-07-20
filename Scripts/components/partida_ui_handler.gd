extends Node

class_name PartidaUIHandler

func update(_partida: PartidaRES) -> void:
	pass

func _on_envio_pressed() -> void:
	get_parent().rodadaCont._on_envio_pressed()
