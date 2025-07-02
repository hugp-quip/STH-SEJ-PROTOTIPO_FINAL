extends Control

@onready var partida: = load("res://Scenes/pages/Partida.tscn")
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
