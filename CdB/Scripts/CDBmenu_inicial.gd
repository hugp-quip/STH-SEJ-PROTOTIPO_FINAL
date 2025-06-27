extends Control


var acessadosPreviamente : Resource 
var acessados : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(G.pth.path_join("CdB/INFO/baralhosSelecionadosAnteriormente.tres"))
	acessadosPreviamente = ResourceLoader.load(G.pth.path_join("CdB/INFO/baralhosSelecionadosAnteriormente.tres"))
	print(1)
	atualizarAcessados(extrairAcessados())
	print(2)

func extrairAcessados():
	return acessadosPreviamente.baralhosPath

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:  #detecta quando o usuário tenta fechar a janela
		acessadosPreviamente.baralhosPath = acessados.duplicate()
		ResourceSaver.save(acessadosPreviamente, G.pth.path_join("INFO/baralhosSelecionadosAnteriormente.tres"))
		get_tree().quit()

func atualizarAcessados(new_acessed : Array[String]):
	if new_acessed.size() == 1:
		print(new_acessed)
		acessados.append(new_acessed[0])
		var _but = Button.new()
		_but.text = new_acessed[0]
		$VBoxContainer2/ScrollContainer/VBoxContainer.add_child(_but)
		_but.pressed.connect(_on_caminho_para_baralho_dir_selected.bind(_but.text))
	elif new_acessed.size() != 0:
		for new in new_acessed:
				acessados.append(new)
				var _but = Button.new()
				_but.text = new
				$VBoxContainer2/ScrollContainer/VBoxContainer.add_child(_but)
				_but.pressed.connect(_on_caminho_para_baralho_dir_selected.bind(_but.text))
	else:
		acessados = []

func _on_caminho_para_baralho_dir_selected(dir:String) -> void: # caminho padrão para criação de baralho
	atualizarAcessados([dir])
	get_parent().get_parent().dirSelected = dir
	get_parent().get_parent().mudarMenu(get_parent().get_parent().MENUS.CREATE)
	$CaminhoParaBaralhoCRIA.hide() 
	
func _on_criar_baralho_pressed() -> void:
	$CaminhoParaBaralhoCRIA.show()



func _on_caminho_para_baralho_mod_dir_selected(dir:String) -> void:
	G.dirSelected = dir
	get_parent().get_parent().mudarMenu(get_parent().get_parent().MENUS.MODIFY)

func _on_modificar_baralho_pressed() -> void:
	$CaminhoParaBaralhoMOD.show()
