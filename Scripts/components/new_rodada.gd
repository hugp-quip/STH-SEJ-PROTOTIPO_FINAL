@tool
class_name Rodada extends Node2D

var data : RodadaRES 

@onready var cardHan : CardHandler = get_node("CardHandler")
@onready var animHan : RodadaAnimationHandler = cardHan.get_node("AnimationHandler")
@onready var slotMan : SlotManager = animHan.get_node("SlotManager")
@onready var judge : IRodadaJudge = get_node("RodadaJudge")
@onready var debugText : Label = get_node("result_debug")
func _ready() -> void:
	if not (get_parent() is RodadaCont):
		data = RodadaRES.new()
		data.n_cartas = 5
		#data.cards = _load_fake_cartas(data.n_cartas)
	

func criar_rodada(_data : RodadaRES) -> void:
	#assert(_data != null, "TENTOU CRIAR PARTIDA SEM DATA!!!")
	data = _data
	


func restart(_data : RodadaRES):
	data = _data
	animHan.restart()
	slotMan.restart()



func _load_fake_cartas(_n_cartas : int) -> Array:
	var res_arr : Array = []
	var rand : RandomNumberGenerator = RandomNumberGenerator.new()
	for i in _n_cartas:
		var r = rand.randi_range(0, 71)
		var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
		res_arr.append(res)
	
	return res_arr


func _on_envio_pressed() -> void:
	if not (judge.can_evaluate_rodada()):
		print("Insira mais cartas!!!")
		debugText.text ="Insira mais cartas!!!"
	else:
		print("Julgando!")
		#print(judge.get_rodada_results())
		# var gt= judge.get_rodada_results()
		# var vl = gt.values()
		# var ky = gt.keys()
		# var ret = {}
		
		# for i in ky.size():
		# 	ret[slotMan.get_card(ky[i]).data.legenda] = vl[i]

		debugText.text = str(judge.get_rodada_results())
		



func _on_table_resized() -> void:
	pass # Replace with function body.
