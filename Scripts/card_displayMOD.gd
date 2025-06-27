extends TextureRect



var draggable : = true# mudar padrão dps
var is_slot
var dados_carta 
@export var cardId : int
var anoShow
var anoNum
var descDICA


func atualizar() -> void:
	is_slot = false
	dados_carta = G.barINFO.cartas[0][cardId]
	expand_mode = EXPAND_IGNORE_SIZE
	texture = load("res://Assets/carta.png")
	#print(G.baralhoAtual + dados_carta[-1])
	$imagem.texture = G.makeResourceFromImage(G.baralhoAtual + "/imagens/" + dados_carta[-1])
	$Nome_da_carta.text = dados_carta[0]
	anoShow = dados_carta[1]
	$"Descrição_do_acontecimento".text = dados_carta[2]
	descDICA = dados_carta[3]
	$imagem.visible = true
	$Nome_da_carta.visible = true
	$Descrição_do_acontecimento.visible = true

