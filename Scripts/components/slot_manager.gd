
#@tool
class_name SlotManager extends Node2D

var slots : Array # -> Array[NodeSlot]
var cards : Array # -> Array[NodeCard]

func _ready() -> void:
	slots = get_node("Table").get_children() + get_node("Hand").get_children()
	_start_cards.call_deferred() 
	
func _start_cards() -> void:
	var _n_cartas: int = get_parent().get_parent().n_cartas
	var _cards: Array = get_parent().cards 
	for i in _n_cartas*2: # há duas rows de slots.
		cards.append(null)
	for i in _n_cartas:
		cards[i] = _cards[i]

func is_slot_has_card_node(_slot: Sprite2D) -> bool:
	return cards[find_slot(_slot)] != null

func is_slot_has_card_index(slot_index: int) -> bool:
	return cards[slot_index] != null

func find_slot(_slot : Sprite2D) -> int :
	return slots.find(_slot)

func get_slot(index : int) -> Sprite2D:
	return slots[index]

func find_card	(card : Sprite2D) -> int:
	return cards.find(card)

func get_card (index : int) -> Sprite2D:
	return cards[index]

func swap_card(card : NodeCard, slot_index: int) -> void:
		assert(cards[slot_index] != null, "TENTOU SWAP EM SLOT SEM CARTA!!")	
		var old_card := get_card(slot_index) # carta que estava na posição nova
		var old_slot_index := find_card(card) # slot antigo desta carta.
		cards[slot_index] = card
		cards[old_slot_index] = old_card
		old_card.drag_to_slot(get_slot(old_slot_index))
		card.drag_to_slot(get_slot(slot_index))

	
func move_card(card : NodeCard, slot_index: int) -> void:
	assert(cards[slot_index] == null, "TENTOU MOVER CARTA PARA SLOT COM OUTRA CARTA!!!")
	cards[find_card(card)] = null
	cards[slot_index] = card
	card.drag_to_slot(get_slot(slot_index))

func check_if_empty_slot(_slot: Sprite2D) -> bool:
	return false
