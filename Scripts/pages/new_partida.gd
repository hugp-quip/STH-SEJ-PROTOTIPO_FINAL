extends Control

signal switch(new:int, data : Dictionary)

var rodadaCont : RodadaCont 
var uiHandler : PartidaUIHandler 
var baralhoHandler : BaralhoHandler 

var state : PartidaRES

#func _ready() -> void:
	

func criar_partida(_partida: PartidaRES) -> void:
	state = _partida

func _enter_tree() -> void:
	# if get_node("Icon") == null:
	# 	criar_partida.call_deferred(state)
	# 	return
	# print(get_node("RodadaCont"))
	rodadaCont = get_node("RodadaCont")
	uiHandler = get_node("partida_UI_Handler")
	baralhoHandler  = get_node("BaralhoHandler")
	updateUI(state)

	baralhoHandler.comecar(state.baralhoINFO, state.n_rodadas, state.n_cartas)
	rodadaCont.criar_rodada(state, baralhoHandler.criar_hand_para_partida())
	get_node("Icon").texture = state.baralhoINFO.imagem

func updateUI(_state : PartidaRES) -> void:
	uiHandler.update(_state)
