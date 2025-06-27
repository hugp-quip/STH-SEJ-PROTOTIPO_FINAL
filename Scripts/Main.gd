extends Node


@onready var menu = get_node("Menu")
@onready var atual = menu.get_child(0)

func _ready() -> void:
	menu.get_child(0).switch.connect(_on_switch)

func _on_switch(new:int) -> int:
	if new == G.M.EXIT:
		savebeforequiting()
		get_tree().quit()
		return 4
	elif new == G.M.JOGAR:
		atual.queue_free()
		atual = G.menus[new].instantiate()
		criarPartida(5, 3, atual)
		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0

	atual.queue_free()
	#print(G)
	#print(G.menus[new])
	atual = G.menus[new].instantiate()
	menu.add_child(atual)
	menu.get_child(1).switch.connect(_on_switch)
	return 0

func criarPartida(nTentativas, nRodadas, _partida) -> void:	
	_partida.nTentativas = nTentativas
	_partida.nRodadas = nRodadas

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		savebeforequiting()

func savebeforequiting() -> void:
	for alb in G.albBUFFER:
		saveGam(alb)

func saveGam(alb) -> void:
	print(alb.nome + " foi salvo")
	if alb:
		print(ResourceSaver.save(alb, G.pth + G.info + "ALBUNS/"+ alb.nome + ".tres"))
