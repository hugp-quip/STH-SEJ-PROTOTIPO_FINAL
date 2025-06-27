extends Node

var baralhoAtual : String # -> local do baralho atual já com o pth
var baralhoNome : String 
var pth : String 
var info : String = "INFO/"
var decks : String = "Decks/"
var barINFO : Resource # -> info for currently selected decK
var anosOrdem : Array[int]
var albumAt: Resource # -> album do baralho atual
var prior 
var albBUFFER : Array = [] #Usado na hora de salvar, tem uma cópia de todos os baralhos que foram modificados durante o uso do programa.

enum M {
	LOADING,
	INICIAL, 
	RANKING,
	SELECT, 
	JOGAR,
	ALBUM,
	PRIOR,
	CDB,
	EXIT}

var menus : Dictionary


var toLoad : Array[String] 
var cache_ := []

func _ready() -> void:
	if OS.has_feature("editor") or OS.has_feature("debug"): # -> detecta se estamos ou não no editor, carregando assim o tipo preferível de caminho
		pth = "res://"
	else:
		pth = OS.get_executable_path().get_base_dir()
	decks = pth.path_join(decks)
 # get_toLoad is called from the loading screen scene
	menus = { 
	M.INICIAL : load(pth.path_join("Scenes/menu_inicial.tscn")),
	M.RANKING : load(pth.path_join("Scenes/ranking.tscn")),
	M.JOGAR : load(pth.path_join("Scenes/Partida.tscn")),
	M.SELECT : load(pth.path_join("Scenes/select_deck.tscn")),
	M.LOADING : load(pth.path_join("Scenes/load_screen.tscn")),
	M.ALBUM : load(pth.path_join("Scenes/album.tscn")),
	M.CDB : load(pth.path_join("CdB/Scenes/CDBMain.tscn")),
	M.PRIOR : prior
}
	

func get_toLoad():
	var fldr = DirAccess.open(G.decks)
	var _decks = get_valid_decks(fldr.get_directories())
	G.toLoad = G.toLoad + _decks
	assert(G.toLoad.size() != 0, "ERROR NO DECKS AVAILABLE")
	
func get_valid_cards(_pth):
	var fldr = DirAccess.open(_pth)
	return fldr.get_files()

func get_valid_decks(dirs) -> Array[String]:
	var valid : Array[String] = []
	for dir in dirs.size():
		var fldr = DirAccess.open(G.decks.path_join(dirs[dir]))
		var files = fldr.get_files() 
		if files.size() == 1:
			if files[0].get_extension() == "tres":
				valid.append(fldr.get_current_dir().path_join(files[0]))
	return valid

func makeResourceFromImage(path:String) -> ImageTexture:
		var i = Image.new()
		i.load(path)
		var t = ImageTexture.new()
		t.set_image(i)
		return t



