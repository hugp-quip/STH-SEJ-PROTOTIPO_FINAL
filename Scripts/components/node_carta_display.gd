

@tool
class_name NodeCard extends Sprite2D


signal finished_auto_moving
signal finished_animation

var draggable := false
#var slot_index : int
var position_goal : Vector2
var data : CartaRES



func _ready() -> void:
	if Engine.is_editor_hint():
		load_fake_card.call_deferred()

		
		
func load_fake_card(id : int = -1) -> void:
		var rand = RandomNumberGenerator.new()
		rand.randomize()
		var r : int
		if id != -1:
			r = id
		else:
			r = rand.randi_range(0, 71) # card id
		print("internal: " + str(r))
		var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".tres")
		data = res
		criar_carta_display(res)

func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)

func scale_to_same_size(reference_size : Vector2, old_size : Vector2) -> Vector2:
	return Vector2(reference_size.x/old_size.x , reference_size.y/old_size.y)

func move_at_start(_delta) -> void:
	# o +20 e -20 faz com que a animação ocorra mais rápido.
	global_position.x = lerp(global_position.x, position_goal.x+20, 0.08)
	global_position.y = lerp(global_position.y, position_goal.y+20, 0.08)
	# O move_toward faz ele se mover de forma não diagonal. (??????)
	#global_position = Vector2(move_toward(global_position.x, position_goal.x, delta*100), move_toward(global_position.y, position_goal.y, delta*100))
	#print(ceilf(global_position.y), position_goal.y-10)
	if ceilf(global_position.y) >= position_goal.y-20:
		global_position = position_goal
		finished_auto_moving.emit()
		draggable = true

func updateUI(_data: CartaRES) -> void:
	get_node("UIHandlernode").update(_data)

func drag_to_slot(slot: Sprite2D) -> void :
	global_position = slot.global_position

func move_to_goal():
	draggable = false

	global_position.x = lerp(global_position.x, position_goal.x, 0.08)
	global_position.y = lerp(global_position.y, position_goal.y, 0.08)
	print(ceilf(global_position.y), position_goal.y-1)
	if ceilf(global_position.y) >= position_goal.y-1:
		finished_animation.emit()
		draggable = true


func go_to_slot(slot: Sprite2D) -> void:
	#util.printn("go_to_slot", slot)
	position_goal = slot.global_position

#func go_to_slot_index(index: int) -> void:
