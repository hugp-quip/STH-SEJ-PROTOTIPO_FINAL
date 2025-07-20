@tool
class_name RodadaCont extends Node2D

var current_rodada : Rodada = null


func _ready() -> void:
	if Engine.is_editor_hint():
		var part : PartidaRES = PartidaRES.new()
		part.n_cartas = 5
		criar_rodada(part, [])


func criar_rodada(partidaState : PartidaRES, cartas : Array)-> void:
	if get_child_count() > 0:
		get_child(0).queue_free()
	
	var rodada_config = RodadaRES.new()
	rodada_config.n_cartas = partidaState.n_cartas
	rodada_config.cards = cartas

	var rodada = load("res://Scenes/pages/NewRodada.tscn").instantiate()
	rodada.criar_rodada(rodada_config)
	current_rodada = rodada
	add_child(rodada)

func _on_envio_pressed() -> void:
	current_rodada._on_envio_pressed()