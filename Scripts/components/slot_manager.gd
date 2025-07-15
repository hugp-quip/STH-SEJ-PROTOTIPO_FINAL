
#@tool
class_name SlotManager extends Node2D

var slots : Array 

func _ready() -> void:
	slots = get_node("Table").get_children() + get_node("Hand").get_children()
	
func find_slot(_slot : Sprite2D) -> int :
	return slots.find(_slot)

func get_slot(index : int) -> Sprite2D:
	return slots[index]
