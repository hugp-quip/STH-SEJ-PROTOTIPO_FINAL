extends VBoxContainer

class_name SlotManager

var slots : Array 

func _ready() -> void:
	slots = get_node("Table").get_children() + get_node("Hand").get_children()
	

func find_slot(_slot : Panel) -> int :
	return slots.find(_slot)

func get_slot(index : int) -> Panel:
	return slots[index]
