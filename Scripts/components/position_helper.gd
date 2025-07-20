extends Control

var slotMan : SlotManager 
var hand : Node2D
var table : Node2D


func _ready():
	start.call_deferred()

func start():
	slotMan = get_parent().get_parent().slotMan
	table = slotMan.get_node("Table")
	hand = slotMan.get_node("Hand")
	_on_table_resized()

# func _physics_process(_delta: float) -> void:
# 	if
# 		hand.global_position = get_node("Hand").position
# 		table.global_position = get_node("Table").position



func _on_table_resized() -> void:
	if hand == null:
		_on_table_resized.call_deferred()
	else:
		hand.global_position = get_node("Hand").position
		table.global_position = get_node("Table").position
		slotMan.align_cards()
	


func _on_hand_resized() -> void:
	if hand == null:
		_on_table_resized.call_deferred()
	else:
		hand.global_position = get_node("Hand").position
		table.global_position = get_node("Table").position
		slotMan.align_cards()
