@tool
extends Node

const carta_size : Vector2 = Vector2(404.0, 572.0)

# if already has scale do get_rect*scale to old_size
func scale_to_same_size(reference_size : Vector2, old_size : Vector2) -> Vector2:
	#print(str(reference_size) + "/" + str(old_size))
	#print(Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y))
	return Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y)
	
func get_size(node : Sprite2D) ->  Vector2:
	return node.get_rect().size * node.global_scale
	 
