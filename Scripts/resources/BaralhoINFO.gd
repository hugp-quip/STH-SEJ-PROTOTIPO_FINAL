extends Resource

class_name BaralhoINFO

@export var nome : String
@export var imagem : ImageTexture
@export var descrição : String
@export var cartas : Array 


func _init() -> void:
	self.nome = "Crianças"
	self.imagem = ImageTexture.new()
	self.descrição = "Baralho para as crianças."
	self.cartas = [[[],[],[],[],[]],[1,0,1]]

# cartas array[2]:
# [0] -> as cartas
# [1] -> fds

# cartas[0] -> [nome, ano, descrição, tema, nomeDaImagem.extensão]