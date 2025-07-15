extends Control

func _ready() -> void:
	custom_minimum_size = Vector2(404, 572)
	var sprt: Sprite2D = get_node("Sprite2D")
	#sprt.position = get_position_for_node2d() 
	var curent_size := sprt.texture.get_size()
	sprt.scale.x = (get_global_rect().size.x / curent_size.x )
	sprt.scale.y = ( get_global_rect().size.y / curent_size.y )


func get_position_for_node2d() -> Vector2:
	var ret : Vector2 = Vector2()
	ret.x = get_global_rect().position.x + get_global_rect().size.x/2.0 # + position.x + size.x/2
	ret.y = get_parent().get_global_rect().position.y + get_parent().get_global_rect().size.y/2.0 #get_parent().position.y + size.y/2

	return ret
