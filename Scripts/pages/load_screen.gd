extends Control

signal switch(new: int)

#var loadT := Thread.new()
var baralhoToLoad : Array


func _ready():
	# call_deferred("emit_signal", "switch", G.M.INICIAL)
	# return 0
	baralhoToLoad = G.get_baralhoToLoad()
	# print(baralhoToLoad)
	# var testeCarta = load("res://Resources/Cartas/0.tres")
	# var testeBaralho = load("res://Resources/Baralhos/AIDS.tres")
	# print("ERROR: "+str(load(baralhoToLoad[0])))
	# #assert(false)
	#loadT.start(loadRES)
	loadRES()
	
	

func loadRES() -> void:
	var full : float = baralhoToLoad.size()
	#print(baralhoToLoad)
	#(baralhoToLoad[i] as String).get_basename()
	for i in baralhoToLoad.size():
		G.baralhoCache.push_back(ResourceLoader.load(baralhoToLoad[i] if baralhoToLoad[i].get_extension() == "tres" or baralhoToLoad[i].get_extension() == "res" else baralhoToLoad[i].get_basename()))
		$ProgressBar.value = (i+1)*100.0/full
	call_deferred("emit_signal", "switch", G.M.INICIAL)

# func _exit_tree() -> void:
# 	loadT.wait_to_finish()
	
