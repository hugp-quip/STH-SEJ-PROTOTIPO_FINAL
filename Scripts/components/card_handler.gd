
extends Node2D


@onready var animHan : = get_node("AnimationHandler")
@onready var slotMan : SlotManager = get_node("AnimationHandler").get_node("SlotManager")
@export var n_cartas : int = 5

var cards_dragged : Array = []
var card_being_dragged : Node2D = null
var mouse_cardOffset : Vector2
var cards_that_finished_auto_moving : int = 0

var card_hovered

func _ready() -> void:
	cards_dragged = animHan.cards
	#cards_dragged.map( func (card) : SlotManager. )
	



func _physics_process(delta: float) -> void:
	if card_being_dragged:
		if card_hovered != null: 
				card_hovered.scale = Vector2(1, 1)
				card_hovered = null
		card_being_dragged.position= animHan.get_local_mouse_position() - mouse_cardOffset #lerp(card_being_dragged.position, get_local_mouse_position() - mouse_cardOffset, 25*delta)
	else:
	# optimization oportunity, we cast this raycast every frame and also on the input.
		var _card_hovered = find_card_raycast().map(func(dict) : if dict.collider.get_parent() is NodeCard: return dict.collider.get_parent()).filter( func(node) : return node != null)
		#print(_card_hovered.map(func(card) : if card: return card.name))
		if not (card_being_dragged) and _card_hovered.size() > 0 and _card_hovered[0]:   
			if card_hovered != _card_hovered[0]:
				if card_hovered != null: 
					card_hovered.scale = Vector2(1, 1)

				card_hovered = _card_hovered[0]
				card_hovered.scale = Vector2(1.2, 1.2)
		else:
			if card_hovered != null: 
				card_hovered.scale = Vector2(1, 1)
				card_hovered = null
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			#print("clicked!!")
			var card_clicked := find_card_raycast().map(func(dict) : if dict.collider.get_parent() is NodeCard: return dict.collider.get_parent())
			if card_clicked.size() > 0:
				var _card_clicked : NodeCard

				if card_clicked.size() > 1:
					var intersection : Array = []
					# encontra a última carta clicada no cards_dragged
					for card : NodeCard in card_clicked:
						intersection.append(cards_dragged.find(card))
						
					_card_clicked = cards_dragged[intersection.max()]

				else:
					_card_clicked = card_clicked[0]
				
				if _card_clicked and _card_clicked.draggable:
					card_being_dragged = _card_clicked
					mouse_cardOffset = animHan.get_local_mouse_position() - card_being_dragged.position
					
					animHan.update_dragged(card_being_dragged ,cards_dragged)
					animHan.set_z_cards(cards_dragged)
		else: #if event.released:
			#print("released!!")
			if card_being_dragged:
				var slot_clicked := find_card_raycast().map(func(dict) : return dict.collider).filter( func(node) : return node.get_parent() is NodeSlot).map( func(collider) : return collider.get_parent())
				#util.printn("slot_clicked", slot_clicked)
				# deffaults to higher slot
				if slot_clicked.size() > 0:
					var _slot : NodeSlot = slot_clicked[0]
					if slotMan.is_slot_has_card_node(_slot):
						slotMan.swap_card(card_being_dragged, slotMan.find_slot(_slot))
					else:
						slotMan.move_card(card_being_dragged, slotMan.find_slot(_slot))
				else: # if hasn't been dragged to slot...
					card_being_dragged.drag_to_slot(slotMan.get_slot(slotMan.find_card(card_being_dragged)))
			card_being_dragged = null

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
