extends Node

class_name BaralhoHandler

var cartas : Array # -> list containing the ids of all the cards.
var used_cartas : Array # -> list containing the id of used cards.
var n_cartas_partida : int
#@onready var random : RandomNumberGenerator = RandomNumberGenerator.new()

func comecar(_baralhoAT: BarRES, n_rodadas: int, n_cartas: int) -> void:
	#assert(_baralhoAT.cartas.size()/n_cartas >= n_rodadas, "BARALHO MUITO PEQUENO PARA O NÚMERO DE RODADAS REQUISITADO!!!")
	n_cartas_partida = n_cartas
	cartas = _baralhoAT.cartas.duplicate()
	used_cartas = []

func criar_hand_para_partida() -> Array:
	var cartas_restantes : int = cartas.size() -  used_cartas.size() 
	#assert(cartas_restantes > 1, "TENTOU CRIAR MÃO COM CARTAS INSUFICIENTES!!!")
	var _cartaIDS := _get_hand(clamp(cartas_restantes, 2, n_cartas_partida) as int)
	var cartasRES : Array = []
	#print(_cartaIDS)
	var m := Time.get_ticks_msec()
	for id : int in _cartaIDS:
		var res := ResourceLoader.load("res://Resources/Cartas/" + str(id)+".res")#Res.pathCartas.path_join(str(id)+".res"))
		#var res = CartaRES.new()
		cartasRES.append(res)
	print((Time.get_ticks_msec() - m)/1000)
	return cartasRES



func _get_hand(n_cartas : int) -> Array:
	#assert(n_cartas > 0 and n_cartas < cartas.size() - used_cartas.size(), "NÚMERO DE CARTAS REQUISITADO MAIOR DO QUE O TAMANHO RESTANTE DO BARALHO .")
	var cartasID : Array = []
	while cartasID.size() < n_cartas:
		var r : int = G.rand.randi_range(0, cartas.size()-1) 
		if not (cartas[r] in used_cartas):
			cartasID.append(cartas[r])
			used_cartas.append(cartas[r])
	return cartasID	
