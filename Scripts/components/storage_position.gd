@tool
extends Node2D

# func _ready() -> void:
# 	self._set("position", Vector2(1, 2))

func _physics_process(delta: float) -> void:
	#print(get_property_list())
	pass

func _set(property: StringName, value: Variant) -> bool:
	print(property)
	if property == "position":
		move_cards_to_new_storage(get_parent().cards_dragged, value)
		position = value
		return true
	return false


func move_cards_to_new_storage(cards: Array, _position: Vector2) -> void:
		print(cards)
		for card in cards:
			card.position = _position
