extends Node


@onready var menu = get_node("Menu")
@onready var atual = menu.get_child(0)

func _ready() -> void:
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

	menu.get_child(0).switch.connect(_on_switch)

func _on_switch(new:int, data: Dictionary = {"baralhoAT": null, "albumAT": null}) -> int:
	if new == G.M.EXIT:
		savebeforequiting()
		get_tree().quit()
		return 4
	elif new == G.M.JOGAR:
		atual.queue_free()
		atual = G.menus[new].instantiate()

		atual.criar_partida(5, 3, data["baralhoAT"], data["albumAT"])

		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0

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
