extends Control

signal switch(new : int)
var but = load("res://Scenes/components/button_card.tscn")
var curCard : int

func _ready() -> void:
	populateScroll()
	updateCompletion()
	if G.albumAT.completedCartas.size() > 0:
		var id = get_node("ScrollContainer").get_node("GridContainer").get_child(0).cardId
		updateDisplay(id)

func updateCompletion() -> void:
	print(G.albumAT.completedCartas)
	$Complete.text = str(G.albumAT.completedCartas.size()) + "/" + str(G.baralhoAT.cartas[0].size())



func populateScroll() -> void:
	for card in G.baralhoAT.cartas[0].size():
		#var _but = but.instantiate()
		if card in G.albumAT.completedCartas:
			var _but = but.instantiate()
			_but.cardId = card
			_but.get_node("numCarta").text = str(card + 1)
			_but.pressed.connect(_on_but_pressed.bind(card))
			$ScrollContainer/GridContainer.add_child(_but)

		#else:
		#	_but.makeSlot()
		#	_but.disabled = true
		#_but.pressed.connect(_on_but_pressed.bind(card))
		#$ScrollContainer/GridContainer.add_child(_but)


	


func _on_but_pressed(id) -> void:
	curCard = id
	updateDisplay(id)

func updateDisplay(id) -> void:
	$CardDisplay.cardId = id
	$CardDisplay.atualizar()
	$cardDica.text = G.baralhoAT.cartas[0][id][2]
	




func _on_voltar_pressed() -> void:
	switch.emit(G.M.SELECT)


func _on_reset_alb_pressed() -> void:
	G.albumAT.completedCartas = []
	_on_voltar_pressed()
