class_name IRodadaJudge extends Node

var slotMan : SlotManager

func _ready() -> void:
	_get_slot_man.call_deferred()

func _get_slot_man() -> void:
	self.slotMan = get_parent().slotMan

func can_evaluate_rodada() -> bool:
	if slotMan.is_table_full():
		return true
	return false

func get_rodada_results() -> Dictionary: # -> {index, boolean}
	var table_order : Array = slotMan.get_table_order_index()
	var correct_order : Array = slotMan.get_correct_card_order_in_table_by_index()
	var debug_table_order : Array = table_order.map(func (card : Dictionary ) -> String: return card.ano)
	var debug_correct_order : Array = correct_order.map(func (card : Dictionary ) -> String: return card.ano)
	##assert(false)
	var ret := {} # -> dict {index, boolean}
	if table_order.map(func(card : Dictionary) -> int: return card.slot) == correct_order.map(func(card : Dictionary) -> int: return card.slot):
		print("Acertooou !!!")
		for i in table_order.size():
			ret[table_order[i].slot] = true
	else: 
		print("ERRROOOOU !!!")
		for i in table_order.size():
			ret[table_order[i].slot] = table_order[i].ano == correct_order[i].ano

	return ret




func is_victory():
	pass
