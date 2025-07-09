extends Control

@onready var rodadaCont : RodadaContainer = get_node("RodadaContainer")
@onready var uiHandler : PartidaUIHandler = get_node("partida_UI_Handler")
@onready var baralhoHandler : BaralhoHandler = get_node("BaralhoHandler")

var state : PartidaRES

func criar_partida(_partida: PartidaRES) -> void:
	state = _partida
	updateUI(state)

	baralhoHandler.comecar(_partida.baralhoINFO, _partida.n_rodadas)
	
	rodadaCont.criar_rodada(baralhoHandler.criar_hand_para_partida())

func updateUI(_state : PartidaRES) -> void:
	uiHandler.update(_state)