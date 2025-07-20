@tool
class_name SlotSorter extends Node2D
var slotNodeScene = load("res://Scenes/components/slot.tscn")
var slots : Array
@export var spacing : int = 0:
	set(v):
		spacing = v 
		n_slots = n_slots
		#sort_slots(self.slots, self.get_rect(), spacing)
@export var n_slots : int :
	set(v):
		n_slots = v
		get_children().map(func(child) : child.queue_free())
		create_slots(n_slots)


func _ready() -> void:
	slots = get_children()
	#print(get_children())
	#sort_slots(self.slots, self.get_rect(), spacing)

func create_slots(_n_slots : int ) -> void:
	var size := util.scale_to_same_size(util.carta_size, util.get_size(slotNodeScene.instantiate()))
	for _slot : int in _n_slots:
		var slot : Sprite2D = slotNodeScene.instantiate()
		#print(util.get_size(slot))
		slot.global_scale = size
		#print(util.get_size(slot))
		slot.global_position.x = util.get_size(slot).x*_slot + _slot*spacing 
		add_child(slot)


func sort_slots(_slots : Array, rect : Rect2, _spacing : int) -> void:
	#print(_slots[0].get_rect()) 
	
	var _card_size : Vector2 = _slots[0].get_rect().size * slots[0].scale
	#print(_card_size)
	var _sorter_size : = rect.size
	#print(str(_card_size.x*_slots.size() + _spacing*_slots.size()) + "/" + str(_sorter_size.x))
	#assert(_card_size.x*_slots.size() + _spacing*_slots.size() < _sorter_size.x, "CARDS TOO BIG FOR SORTER SIZE!!!") 

	pass
