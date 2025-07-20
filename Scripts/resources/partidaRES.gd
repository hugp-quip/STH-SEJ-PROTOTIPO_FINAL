extends Object

class_name PartidaRES

@export var baralhoINFO : BarRES
@export var n_rodadas : int
@export var n_cartas : int = 5
@export var rodadaAT : int = 0
#@export var n_ajuda : int

func criar(_n_cartas: int, _baralhoRES: BarRES) -> void:
	n_rodadas = clamp(_baralhoRES.cartas.size()/5, 1, 5)
	n_cartas = _n_cartas
	baralhoINFO = _baralhoRES

