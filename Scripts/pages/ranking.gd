extends Control

signal switch(new : int)

var p = load("res://Scenes/components/performance.tscn")

func _ready() -> void:
	$Label.text = "Exibindo performances salvas para: " + G.baralhoAT.nome
	if G.albumAT.performances.size() > 0:
		populateScroll()
	else:
		$Label.text += " --> NÃO HÁ PERFORMANCES ANTERIORES PARA ESSE BARALHO"

func populateScroll() -> void:
	var performances = G.albumAT.performances.duplicate()
	performances.reverse()
	var i = 1
	for performance in performances:
		var _p = p.instantiate()
		_p.get_node("Label").text = str(i) + ". " + str(performance) + " pontos."
		$ScrollContainer/GridContainer.add_child(_p)
		i += 1

func _on_voltar_pressed() -> void:
	switch.emit(G.M.SELECT)


func _on_reset_rank_pressed() -> void:
	G.albumAT.performances = []
	_on_voltar_pressed()
	
