extends TextureRect

class_name CardSlot

@onready var cardspot = get_child(0)
@onready var carta : TextureRect = cardspot.get_child(0)

func criarCarta(data):
	carta.visible = true
	carta.atualizar(data)



