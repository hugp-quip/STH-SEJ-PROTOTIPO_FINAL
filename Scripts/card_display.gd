extends TextureRect

class_name CardDisplay

var is_mouse : = false
var preview : = load("res://Scenes/carta_preview.tscn")
var inspect : = load("res://Scenes/carta_inspect.tscn")
@export var draggable : = true# mudar padrão dps
@export var is_slot : = true
@export var can_inspect : = true
var _inspect
@export var cardId : int
var dados_carta : Array
var anoShow
var anoNum
var descDICA
#
#ALERTA: QUANDO MODIFICANDO AS SUBCLASSES PREVIEW E INSPECT, LEMBRE-SE DE CHECAR SE O CARDISPLAY DE PREVIEW É MOUSE STOP
# E O DE INSPECT É MOUSE PASS.(isso garante com que você não inspecione quando movendo carta e consiga inspecionar)
#

func atualizar() -> void:
	is_slot = false
	expand_mode = EXPAND_IGNORE_SIZE
	texture = load("res://Assets/carta.png")
	dados_carta = G.barINFO.cartas[0][cardId]
	$imagem.texture = G.makeResourceFromImage(G.baralhoAtual + "/imagens/" + dados_carta[-1])
	$Nome_da_carta.text = dados_carta[0]
	anoShow = dados_carta[1]
	$"Descrição_do_acontecimento".text = dados_carta[2]
	descDICA = dados_carta[3]
	$imagem.visible = true
	$Ano.visible = false
	$Ano.text = anoShow
	$Nome_da_carta.visible = true
	$Descrição_do_acontecimento.visible = true


func getData() -> int:
	assert(is_slot, "ERROR TRIED TO GET DATA ON A SLOT")
	return cardId

func makeSlot():
	is_slot = true
	texture = load("res://Assets/slot.PNG")
	expand_mode = EXPAND_IGNORE_SIZE
	$imagem.visible = false
	$Nome_da_carta.visible = false
	$Ano.visible = false
	$Descrição_do_acontecimento.visible = false


func _physics_process(_delta):
	if not is_slot:
		if is_mouse and draggable:
			if Input.is_action_just_pressed("click"):
				var pReview
				pReview = preview.instantiate()
				pReview.offset = get_local_mouse_position()
				pReview.position = global_position
				get_node("/root").add_child(pReview)
				pReview.atualizar(cardId)
				pReview.cartaNãoColocadaEmSlot.connect(on_cartaNãoColocadaEmSlot)
				pReview.cartaColocadaEmSlot.connect(on_cartaColocadaEmSlot)
				makeSlot()
		if is_mouse and can_inspect and not(is_slot):
			_inspect = inspect.instantiate()
			get_node("/root").add_child(_inspect)
			_inspect.position = global_position + Vector2(-20, -30)
			_inspect.atualizar(cardId)
			can_inspect = false
	if not(is_mouse) and str(_inspect) != "<Freed Object>" and str(_inspect) != "<null>":
		_inspect.queue_free()
		can_inspect = true

func on_cartaNãoColocadaEmSlot():
	atualizar()

func on_cartaColocadaEmSlot(node):
	if node.is_slot == true: 
		node.cardId = cardId 
		node.atualizar()
		node.is_slot = false
		#print(node, node.is_slot)

func _on_carta_mouse_entered() -> void:
	#print("mou")
	is_mouse = true


func _on_carta_mouse_exited() -> void:
	#print("se")
	is_mouse = false
