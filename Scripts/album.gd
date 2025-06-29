extends Control

signal switch(new : int)
var but = load("res://Scenes/button_card.tscn")
var curCard : int

func _ready() -> void:
	populateScroll()
	updateCompletion()
	if G.albumAt.completedCartas.size() > 0:
		var id = get_node("ScrollContainer").get_node("GridContainer").get_child(0).cardId
		updateDisplay(id)

func updateCompletion() -> void:
	$Complete.text = str(G.albumAt.completedCartas.size()) + "/" + str(G.barINFO.cartas[0].size())



func populateScroll() -> void:
	for card in G.barINFO.cartas[0].size():
		#var _but = but.instantiate()
		if card in G.albumAt.completedCartas:
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
	$cardDica.text = G.barINFO.cartas[0][id][2]
	




func _on_voltar_pressed() -> void:
	switch.emit(G.M.SELECT)


func _on_reset_alb_pressed() -> void:
	G.albumAt.completedCartas = []
	_on_voltar_pressed()
