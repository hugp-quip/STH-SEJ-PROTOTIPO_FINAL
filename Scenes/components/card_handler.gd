extends Node2D
@onready var slotMan : SlotManager = get_node("SlotManager")
var cards_dragged : Array = []
var card_being_dragged : Node2D = null
var mouse_cardOffset : Vector2
var cards_that_finished_auto_moving : int = 0

func _ready() -> void:
	#print(get_children())
	cards_dragged = get_children().map( func (child) : if child is Node2D : return child).filter( func(child) : return child != null)
	
	cards_dragged.map(func (card) : card.finished_auto_moving.connect(_on_finished_auto_moving))

	var timer := Timer.new()
	timer.one_shot = true
	timer.timeout.connect(timertest)
	add_child(timer)
	print(timer.is_stopped())
	timer.start(0.001)
	print(timer.is_stopped())

func _on_finished_auto_moving():	
	cards_that_finished_auto_moving += 1
	
func timertest() -> void:
	print.call_deferred("hello" + str(slotMan.slots.map(func(slot) : return slot.get_position_for_node2d())))
	var j := 0
	for i : int in [5,6,7,8,9]:
		cards_dragged[j].go_to_slot(slotMan.get_slot(i))
		j+=1

func _physics_process(delta: float) -> void:
	if card_being_dragged:
		card_being_dragged.position = get_local_mouse_position() - mouse_cardOffset #lerp(card_being_dragged.position, get_local_mouse_position() - mouse_cardOffset, 25*delta)
	if cards_that_finished_auto_moving <  cards_dragged.size():
		cards_dragged.map(func (card) : card.move_at_start())
	   
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("clicked!!")
			var card_clicked := find_card_raycast().map(func(dict) : return dict.collider).filter( func(node) : return node.get_parent() is TempCartaDisplay ).map( func(collider) : return collider.get_parent())
			if card_clicked.size() > 0:
				
				var _card_clicked : TempCartaDisplay

				if card_clicked.size() > 1:
					var intersection : Array = []
					for card : TempCartaDisplay in card_clicked:
						intersection.append(cards_dragged.find(card))
						
					_card_clicked = cards_dragged[intersection.max()]
				else:
					_card_clicked = card_clicked[0]
				
				card_being_dragged = _card_clicked
				mouse_cardOffset = get_local_mouse_position() - card_being_dragged.position
				
				update_dragged(card_being_dragged ,cards_dragged)
				set_z_cards(cards_dragged)
		else: 
			print("released!!")
			if card_being_dragged:
				var slot_clicked := find_card_raycast().map(func(dict) : return dict.collider).filter( func(node) : return node.get_parent() is Panel).map( func(collider) : return collider.get_parent())
				print(slot_clicked)
				if slot_clicked.size() > 0:
					card_being_dragged.drag_to_slot(slot_clicked[0])
				else:
					card_being_dragged.drag_to_slot(slotMan.get_slot(card_being_dragged.slot_index))
			card_being_dragged = null

func update_dragged(_card_being_dragged: Node2D, _cards_dragged: Array) -> void:
	_cards_dragged.remove_at(cards_dragged.find(_card_being_dragged))
	_cards_dragged.push_back(_card_being_dragged)
	
func set_z_cards(_cards_dragged : Array) -> void:
	for _card : Node2D in _cards_dragged:
		_card.z_index = _cards_dragged.find(_card)







func find_card_raycast() -> Array:
	var space_state := get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result := space_state.intersect_point(parameters)
	#print(test(result))
	return result

func test(result : Array) -> void:
	for dict : Dictionary in result:
		print(dict.collider.get_parent().name)
