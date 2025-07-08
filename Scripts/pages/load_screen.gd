extends Control

signal switch(new: int)

var loadT := Thread.new()

func _ready():
	G.get_baralhoToLoad()
	loadT.start(loadRES)


func loadRES():
	var full = G.baralhoToLoad.size()
	for i in G.baralhoToLoad.size():
		G.oLDbaralhoCache.push_back(load(G.baralhoToLoad[i]))
		$ProgressBar.value = (i+1)*100.0/full
	call_deferred("emit_signal", "switch", G.M.INICIAL)
	




