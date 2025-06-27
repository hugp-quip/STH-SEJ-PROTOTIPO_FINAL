extends Control

var fileDP : FileDialog 
var fileDA : FileDialog 
var passo0 : Panel
var passo1 : Panel
var baralho_path: String

func _ready() -> void:
	passo0 = get_child(0)
	passo1 = get_child(1)
	passo0.visible = true
	passo1.visible = false

	
func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://Mundo.tscn")


func _on_passo_0_mudar_para_passo_1() -> void:
	passo0.visible = false
	passo1.visible = true
	passo1.get_node("baralho_path").text = "será salvo em: " + baralho_path

func _on_cadastrar_baralho_dir_selected(dir: String) -> void:
	baralho_path = dir
	passo0.cad.deselect_all()
	
func _on_passo_1_all_paths_found() -> void:
	pass # Replace with function body.
