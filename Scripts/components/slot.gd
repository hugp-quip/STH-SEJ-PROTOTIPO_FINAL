extends Panel

func get_position_for_node2d() -> Vector2:
	var ret : Vector2 = Vector2()
	ret.x = get_global_rect().position.x + get_global_rect().size.x/2.0 # + position.x + size.x/2
	ret.y = get_parent().get_global_rect().position.y + get_parent().get_global_rect().size.y/2.0 #get_parent().position.y + size.y/2

	return ret