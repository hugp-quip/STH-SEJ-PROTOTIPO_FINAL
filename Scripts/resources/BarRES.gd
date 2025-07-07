extends Resource

class_name BarRES

@export var nome : String 
@export var imagem : CompressedTexture2D
@export var descrição : String
@export var cartas : Array[String] 

func _init() -> void:
	self.nome = "Sem nome."
	self.descrição = "Descrição não inserida."

func criar_baralhoRES(n: String, i: CompressedTexture2D, d : String, _cartas: Array[String]) -> void:
	self.nome = n
	self.imagem = i
	self.descrição = d
	self.cartas = _cartas