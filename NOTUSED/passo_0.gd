extends Panel

var container: VBoxContainer
var select: Button
var sel: FileDialog
var cadast: Button
var cad: FileDialog
signal mudarParaPasso1

func _ready() -> void:
	container = get_child(0) 
	#print(container)
	select = container.get_child(0)
	cadast = container.get_child(1)
	cad = cadast.get_child(0)

func _on_selecionar_pressed() -> void:
	sel.title = "Selecione a pasta do baralho"
	sel.visible = true
	print("selecionar ainda não implementado")

func _on_cadastrar_pressed() -> void:
	cad.title = "Selecione local guardar o baralho"
	cad.visible = true


func _on_selecionar_baralho_dir_selected(dir: String) -> void:
	pass # Replace with function body.

func _on_cadastrar_baralho_dir_selected(dir: String) -> void:
	mudarParaPasso1.emit()
	print(1)
