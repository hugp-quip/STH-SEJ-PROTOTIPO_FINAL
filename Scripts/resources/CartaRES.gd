extends Resource

class_name  CartaRES

@export var legenda := "Sem legenda."
@export var descricao := "Sem descrição."
@export var ano := "Sem ano"
@export var imagem : = Res.cardBackground

func criar_cartaRES(_legenda : String, _descricao: String, _ano: String, _imagem : CompressedTexture2D) -> void:
	legenda = _legenda
	ano = _ano
	descricao = _descricao
	imagem = _imagem

