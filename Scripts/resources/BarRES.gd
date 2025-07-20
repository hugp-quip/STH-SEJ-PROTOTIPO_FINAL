extends Resource

class_name BarRES

@export var id : int
@export var nome : String 
@export var imagem : ImageTexture
@export var descricao : String
@export var cartas : Array 

func criar_BarRES(_id: int, _nome: String, _imagem: ImageTexture, _descricao : String, _cartas: Array) -> void:
	#assert(_cartas.size() >= 5, "UM BARALHO DEVE TER AO MENOS 5 CARTAS!!!!")
	id = _id
	nome = _nome
	imagem = _imagem
	descricao = _descricao
	cartas = _cartas


