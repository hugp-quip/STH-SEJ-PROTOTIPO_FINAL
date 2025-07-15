@tool
extends Node2D

@export var n_cartas : int = 5 :
	set(v):
		n_cartas = v
		instantiate_cartas()


func _ready() -> void:
	instantiate_cartas()

func instantiate_cartas() -> void:
	for i : int in n_cartas:
		var carta : Sprite2D = load("res://Scenes/components/node_carta_display.tscn").instantiate()
		#print(util.get_size(carta))
		carta.scale =  util.scale_to_same_size(util.carta_size, util.get_size(carta))
		#print(util.get_size(carta))
		add_child(carta)


func update_dragged(_card_being_dragged: Node2D, _cards_dragged: Array) -> void:
	_cards_dragged.remove_at(_cards_dragged.find(_card_being_dragged))
	_cards_dragged.push_back(_card_being_dragged)
	
func set_z_cards(_cards_dragged : Array) -> void:
	for _card : Node2D in _cards_dragged:
		_card.z_index = _cards_dragged.find(_card)
