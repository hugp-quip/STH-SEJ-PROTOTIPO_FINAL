extends Node


@onready var menu := get_node("Menu")
@onready var atual : Node = menu.get_child(0)

func _ready() -> void:
	#print("create")
	#create_new_baralhos()
	menu.get_child(0).switch.connect(_on_switch)

# func _convert_to_binary() -> void:
	
# 	var baralhosDir : = "res://Resources/Baralhos/"
# 	var baralhos_ImagensDir : = "res://Resources/Baralhos_Imagens/"
# 	var cartasDir : = "res://Resources/Cartas/"
# 	var cartas_imagensDir : = "res://Resources/Cartas_Imagens/"
# 	#test2(baralhosDir, baralhos_ImagensDir )
# 	#test(baralhos_ImagensDir, "null")
# 	test2(cartasDir, cartas_imagensDir)
# 	#test(cartas_imagensDir, "null")
# 	assert(false)
# 	#for baralho in 

# func test2(path: String, imgPath: String):
# 	var dir : = DirAccess.open(path)
# 	var i := 0
# 	for res in dir.get_files():
# 		var temp : Resource = load(path+res)
# 		temp.imagem = load(imgPath + str(i) + ".res" )
# 		print(error_string(ResourceSaver.save(temp, path + str(i) + ".res")))
		#i+=1

# func test(path: String, name: String):
# 	var baralhosDir : = DirAccess.open(path)
# 	var i := 0
# 	for res in baralhosDir.get_files():
# 		var temp : Resource = load(path+res)
# 		print(path + str(i) + ".res")
# 		print(error_string(ResourceSaver.save(temp, path + str(i) + ".res")))
# 		i+=1

func _on_switch(new:int, data: BarRES = null) -> int:
	#_convert_to_binary()
	# #partidaTESTE()
	# atual.queue_free()
	# atual = load("res://Scenes/pages/NEWPartida.tscn").instantiate()
	# add_child(atual)
	# var part : PartidaRES = PartidaRES.new()
	# part.criar(5, load("res://Resources/Baralhos/AIDS.tres")) # G.baralhoAT)
	# atual.criar_partida(part)

	# return 1
	if new == G.M.EXIT:
		#savebeforequiting()
		get_tree().quit()
		return 4
	elif new == G.M.JOGAR:
		#assert(data != null, "TRIED CREATING PARTIDA WITHOUT BARALHO.")
		# #assert(not (data.baralhoAT is BaralhoINFO), "TRIED STARTING A PARTIDA WITH THE OLD BARALHO MODEL.")
		
		# btw to find a type by name use "type_string(type_off())"
		atual.queue_free()
		atual = G.menus[new].instantiate()
		
		#print("data = " + str(data))
		#atual.criar_partida(5, 3, data["baralhoAT"], data["albumAT"])
		var part : PartidaRES = PartidaRES.new()
		part.criar(5, data)#load("res://Resources/Baralhos/AIDS.tres")) # G.baralhoAT)
		atual.criar_partida(part)

		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0
	elif new == G.M.INICIAL:
		#create_new_baralhos()
		pass
	
	#assert(new != G.M.ALBUM, "TRIED TO SWITCH TO ALBUM!!!")
	atual.queue_free()
	#print(G)
	#print(G.menus[new])
	atual = G.menus[new].instantiate()
	menu.add_child(atual)
	menu.get_child(1).switch.connect(_on_switch)
	return 0
