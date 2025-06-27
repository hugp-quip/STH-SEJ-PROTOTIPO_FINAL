extends Control

@onready var partida: = load("res://Scenes/Partida.tscn")
var baralhoPath : String = "Decks/Example_Deck/" #-> os caminhos são decididos por completo no ready()
var baralhoPathCsv : String = "conversão_de_csv_para_dicionário.txt"
var baralhoNome : String 
var baralhoArr : Array # Armazena o baralho selecionado em sí
var folder # variável que armazena o caminho do sistema operacional até o jogo.
var tags : Array
var ptags : Array = []# são as tags selecionadas pelo player
func _ready() -> void: 
	baralhoNome = "baralho ataual = " + baralhoPath.split("/")[1]
	$Menu_inicial/buttons/Baralho_atual.text = baralhoNome

	if OS.has_feature("editor") or OS.has_feature("debug"): # -> detecta se estamos ou não no editor, carregando assim o tipo preferível de caminho
		folder = "res://"
		baralhoPath = folder.path_join(baralhoPath)
		baralhoPathCsv = baralhoPath.path_join(baralhoPathCsv)
	else:
		folder = OS.get_executable_path().get_base_dir()
		baralhoPath = folder.path_join(baralhoPath)
		baralhoPathCsv = baralhoPath.path_join(baralhoPathCsv)
		
	baralhoArr = importar_csv_para_dicionario()
	tags = get_tags(baralhoArr)
	tags.append("\"\"") # as tags do baralho são atualizadas somente uma vez, aqui. Para utilizar múltiplos baralhos isso deve ser mudado.

func _physics_process(_delta: float) -> void:
	if $Selecionar_tags.visible == true:
		if not $Selecionar_tags/VBoxContainer/LineEdit.text.is_empty():
			checarSeTagExiste()
		else:
			ptags.clear()
			ptags.append("\"\"")
			mudarTextoDasTags(true)
	
func checarSeTagExiste() -> void:
		var aux = $Selecionar_tags/VBoxContainer/LineEdit.text.to_upper()
		ptags.clear()
		if aux.split(", ").size() > 0:
			ptags = aux.split(", ")
		elif aux.length > 0:
			ptags.append(aux)
		
		var valid = true
		for tag in ptags:
			if not(tag in tags):
				valid = false

		mudarTextoDasTags(valid)		

func mudarTextoDasTags(valid):
		if valid:
			$Selecionar_tags/VBoxContainer/TagFindText.text = "Tags existem"
			$Selecionar_tags/VBoxContainer/jogar.disabled = false
		else:
			$Selecionar_tags/VBoxContainer/TagFindText.text = "Erro! uma das tags não foi encontrada!"
			$Selecionar_tags/VBoxContainer/jogar.disabled = true
								
#func _mudarBaralhoPath(new:String) -> void: # -> SelectBar
#	get_node("buttons").get_node("Baralho_atual").text = new

'''
func _on_sair_do_jogo_pressed() -> void: 
	get_tree().quit()

func _on_jogar_pressed() -> void: # código para o botão de jogar no menu de tags 
	$Menu_inicial.visible = false
	$Selecionar_tags.visible = false
	$Titulo.visible = false
	criarPartida(baralhoArr.duplicate(true), 3, 5)

func _on_JOGAR_pressed() -> void: # código para o botão de jogar no menu inicial
	$Menu_inicial.visible = false
	$Selecionar_tags.visible = true
	var tag_s  = tags
	tag_s.remove_at(0)
	$Selecionar_tags/VBoxContainer/TagTranslate.text = "Tags disponíveis: " + str(tag_s) + "\n (Tradução: doenças, vacinas e medicamentos; Internacional, Brasil, saúde pública e mundial; aids; hanseníase;   )"'''

#func on_resetPartida(): # sinal que emitido pela partida quando ela acaba ou/e deseja ser resetada
#	criarPartida(baralhoArr.duplicate(true), 3, 5)

'''func criarPartida(baralhoDict: Array, nTentativas, nRodadas) -> void:	
	var _partida = partida.instantiate()
	add_child(_partida)
	#_partida.baralhoDict = baralhoDict
	var caux = []
	
	for i in range(baralhoDict.size()): # -> remove os anos do plano de fundo
		var carta = baralhoDict[i]
		caux.append([carta[0],   carta[2],  carta[3]])
	_partida.get_node("test").text = str(caux)

	_partida.tags = ptags.duplicate()

	_partida.baralho.innit(baralhoArr, _partida.tags) # -> cria um baralho interno à partida
	_partida.nTentativas = nTentativas
	_partida.nRodadasOG = nRodadas # nRodada original.
	_partida.nRodadas = nRodadas # Quando uma rodada passa o número de rodadas é subtraído.
	_partida.resetPartida.connect(on_resetPartida) # conecta o sinal emitido quando a partida acaba
	_partida.criarRodada() # -> o criarRodada() deve ser chamado de fora da partida devido, pois o ready() dela irá ocorrer de forma inesperada.'''

func importar_csv_para_dicionario() -> Array: 
	var dirIm = DirAccess.open(baralhoPath.path_join("imagens")) # quando exportado diracess retorna apenas itens importados porém o mesmo ainda assim pode ser utilizado para acessar arquivos.
	var images = dirIm.get_files() # pega as imagens
	var file = FileAccess.open(baralhoPathCsv, FileAccess.READ)
	var cartas: Array
	while !file.eof_reached(): #repete até a o arquivo de tabela acabar
		var linhaCsv = Array(file.get_csv_line()) #pega uma linha da tabela
		if linhaCsv.size() > 4:
			get_image(images, linhaCsv) # se a linha tiver uma imagem checa se esta existe no hdd
		cartas.append(linhaCsv)
	file.close()
	cartas.remove_at(cartas.size()-1) # remove uma linha extra
	cartas.remove_at(0) # remove o cabeçalho da tabela
	return cartas

func get_image(images, linhaCsv) -> void:
	for im in images:
		if folder != "res://":
			if im.get_basename() == "i" + str(linhaCsv[-1]):
				linhaCsv[4] = str(folder.path_join("Decks/Example_Deck/imagens/" + "i" + str(linhaCsv[4]) +"."+ im.get_extension()))
		else:
			if im.get_basename().get_basename() == "i" + str(linhaCsv[-1]):
				linhaCsv[4] = str(folder.path_join("Decks/Example_Deck/imagens/" + "i" + str(linhaCsv[4]) +"."+ im.split(".")[1]))
#solução para o problema do dirAcess ^^^^^^, simplesmente removo o ".import" em "ix.png.import", e ele acha o arquivo.

func get_tags(cartas):
		var _tags : Array = [""]
		for i in range(1, cartas.size()): 
			var carta = cartas[i] 
			if carta.size() >= 4:
				var ks = carta[3].to_upper().split(", ")
				for k in ks:
					if not(k in _tags):
						_tags.append(k)
		return _tags
