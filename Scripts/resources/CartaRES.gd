extends Resource

class_name  CartaRES

@export var id : int
@export var legenda := "Sem legenda."
@export var descricao := "Sem descrição."
@export var ano := "Sem ano"
@export var dica := "Sem dica"
@export var imagem := ImageTexture.new() #Res.cardBackground

#adicionar a dica depois
func criar_cartaRES( _id: int, _legenda : String, _descricao: String, _ano: String, _imagem : ImageTexture) -> void:
	id = _id
	legenda = _legenda
	ano = _ano
	descricao = _descricao
	#print(_imagem)
	imagem = _imagem

