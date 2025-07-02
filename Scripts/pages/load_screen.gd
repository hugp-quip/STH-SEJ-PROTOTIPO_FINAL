extends Control

signal switch(new: int)

var loadT := Thread.new()

func _ready():
	G.get_toLoad()
	loadT.start(loadRES)


func loadRES():
	var full = G.toLoad.size()
	for i in G.toLoad.size():
		G.cache_.push_back(load(G.toLoad[i]))
		$ProgressBar.value = (i+1)*100.0/full
	call_deferred("emit_signal", "switch", G.M.INICIAL)
	




