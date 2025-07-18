extends Node

class_name _global

var baralhoAtual : String # -> local do baralho atual já com o pth
var pth : String 
var info : String = "INFO/"
var decks : String = "Resources/Baralhos"

# PartidaResources
var oLDbaralhoAT : BaralhoINFO # -> info for currently selected decK
var baralhoAT : BarRES
var albumAT: AlbumRes # -> album do baralho atual

# Caches
#var baralhoToLoad : Array[String] 
var rand: = RandomNumberGenerator.new()

var oLDbaralhoCache := []
var baralhoCache := []
var cartaCache := []

var albumBuffer : Array = [] #Usado na hora de salvar, tem uma cópia de todos os baralhos que foram modificados durante o uso do programa.


var prior : Node
enum M {
	LOADING,
	INICIAL, 
	RANKING,
	SELECT, 
	JOGAR,
	ALBUM,
	PRIOR,
	EXIT
}

var menus : Dictionary




func _ready() -> void:
	pth = "res://"
	decks = pth.path_join(decks)
	menus = { 
	M.INICIAL : load("res://Scenes/pages/menu_inicial.tscn"),
	#M.RANKING : load("res://Scenes/pages/ranking.tscn"),
	M.JOGAR : load("res://Scenes/pages/NEWPartida.tscn"),
	M.SELECT : load("res://Scenes/pages/select_deck.tscn"),
	M.LOADING : load("res://Scenes/pages/load_screen.tscn"),
	#M.ALBUM : load("res://Scenes/pages/album.tscn"),
	M.PRIOR : prior
}

	
func get_baralhoToLoad() -> Array:
	var fldr := DirAccess.open(G.decks)
	assert(fldr.get_files().size() > 0, "ERROR NO DECKS AVAILABLE")
	var ret := []
	for file in fldr.get_files():
		ret.append(decks + "/" + file)
	return ret
	
	
func get_valid_cards(_pth: String) -> PackedStringArray:
	var fldr := DirAccess.open(_pth)
	return fldr.get_files()

# func get_valid_decks(dirs : PackedStringArray) -> Array[String]:	
# 	var valid : Array[String] = []
# 	for bar : String in dirs:
		

# 	return valid

# 	# var valid : Array[String] = []
# 	# for dir in dirs.size():
# 	# 	var fldr := DirAccess.open(G.decks.path_join(dirs[dir]))
# 	# 	var files := fldr.get_files() 
# 	# 	if files.size() == 1:
# 	# 		if files[0].get_extension() == "tres":
# 	# 			valid.append(fldr.get_current_dir().path_join(files[0]))
	
func makeResourceFromImage(path:String) -> ImageTexture:
		var i := Image.new()
		i.load(path)
		var t := ImageTexture.new()
		t.set_image(i)
		return t
