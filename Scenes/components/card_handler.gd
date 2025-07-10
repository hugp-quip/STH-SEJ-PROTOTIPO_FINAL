extends Node2D

# var last_card_dragged_index : int = 0
var card_being_dragged : Node2D = null
var mouse_cardOffset : Vector2

func _physics_process(delta: float) -> void:
	if card_being_dragged:
		
		card_being_dragged.position = get_local_mouse_position() - mouse_cardOffset #lerp(card_being_dragged.position, get_local_mouse_position() - mouse_cardOffset, 25*delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print("clicked!!")
			var card_clicked := find_card_raycast()
			if card_clicked.size() > 0:
				card_being_dragged = card_clicked[-1].collider.get_parent().get_parent()
				mouse_cardOffset = get_local_mouse_position() - card_being_dragged.position
				# last_card_dragged_index += 1
				# card_being_dragged.z_index = last_card_dragged_index
		else: 
			print("released!!")
			card_being_dragged = null

func find_card_raycast() -> Array:
	var space_state := get_world_2d().direct_space_state
	var parameters := PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result := space_state.intersect_point(parameters)
	print(result)
	return result

func test(result : Array):
	for dict : Dictionary in result:
		print(dict.collider.get_parent().get_parent().name)

