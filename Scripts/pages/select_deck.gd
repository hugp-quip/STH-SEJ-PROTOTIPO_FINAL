extends Control

signal switch(new:int)
var barBut = load("res://Scenes/components/bar_but.tscn")
var k : bool = true

func _ready():
	refreshDecks()

func refreshDecks() -> void:
	var bS : Array
	for deck in G.cache_:
		var ab : Resource
		if not(has_album(deck)):
			ab = makeAlbum(deck)
		else:
			ab = ResourceLoader.load(G.pth + "/" + G.info + "ALBUNS/" + deck.nome+"ALBRES"+ ".tres")
		var _but = barBut.instantiate()
		_but.data = deck
		_but.pressed.connect(_barSelected.bind(deck, ab))
		if k:
			bS = [deck, ab]
			k = false
		$ScrollContainer/GridContainer.add_child(_but)
	if G.albumAt:
		_barSelected(G.barINFO, G.albumAt)
	elif bS:
		_barSelected(bS[0], bS[1])

func has_album(deck : Resource) -> bool:
	return FileAccess.file_exists(G.pth + "/" + G.info + "ALBUNS/" + deck.nome+"ALBRES"+ ".tres")

func makeAlbum(deck : Resource) -> Resource:
	var new = AlbumRes.new()
	new.nome = deck.nome+"ALBRES"
	ResourceSaver.save(new, G.pth + "/" + G.info + "/ALBUNS/"+ new.nome + ".tres")
	return new


func _barSelected(deck : Resource, alb : Resource) -> void:
	G.albumAt = alb
	if not(G.albumAt in G.albBUFFER):
		G.albBUFFER.append(G.albumAt)
	G.barINFO = deck
	G.albumAt.performances.sort()
	G.albumAt.completedCartas = stripClones(G.albumAt.completedCartas)
	organize(G.barINFO.cartas[0], 1)
	set_anosOrdem()
	G.baralhoAtual = G.decks + G.barINFO.nome
	updateDesc(deck)
	$nomeDeck.text = G.barINFO.nome
	if G.albumAt.performances:
		$maPont.text = "Maior pontuação = " + str(G.albumAt.performances[-1])
	else:
		$maPont.text = "Não há pontuações para este baralho." 
	$albComplete.text = "Album: " + str(alb.completedCartas.size()) + "/" + str(deck.cartas[0].size())
	$JOGAR.disabled = false
	$SeeAlb.disabled = false
	$SeeRanking.disabled = false

func stripClones(a: Array) -> Array:
	var sb : Array = []
	for i in a:
		if i not in sb:
			sb.append(i)
	return sb


func set_anosOrdem() -> void:
	if not(G.anosOrdem):
		G.anosOrdem = []
	for ano in G.barINFO.cartas[0]:
		G.anosOrdem.append(int(ano[1]))

func organize(a : Array, ano : int) -> void: # this function is absolutely stupid.
	var _k = a.size()
	while _k > 0:
		var i = 0
		while i < a.size():
			var j = i + 1
			var aux = i
			while j < a.size():
				if int(a[i][ano]) <= int(a[j][ano]):
					a.insert(i, a.pop_at(j))
					i+=1
				j+=1
			i = aux + 1
		_k-=1
	a.reverse()

func updateDesc(deck:Resource) -> void:
	$"Descrição/DescText".text = deck.descrição


func _on_voltar_pressed() -> void:
	switch.emit(G.M.INICIAL)

func _on_jogar_pressed() -> void:
	switch.emit(G.M.JOGAR)

func _on_see_alb_pressed() -> void:
	switch.emit(G.M.ALBUM)


func _on_see_ranking_pressed() -> void:
	switch.emit(G.M.RANKING)
