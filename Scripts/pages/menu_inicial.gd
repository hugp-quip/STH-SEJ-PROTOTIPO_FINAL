extends Control

signal switch(new : int)

func _ready() -> void:
	call_deferred("_mudarBaralhoPath", "Baralho atual = " + (G.baralhoAtual if G.baralhoAtual else G.oLDbaralhoCache[1].nome))

func _mudarBaralhoPath(new:String) -> void: # -> SelectBar
	var b = get_node("buttons")
	b.get_node("Baralho_atual").text = new


func _on_sair_do_jogo_pressed() -> void:
	switch.emit(G.M.EXIT)

func _on_rankind_local_pressed() -> void:
	switch.emit(G.M.RANKING)

func _on_jogar_pressed() -> void:
	switch.emit(G.M.SELECT)


func _on_criar_baralho_pressed() -> void:
	#switch.emit(G.M.CDB)
	pass
