extends Control

var baralho: Baralho 
var nTentativas : int
var Pontuação : int = 0
#var tags : Array
var nRodadas : int
@onready var nRodadasOG : int = nRodadas
var rodadaAtualText : String = "Rodada Atual = " 
var rodada : Rodada 
var alb : = load("res://Scenes/pages/album.tscn")

signal switch(new : int)

func _ready() -> void:
	baralho = Baralho.new()
	baralho.innit(G.barINFO.cartas[0])
	nRodadas = clamp(len(G.barINFO.cartas[0])/5.0, 1, 5)
	assert( nRodadas > 0, "TRIED CREATING PARTIDA WITH TOO FEW RODADAS!!!")
	set_deferred("nRodadasOG", nRodadas)
	#print("kk", nRodadas)
	call_deferred("atualizar_rodada_counter")
	call_deferred("atualizarPontuação")
	call_deferred("criarRodada")
	

# Sinais
func _on_resetar_partida_pressed():
	switch.emit(G.M.JOGAR) # recarrega o album e pontuação sem salvar

func _on_voltar_para_o_menu_principal_pressed():
	switch.emit(G.M.INICIAL)

func _on_pause_pressed():
	get_node("MenuPausa").visible = not(get_node("MenuPausa").visible)
	silenceCartas(not(get_node("MenuPausa").visible))

func silenceCartas(silenciar : bool) -> void:
	var rodGame : Node = get_child(-1).get_child(0)
	var arr : Array[Node] = rodGame.get_node("Mesa").get_children() + rodGame.get_node("Mao").get_children()
	for _card in arr:
		#print(not(_card.is_slot) and not(_card.is_complete))
		if not(_card.is_slot) and not(_card.is_complete):
			_card.draggable = silenciar
			_card.can_inspect = silenciar

func on_rodadaTerminada(resultado) -> void:
	#rodada.get_node("Enviar Linha do Tempo").disabled = true

	atualizarPontuação(get_child(-1).nTentativasUsadas)
	if resultado == "derrota": 
		if Pontuação not in G.albumAt.performances:
			G.albumAt.performances.append(Pontuação)	
		G.albumAt.completedCartas += get_child(-1).comp
		#saveGam()
		mostrar_MenuFimPartida("Você perdeu!!!")

	elif resultado == "vitória" and nRodadas > 1:
		rodada.get_node("Enviar Linha do Tempo").text = "Próxima Rodada"
		rodada.get_node("Enviar Linha do Tempo").disconnect("pressed", rodada._on_enviar_linha_do_tempo_pressed)
		rodada.get_node("Enviar Linha do Tempo").pressed.connect(_on_próxima_rodada_pressed)
		nRodadas -= 1
		for carta in rodada.comp:
			if not (carta in G.albumAt.completedCartas):
				G.albumAt.completedCartas.append(carta)
		atualizar_rodada_counter()

	elif resultado == "vitória":
		if Pontuação not in G.albumAt.performances:
			G.albumAt.performances.append(Pontuação)
		G.albumAt.completedCartas += get_child(-1).comp
		#saveGam()
		mostrar_MenuFimPartida("Você ganhou!!!")

func criarRodada() -> void:
	#print(1)
	$nRodadaAtual.visible = true
	rodada = Res.rodada.instantiate()
	add_child(rodada)
	var ar := baralho.getMao(5)

	rodada.rodadaHand = ar[0]
	rodada.rodadaHandIds = ar[1]
	rodada.nTentativas = nTentativas
	rodada.rodadaTerminada.connect(on_rodadaTerminada)
	rodada.cartaImagens = rodada.getCartaImagens(rodada.rodadaHand).duplicate(true)
	rodada.insertHand()

func _on_próxima_rodada_pressed() -> void:
	baralho.useCartas(rodada.rodadaHandIds)
	get_node("Rodada").queue_free() if get_node("Rodada") else print()
	criarRodada()	
	



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
	return G.albumAt.performances[-1]
	
func atualizarPontuação(tentat:int = 5) -> void:
	Pontuação = get_node("Pontuação").text.to_int() + (5 - tentat)*200
	var p = get_node("Pontuação")
	p.text = "Pontuação = " + str(Pontuação)
	
func atualizar_rodada_counter():
	$nRodadaAtual.text = rodadaAtualText + str(nRodadasOG - nRodadas + 1) + "/" + str(nRodadasOG)

func _on_see_alb_pressed() -> void:
	var _alb = alb.instantiate()
	var b = _alb.get_node("Voltar") 
	_alb.get_node("resetAlb").queue_free()
	b.pressed.disconnect(_alb._on_voltar_pressed)
	b.pressed.connect(leave_alb)
	get_parent().add_child(_alb)
	visible = false
	
func leave_alb() -> void:
	get_parent().get_child(-1).queue_free()# remove_child(alb)
	visible = true



class Baralho:
	var dicCartas : Array
	var cartasUsadas : Array
	var rng : RandomNumberGenerator = RandomNumberGenerator.new() 

	func innit(cartas: Array):
		dicCartas = cartas.duplicate(true)

	func getCarta(id: int) -> Array:
		return dicCartas[id] 

	func useCarta(id: int) -> void:
		cartasUsadas.append(id)

	func useCartas(ids: Array) -> void:
		for id in ids:
			useCarta(id)
			
	func getMao(nCartas : int) -> Array:
		var i = 0
		#print(nCartas)
		assert(not(nCartas > dicCartas.size()), " ERROR, TOO MANY CARDS")
		var ret = []
		var sb = cartasUsadas.duplicate()
		var i2 = 0
		var n: int 
		while i < nCartas:
			assert(not(i2 > dicCartas.size()+10 ), " ERROR, INFINITE LOOP ON Partida.baralho.getMao()")
			n = rng.randi_range(0, dicCartas.size()-1)
			if not(n in sb):
				ret.append(n)
				sb.append(n)
				i+=1
			i2+=1
		return [ret, sb]
		
