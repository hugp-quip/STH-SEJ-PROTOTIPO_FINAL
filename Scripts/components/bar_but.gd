extends Button

var data 

func _ready() -> void:
	call_deferred("insert")

func insert() -> void :
	$TextureRect.texture = data.imagem
	$BaralhoINFO.text = data.nome
