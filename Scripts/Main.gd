extends Node


@onready var menu := get_node("Menu")
@onready var atual : Node = menu.get_child(0)

func _ready() -> void:
	#print("create")
	#create_new_baralhos()
	menu.get_child(0).switch.connect(_on_switch)

func partidaTESTE() -> void:

	G.baralhoAT = G.baralhoCache[2]
	G.baralhoAtual = G.decks + G.baralhoAT.nome

func _on_switch(new:int, data: Dictionary = {"baralhoAT": null, "albumAT": null}) -> int:
	partidaTESTE()
	atual.queue_free()
	atual = load("res://Scenes/pages/NEWPartida.tscn").instantiate()
	return 1

	if new == G.M.EXIT:
		savebeforequiting()
		get_tree().quit()
		return 4
	elif new == G.M.JOGAR:
		assert(data.baralhoAT != null, "TRIED CREATING PARTIDA WITHOUT BARALHO.")
		assert(not (data.baralhoAT is BaralhoINFO), "TRIED STARTING A PARTIDA WITH THE OLD BARALHO MODEL.")
		
		# btw to find a type by name use "type_string(type_off())"
		atual.queue_free()
		atual = G.menus[new].instantiate()
		
		print("data = " + str(data.baralhoAT))
		atual.criar_partida(5, 3, data["baralhoAT"], data["albumAT"])

		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0
	elif new == G.M.INICIAL:
		#create_new_baralhos()
		pass
	
	assert(new != G.M.ALBUM, "TRIED TO SWITCH TO ALBUM!!!")
	atual.queue_free()
	#print(G)
	#print(G.menus[new])
	atual = G.menus[new].instantiate()
	menu.add_child(atual)
	menu.get_child(1).switch.connect(_on_switch)
	return 0



func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		savebeforequiting()

func savebeforequiting() -> void:
	for alb in G.albumBuffer:
		saveGam(alb)

func saveGam(alb) -> void:
	print(alb.nome + " foi salvo")
	if alb:
		print(ResourceSaver.save(alb, G.pth + G.info + "ALBUNS/"+ alb.nome + ".tres"))

# func create_new_baralhos() -> void:
# 	print("creating")
# 	var cartaID : = 0
# 	var fldr := DirAccess.open("res://Decks/")
# 	var id = 0
# 	var curCarta = 0
# 	for bar in fldr.get_directories():
# 		print("res://Decks/"+bar)
# 		var fldr2 := DirAccess.open("res://Decks/"+bar)
# 		print(fldr2.get_files())
# 		var barINFO : BaralhoINFO = ResourceLoader.load("res://Decks/"+bar+ "/"+fldr2.get_files()[0]) #deve haver somente uma file.
# 		var _cartas := []
# 		for _carta : Array in barINFO.cartas[0]:
# 			curCarta += 1
# 			_cartas.append(curCarta)
# 		print(_cartas)
# 		var barRES : BarRES = BarRES.new(id, barINFO.nome, barINFO.imagem, barINFO.descrição, _cartas)

# 		ResourceSaver.save(barRES, "res://Resources/Baralhos/" + str(barRES.nome) + ".tres")
# 		id+=1


# func barTransition() -> void:
# 	var _OLDbaralhos : Array
# 	_OLDbaralhos = G.oLDbaralhoCache 

# 	var idBaralho : = 0 
# 	var idCarta := 0
# 	for baralho : BaralhoINFO in _OLDbaralhos:
# 		var bar : BarRES = BarRES.new()
# 		var imagem : ImageTexture = baralho.imagem
# 		ResourceSaver.save(imagem,  "res://Resources/Baralhos_Imagens/" + str(idBaralho) + ".tres")
# 		var _REScartas : = []
# 		var _cartas := []	
# 		for carta : Array in baralho.cartas[0]:
# 			var _carta : CartaRES = CartaRES.new() 
# 			var img : ImageTexture = G.makeResourceFromImage("res://Decks/" + baralho.nome + "/imagens/" + carta[-1])
			
# 			#print("res://Decks/" + baralho.nome + "/imagens/" + carta[-1])

# 			_carta.criar_cartaRES(
# 				idCarta,
# 				carta[0],
# 				carta[2],
# 				carta[1],
# 				img
# 				)
			
# 			#ResourceSaver.save(img, "res://Resources/Cartas_Imagens/" + str(_carta.id) + ".tres")
# 			_REScartas.append( _carta )
			
# 			idCarta+=1
		
# 		#print(_cartas)
# 		for carta in _REScartas:
# 			_cartas.append(carta.id)
# 			#ResourceSaver.save(carta, "res://Resources/Cartas/" + str(carta.id) + ".tres")
		
		
# 		bar.criar_baralhoRES(idBaralho, baralho.nome, imagem, baralho.descrição, _cartas)

# 		ResourceSaver.save(bar, "res://Resources/Baralhos/" + str(idBaralho) + ".tres")
		
# 		idBaralho +=1

		


	# var crianca := BaralhoINFO.new()
	
	# crianca.nome = "Crianças"
	# crianca.imagem = G.makeResourceFromImage("C:/Users/og0ta/Downloads/icone.PNG")
	# crianca.descrição = "Baralho para as crianças."
	# # cartas[0] -> [nome, ano, descrição, tema, nomeDaImagem.extensão]
	# crianca.cartas = [
	# 	[
	# 		["Criação da vacina BCG",  "1909",  "Ano da criação da vacina BCG (contra a Tuberculose).", "i1.png"],
	# 		["Descoberta do primeiro antibiótico",  "1928",  "A descoberta acidental da penicilina, por Alexander Fleming.", "i2.jpg"],
	# 		["Estudos para a purificação da penicilina",  "1938",  "Um grupo de pesquisadores da Universidade de Oxford dedicou-se a purificar a penicilina", "i3.jpg"],
	# 		["Vacina tetraviral entra no PNI",  "2013",  "Ano que a vacina contra sarampo, caxumba, rubeola e catapora entra no PNI.", "i4.jpg"], 
	# 		["Vital produz um soro antiofídico",  "1902",  "Vital produziu o primeiro soro que dava resultado tanto em picadas de cascavel quanto em picadas de jararacas.", "i5.png"],
	# 		["Pentavalente entra no SUS",  "2012",  "Vacina contra difteria, tétano, coqueluche, influenza tipo b e hepatite B chega ao SUS", "i6.png"]
	# 	]
		
	# 	,[1,0,1]]
	# print(crianca)
	# print(ResourceSaver.save(crianca, "C:/Users/og0ta/OneDrive/Área de Trabalho/STH-SEJ-PROTOTIPO_FINAL/Decks/Crianças/Crianças.tres"))
