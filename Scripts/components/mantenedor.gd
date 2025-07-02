extends HBoxContainer

class_name SlotContainer

var slots : Array[Node]


func _ready():
	criarSlots()


func criarSlots(nSlots: int = 5) -> void:
	var slot 
	for slt in range(nSlots):
		slot = Res.cardDiplay.instantiate()
		add_child(slot)
		slots.append(slot)
		slot.makeSlot()

func get_slots() -> Array[Node]:
	return get_children()

func get_cards() -> Array[Node]:
	var ret: Array[Node] = []
	for slot in get_slots():
		if slot.is_slot == false:
			ret.append(slot)
	return ret

func get_card(id):
	#print(get_child(id).dados_carta)
	return [get_child(id), str(get_child(id).dados_carta[1])] # [local do fdb, ano da carta]
	
func get_cards_Ano() -> Array[int]: # esta função assume que a mantenedor está cheio de cartas
	var cards = slots
	var anos: Array[int]
	for card in cards:
		anos.append(int(card.get_node("Ano").text))
	return anos
		
func makeNotInspect() -> void:
	for carta in get_children() as Array[CardDisplay]:
		carta.can_inspect = false

func makeInspect() -> void:
	for carta in get_children() as Array[CardDisplay]:
		carta.can_inspect = true

func inserirCartas() -> void:
	pass

func resetarSlots() -> void:
	for slot in get_slots():
		slot.makeSlot()
