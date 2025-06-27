extends Control


# Called when the node enters the scene tree for the first time.
func sset() -> void:
	$EditBaralho/NewNome.text = get_parent().bNome
	$EditBaralho/NewDesc.text = get_parent().bDescrição
	$imagem.texture_normal = get_parent().bIcone

func gget() -> void:
	get_parent().bNome = $EditBaralho/NewNome.text 
	get_parent().bDescrição = $EditBaralho/NewDesc.text
	get_parent().bIcone = $imagem.texture_normal 
