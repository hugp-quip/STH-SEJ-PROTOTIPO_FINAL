extends Panel

var pth : String
var dirSelected : String

signal switch(new : int)

enum MENUS {
	INICIAL,
	CREATE,
	MODIFY
}

var menus : Dictionary = {
	MENUS.INICIAL : preload("res://CdB/Scenes/CDBmenu_inicial.tscn"),
	MENUS.CREATE : preload("res://CdB/Scenes/criar_baralho.tscn"),
	MENUS.MODIFY : preload("res://CdB/Scenes/modificar_baralho.tscn")
}

var atual = menus[MENUS.INICIAL]
@onready var container = get_node("Menu")

func mudarMenu(novo):
	call_deferred("_deferred_mudar_menu", novo)

func _deferred_mudar_menu(novo):
	atual = menus[novo].instantiate()
	for child in container.get_children():
		#container.remove_child(child)
		child.queue_free()
	container.add_child(atual)






		
