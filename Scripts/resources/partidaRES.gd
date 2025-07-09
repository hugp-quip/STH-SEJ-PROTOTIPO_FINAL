extends Resource

class_name PartidaRES

@export var baralhoINFO : BarRES
@export var n_rodadas : int
@export var rodadaAT : int
#@export var n_ajuda : int

func _init(_baralhoRES: BarRES):
	n_rodadas = clamp(_baralhoRES.cartas.size()/5, 1, 5)
	baralhoINFO = _baralhoRES
	rodadaAT = 0
