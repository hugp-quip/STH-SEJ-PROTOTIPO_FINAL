extends Control

signal switch(new: int)

#var loadT := Thread.new()
var baralhoToLoad : Array


func _ready() -> void:
	baralhoToLoad = G.get_baralhoToLoad()
	#loadT.start(loadRES)
	loadRES()
	
	

func loadRES() -> void:
	var full : float = baralhoToLoad.size()
	#print(baralhoToLoad)
	for i in baralhoToLoad.size():
		G.baralhoCache.push_back(load(baralhoToLoad[i]))
		$ProgressBar.value = (i+1)*100.0/full
	call_deferred("emit_signal", "switch", G.M.INICIAL)

# func _exit_tree() -> void:
# 	loadT.wait_to_finish()
	
