extends Control

signal switch(new:int, data : Dictionary)
var barBut : PackedScene = load("res://Scenes/components/bar_but.tscn")
var is_first_time : bool = true
var baralhoAT: BaralhoINFO
var albumAT : AlbumRes

func _ready():
	refreshDecks()

func refreshDecks() -> void:
	var bS : Array
	for deck : Resource in G.oLDbaralhoCache:
		var ab : Resource
		if not(has_album(deck)):
			ab = makeAlbum(deck)
		else:
			ab = ResourceLoader.load((G.pth + "/" + G.info + "ALBUNS/" + deck.nome +"ALBRES"+ ".tres"))
		var _but := barBut.instantiate()
		_but.data = deck
		_but.pressed.connect(_barSelected.bind(deck, ab))
		if is_first_time:
			bS = [deck, ab]
			is_first_time = false
		$ScrollContainer/GridContainer.add_child(_but)
	if G.albumAT:
		_barSelected(G.oLDbaralhoAT, G.albumAT)
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
	baralhoAT = deck
	albumAT = alb
	G.albumAT = alb
	if not(G.albumAT in G.albumBuffer):
		G.albumBuffer.append(G.albumAT)
	G.oLDbaralhoAT = deck
	G.albumAT.performances.sort()
	G.albumAT.completedCartas = stripClones(G.albumAT.completedCartas)
	organize(G.oLDbaralhoAT.cartas[0], 1)
	#set_anosOrdem()
	G.baralhoAtual = G.decks + G.oLDbaralhoAT.nome
	updateDesc(deck)
	$nomeDeck.text = G.oLDbaralhoAT.nome
	if G.albumAT.performances:
		$maPont.text = "Maior pontuação = " + str(G.albumAT.performances[-1])
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


# func set_anosOrdem() -> void:
# 	if not(G.anosOrdem):
# 		G.anosOrdem = []
# 	for ano in G.oLDbaralhoAT.cartas[0]:
# 		G.anosOrdem.append(int(ano[1]))

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
	switch.emit(G.M.JOGAR, {"baralhoAT": baralhoAT, "albumAT": albumAT})

func _on_see_alb_pressed() -> void:
	switch.emit(G.M.ALBUM)


func _on_see_ranking_pressed() -> void:
	switch.emit(G.M.RANKING)
