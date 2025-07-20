
#@tool
class_name SlotManager extends Node2D

var rodada_data : RodadaRES 

var slots : Array # -> Array[NodeSlot] 
var cards : Array # -> Array[NodeCard] -> null if doesn't have card.

func _ready() -> void:
	slots =   get_node("Hand").get_children() + get_node("Table").get_children() 
	_get_rodada_data.call_deferred()
	_get_cards.call_deferred.call_deferred()

# func restart() -> void:
# 	_get_rodada_data.call_deferred()
# 	_get_cards.call_deferred() 

func align_cards() -> void:
	if rodada_data != null and get_parent().cards_that_finished_auto_moving == rodada_data.n_cartas:
		for card : NodeCard in cards.filter(func (card) : return card != null):
			card.drag_to_slot(get_slot(find_card(card)))


func get_table_slots() -> Array:
	return get_node("Table").get_children()

func is_table_full() -> bool:
	var count : int = 0
	var tableSlots : Array = self.get_table_slots()
	for slot in tableSlots:
		if self.is_slot_has_card_node(slot):
			#print(cards[find_slot(slot)])
			count += 1 
	#assert( count <= rodada_data.n_cartas, "DE ALGUMA FORMA TEM MAIS CARTAS NA MESA DO QUE DEVERIAM TER NA PARTIDA????" )
	return count == rodada_data.n_cartas

func _get_rodada_data() -> void:
	rodada_data = get_parent().get_parent().get_parent().data # -> rodada.data
	

func _get_cards() -> void:
	var _n_cartas: int = rodada_data.n_cartas
	var _cards: Array = get_parent().cards 
	for i in _n_cartas*2: # há duas rows de slots.
		cards.append(null)
	for i in _n_cartas:
		cards[i] = _cards[i]

func get_table_order_index() -> Array:
	# Array of all cards in the table:
	var cards_in_order_index : Array= get_table_slots().map(func (slot : NodeSlot) -> NodeCard : return get_card_in_slot(slot))
	
	# # Sorting those cards by year:
	# cards_in_order_index.sort_custom(func (card1, card2) : if card1.get_ano().to_int() < card2.get_ano().to_int(): return true else : return false)
	# print("cards_in_order_index: ", cards_in_order_index)
	
	# geting the index for each card is located:
	cards_in_order_index = cards_in_order_index.map(func (card: NodeCard) -> Dictionary :  return {"slot": find_card(card), "ano": card.data.ano})
	return cards_in_order_index

func get_correct_card_order_in_table_by_index() -> Array:
	var sorted_cards : Array = cards.filter( func (card) : return card != null)
	# gets cards and years sorted the same way.
	sorted_cards.sort_custom(func (card1, card2) : if card1.get_ano().to_int() < card2.get_ano().to_int(): return true else : return false)
	sorted_cards = sorted_cards.map(func (card: NodeCard) -> Dictionary : return {"slot": find_card(card), "ano": card.data.ano}) # get the id for each card.
	return sorted_cards

func is_slot_has_card_node(_slot: Sprite2D) -> bool:
	return cards[find_slot(_slot)] != null

func is_slot_has_card_index(slot_index: int) -> bool:
	return cards[slot_index] != null

func get_card_in_slot(_slot : NodeSlot) -> NodeCard:
	#assert(is_slot_has_card_node(_slot), "TENTOU CONSEGUIR CARTA DE SLOT SEM CARTA!!!")
	return self.get_card(find_slot(_slot))

func find_slot(_slot : Sprite2D) -> int :
	return slots.find(_slot)

func get_slot(index : int) -> Sprite2D:
	return slots[index]

func find_card	(card : Sprite2D) -> int:
	return cards.find(card)

func get_card (index : int) -> Sprite2D:
	return cards[index]

func swap_card(card : NodeCard, slot_index: int) -> void:
		#assert(cards[slot_index] != null, "TENTOU SWAP EM SLOT SEM CARTA!!")	
		var old_card := get_card(slot_index) # carta que estava na posição nova
		var old_slot_index := find_card(card) # slot antigo desta carta.
		cards[slot_index] = card
		cards[old_slot_index] = old_card
		old_card.drag_to_slot(get_slot(old_slot_index))
		card.drag_to_slot(get_slot(slot_index))

	
func move_card(card : NodeCard, slot_index: int) -> void:
	#assert(cards[slot_index] == null, "TENTOU MOVER CARTA PARA SLOT COM OUTRA CARTA!!!")
	cards[find_card(card)] = null
	cards[slot_index] = card
	card.drag_to_slot(get_slot(slot_index))

func check_if_empty_slot(_slot: Sprite2D) -> bool:
	return false
