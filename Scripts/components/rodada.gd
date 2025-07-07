extends Control

class_name Rodada

signal rodadaTerminada(resultado:int)


var nTentativas : int
var rodadaCartas : Array 



var cartaImagens : Dictionary
@onready var game : = $game
@onready var mesa : = $game/Mesa
@onready var mao : = $game/Mao
var comp : Array = []
var resultados : Dictionary
var nTentativasUsadas: int = 0
var nTentativasTEXT : String = "Número de tentativas = "

#func _ready() -> void:
	

func criar_rodada(_nTentativas : int, _rodadaCartas : Array[int]) -> void:
	nTentativas = _nTentativas
	rodadaCartas = _rodadaCartas
	cartaImagens = getCartaImagens(rodadaCartas)
	insertHand(rodadaCartas)
	call_deferred("atualizar_tentativa_counter")
	


func getCartaImagens(_rodadaCartas) -> Dictionary:
	var ret : Dictionary = {}
	#print(_rodadaCartas)
	for id in _rodadaCartas:
		print(id)
		ret[G.baralhoAT.cartas[0][id][-1]] = G.makeResourceFromImage(G.baralhoAtual + "/imagens/" + G.baralhoAT.cartas[0][id][-1])
	#print(ret)
	return ret

func insertHand(_rodadaCartas : Array[int]) -> void:
	mao.inserirCartas(_rodadaCartas)
	

func is_Mesa_Full() -> bool:
	return mesa.get_cards().size() == 5

func resetHand() -> void:
	mao.insertCartas()
	mesa.resetarSlots()

func _on_enviar_linha_do_tempo_pressed() -> void:

	if is_Mesa_Full():
		resultados = is_correct(mesa.get_cards_Ano()) # -> vitória
		if resultados["correto"]:
			checkComp(resultados, comp)	
			comp = rodadaCartas
			feedBack(resultados["errados"])
			rodadaTerminada.emit("vitória")

		elif not(resultados["correto"]) and nTentativasUsadas < nTentativas-1: # -> resultados["errados"] existe. -> Erro
			
			
			checkComp(resultados, comp)
			
			
			for carta in comp:
				if not (carta in G.albumAT.completedCartas):
					G.albumAT.completedCartas.append(carta)
			
			nTentativasUsadas += 1
			atualizar_tentativa_counter()
			$"debug anos".text = "Ordem incorreta, insira novamente."
			feedBack(resultados["errados"], false)

		else: # -> derrota 
			checkComp(resultados, comp)
			feedBack(resultados["errados"])
			nTentativasUsadas += 1
			atualizar_tentativa_counter()
			rodadaTerminada.emit("derrota")

	else:
		$"debug anos".text = "Insira todas as cartas e aperte o botão novamente"

func feedBack(errados: Array, mostrarAno : bool = true) -> void:
	var certos := [0, 1, 2, 3, 4]
	var anos : Array = []
	var ncertos : Array = [] # array das nodes certas, utilizado para travar as cartas certas

	for _slot  in errados: # encontra o local na mesa das cartas certas
		certos.remove_at(certos.find(_slot))

	for _carta in range((errados+certos).size()): # encontra os anos de todas as cartas
		anos.append(int(mesa.get_card(_carta)[1]))
		if _carta in certos: # adquire as nodes das cartas certas
			ncertos.append(mesa.get_card(_carta)[0])
	
	for _node in ncertos: # remove a capacidade das cartas certas serem movidas
		_node.draggable = false
		_node.can_inspect = false

	var anosErr = anos.duplicate()
	anos.sort()
	var g = get_node("game").get_child(0).get_children()
	var cartas = get_node("game").get_node("Mesa").get_children()
	for id in errados:	
		g[id].err(anosErr[id], mostrarAno)

		
	for id in certos:
		g[id].crt(anos[id])
		cartas[id].draggable = false
		cartas[id].is_complete = true

func checkComp(_resultados: Dictionary, _comp :Array) -> void:
	if _resultados["correto"]:
		_comp += rodadaCartas
	else:
		var certos = [0, 1, 2, 3, 4]
		for _slot in _resultados["errados"]:
			certos.remove_at(certos.find(_slot))
		
		var _mesa = get_node("game").get_child(1).get_children()
		for _carta in certos:
			_comp.append(_mesa[_carta].cardId)
		

func checarCartasCompletas(r : Array) -> void: # inutilizado atualmente, em vez desse utilize checkComp 
	# cardID das cartas que foram completas
	var anSrt := []
	var crdSrt := []
	var mes : Array[Node] = mesa.get_cards()
	for display in mes:
		crdSrt.append(display.cardId) #id da carta no bara
		anSrt.append(display.anoShow) # ano da carta
	if anSrt[0] <= anSrt[1] and not (crdSrt[0] in r):
		r.append(crdSrt[0])
	if anSrt[-1] >= anSrt[-2] and not (crdSrt[-1] in r):
		r.append(crdSrt[-1])
	for i in range(1, mes.size()-1):
		if anSrt[i-1] <= anSrt[i] and anSrt[i] <= anSrt[i+1] and not (crdSrt[i] in r): 
			r.append(crdSrt[i])


	
	




func atualizar_tentativa_counter():
	$Ntentativas.text = nTentativasTEXT + str(nTentativas -  nTentativasUsadas) + "/" + str(nTentativas) 

func is_correct(anos : Array) -> Dictionary:
	var certo: Array = anos.duplicate()
	certo.sort()
	var i = 0
	var ret : Dictionary = {}
	ret["correto"] = true
	ret["errados"] = []
	for ano in anos:
		if not(certo[i] == ano):
			ret["errados"].append(i)
			ret["correto"] = false		
		i+=1
	return ret
