extends TextureButton

class_name CardDisplaybutton

var is_mouse : = false
var preview : = load("res://Scenes/components/carta_preview.tscn")
var inspect : = load("res://Scenes/components/carta_inspect.tscn")
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
func _ready() -> void:
	call_deferred("atualizar")

func atualizar() -> void:
	is_slot = false
	dados_carta = G.oLDbaralhoAT.cartas[0][cardId]
	texture_normal = load("res://Assets/carta.png")
	$imagem.texture = G.makeResourceFromImage(G.baralhoAtual + "/imagens/" + dados_carta[-1])
	$Nome_da_carta.text = dados_carta[0]
	anoShow = dados_carta[1]
	$Ano.text = anoShow
	$"Descrição_do_acontecimento".text = dados_carta[2]
	descDICA = dados_carta[3]

func getData() -> int:
	assert(is_slot, "ERROR TRIED TO GET DATA ON A SLOT")
	return cardId

func makeSlot():
	is_slot = true
	texture_normal = load("res://Assets/slot.PNG")
	$imagem.visible = false
	$Nome_da_carta.visible = false
	$Ano.visible = false
	$Descrição_do_acontecimento.visible = false
	$Tags.visible = false
