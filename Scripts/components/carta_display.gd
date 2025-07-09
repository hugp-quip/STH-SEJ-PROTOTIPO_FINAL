extends TextureButton

class_name CartaDisplay

var data : CartaRES

func criar_carta_display(_data: CartaRES) -> void:
	data = _data
	updateUI(data)


func updateUI(_data: CartaRES) -> void:
	get_node("UIHandler").update(_data)



func _on_pressed() -> void:
	print("pressed!")
