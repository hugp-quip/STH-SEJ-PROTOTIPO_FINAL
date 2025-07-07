extends Resource

class_name BarRES

@export var id : int
@export var nome : String 
@export var imagem : ImageTexture
@export var descrição : String
@export var cartas : Array 

func _init() -> void:
	self.nome = "Sem nome."
	self.descrição = "Descrição não inserida."

func criar_baralhoRES(_id: int, n: String, i: ImageTexture, d : String, _cartas: Array) -> void:
	self.id = _id
	self.nome = n
	self.imagem = i
	self.descrição = d
	self.cartas = _cartas