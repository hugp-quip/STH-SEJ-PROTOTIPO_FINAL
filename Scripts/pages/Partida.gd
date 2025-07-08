extends Control

class_name Partida

var nTentativas : int
var nRodadas : int
var rodadaAtualText : String = "Rodada Atual = " 
var baralho: Baralho 
var baralhoAT: BarRES
var albumAT: AlbumRes


var Pontuação : int = 0
var rodada : Rodada 

@onready var nRodadasOG : int = nRodadas
var alb : PackedScene = load("res://Scenes/pages/album.tscn")
var albInstance : Node

signal switch(new : int)

#func _ready() -> void:


func criar_partida(_nTentativas: int, _nRodadas: int, _baralhoAT: BarRES, _albumAT: AlbumRes ) -> void:
	nRodadas = _nRodadas
	nTentativas = _nTentativas
	baralhoAT = _baralhoAT
	albumAT = _albumAT

	baralho = Baralho.new()
	baralho.criar_baralho(_baralhoAT.cartas)
	nRodadas = clamp(len(baralhoAT.cartas)/5.0, 1, 5)
	assert( nRodadas > 0, "TRIED CREATING PARTIDA WITH TOO FEW RODADAS!!!")
	set_deferred("nRodadasOG", nRodadas)
	call_deferred("atualizar_rodada_counter")
	call_deferred("atualizarPontuação")
	call_deferred("partida_criar_rodada")


# Sinais
func _on_resetar_partida_pressed() -> void:
	switch.emit(G.M.JOGAR,  {"baralhoAT": baralhoAT, "albumAT": albumAT}) # recarrega o album e pontuação sem salvar

func _on_voltar_para_o_menu_principal_pressed() -> void:
	switch.emit(G.M.INICIAL)

func _on_pause_pressed() -> void:
	var menu_pausa : Control = get_node("MenuPausa")
	menu_pausa.visible = not(menu_pausa.visible)
	silenceCartas(not(menu_pausa.visible))

# @param {"true"| "bata" | "adgfs"} silenciar
func silenceCartas(silenciar : bool) -> void:
	var rodGame : Node = get_child(-1).get_child(0)
	# não tente mudar para Array[CardDisplay]
	var arr : Array[CardDisplay] 
	for cardDisplay in (rodGame.get_node("Mesa").get_children() + rodGame.get_node("Mao").get_children()):
		arr.append(cardDisplay as CardDisplay)

	for _card in arr:
		#print(not(_card.is_slot) and not(_card.is_complete))
		if not(_card.is_slot) and not(_card.is_complete):
			_card.draggable = silenciar
			_card.can_inspect = silenciar

func on_rodadaTerminada(resultado : String) -> void:

	atualizarPontuação(rodada.nTentativasUsadas)
	if resultado == "derrota": 
		if Pontuação not in G.albumAT.performances:
			G.albumAT.performances.append(Pontuação)	
		G.albumAT.completedCartas += rodada.comp
		#saveGam()
		mostrar_MenuFimPartida("Você perdeu!!!")

	elif resultado == "vitória" and nRodadas > 1:
		rodada.get_node("Enviar Linha do Tempo").text = "Próxima Rodada"
		rodada.get_node("Enviar Linha do Tempo").disconnect("pressed", rodada._on_enviar_linha_do_tempo_pressed)
		rodada.get_node("Enviar Linha do Tempo").pressed.connect(_on_próxima_rodada_pressed)
		nRodadas -= 1
		for carta : int in rodada.comp:
			if not (carta in G.albumAT.completedCartas):
				G.albumAT.completedCartas.append(carta)
		atualizar_rodada_counter()

	elif resultado == "vitória":
		if Pontuação not in G.albumAT.performances:
			G.albumAT.performances.append(Pontuação)
		G.albumAT.completedCartas += get_child(-1).comp
		#saveGam()
		mostrar_MenuFimPartida("Você ganhou!!!")

func partida_criar_rodada() -> void:
	$nRodadaAtual.visible = true
	rodada = Res.rodada.instantiate()
	add_child(rodada)

	rodada.criar_rodada(nTentativas, baralho.getMao(5))
	
	rodada.rodadaTerminada.connect(on_rodadaTerminada)
	
func _on_próxima_rodada_pressed() -> void:
	baralho.useCartas(rodada.rodadaCartas)
	rodada.queue_free() if rodada else func() : print("irmão n tem rodada sla qq aconteceu")
	partida_criar_rodada()	
	



func mostrar_MenuFimPartida(resultado: String) -> void:
	#print("FUNÇÃO RODADA")
	silenceCartas(false)
	var pontuaçãoFinal = "Pontuação Final = " + str(Pontuação)
	var ma = get_maiorPontuação()
	if Pontuação >= ma:
		$"MenuFimPartida/VContainer/MelhorPontuação".text = "Nova maior pontuação!!!"
	else:
		$"MenuFimPartida/VContainer/MelhorPontuação".text = "Maior pontuação: " + str(ma) + " pontos."
	$"MenuFimPartida/VContainer/PontuaçãoFinal".text = str(pontuaçãoFinal)
	$MenuFimPartida/Resultado.text = resultado
	$"MenuFimPartida/VContainer/Resetar Partida".disabled = false
	$"MenuFimPartida/VContainer/Voltar para o Menu Principal".disabled = false
	$MenuFimPartida.show()



func get_maiorPontuação() -> int:
	return G.albumAT.performances[-1]
	
func atualizarPontuação(tentat:int = 5) -> void:
	Pontuação = get_node("Pontuação").text.to_int() + (5 - tentat)*200
	var p := get_node("Pontuação")
	p.text = "Pontuação = " + str(Pontuação)
	
func atualizar_rodada_counter() -> void:
	$nRodadaAtual.text = rodadaAtualText + str(nRodadasOG - nRodadas + 1) + "/" + str(nRodadasOG)

func _on_see_alb_pressed() -> void:
	albInstance = alb.instantiate()
	var b := albInstance.get_node("Voltar") 
	
	albInstance.get_node("resetAlb").queue_free()
	b.pressed.disconnect(albInstance._on_voltar_pressed)
	b.pressed.connect(leave_alb)
	get_parent().add_child(albInstance)
	visible = false
	
func leave_alb() -> void:
	albInstance.queue_free()# remove_child(alb)
	visible = true



class Baralho:
	var nCartas : int
	var cartasUsadas : Array[int]
	var rng : RandomNumberGenerator = RandomNumberGenerator.new() 

	func criar_baralho(_cartas: Array) -> void:
		nCartas = _cartas.size()

	func useCarta(id: int) -> void:
		cartasUsadas.append(id)

	func useCartas(ids: Array) -> void:
		for id : int in ids:
			useCarta(id)
			
	func getMao(n : int) -> Array[int]:
		var i := 0
		assert(not(n > nCartas), " ERROR, TOO MANY CARDS")
		var ret : Array[int]= []
		var sb : Array[int] = cartasUsadas.duplicate()
		var i2 := 0
		var rand: int 
		while i < n:
			assert(not(i2 > nCartas ), " ERROR, INFINITE LOOP ON Partida.baralho.getMao()")
			rand = rng.randi_range(0, nCartas-1)
			if not(rand in sb):
				ret.append(rand)
				sb.append(rand)
				i+=1
			i2+=1
		return ret
		
