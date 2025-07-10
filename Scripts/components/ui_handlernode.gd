extends Node

@onready var imagem : Sprite2D = get_node("Imagem")
@onready var legenda : Label = get_node("Legenda")




func update(_data : CartaRES) -> void:
	imagem.texture = _data.imagem
	legenda.text = _data.legenda