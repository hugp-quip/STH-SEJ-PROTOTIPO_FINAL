extends Control

enum MMOD {
	MODBARA,
	SELBARA,
	MODCART
}

@onready var msMOD = {
	MMOD.MODBARA : $ModBara,
	MMOD.SELBARA : $SelectCarta,
	MMOD.MODCART : $ModCarta
}

@onready var atual : Node = msMOD[MMOD.MODBARA]

var bNome : String
var bIcone : ImageTexture
var bDescrição : String
var bCartaNomes : Array[String] 
var bCartas : Array[Resource]
var barRes
func _ready() -> void:
	$CurrentDir.text = "CurrentDir: " + G.dirSelected
	print(G.dirSelected)
	extractBarData(G.dirSelected)

func extractBarData(dir) -> void:
	print(dir)
	var fldr = DirAccess.open(dir)
	barRes = ResourceLoader.load(dir.path_join(fldr.get_files()[0]))
	bNome = barRes.nome
	bIcone = barRes.imagem
	bDescrição = barRes.descrição
	$ModBara.sset()

func extractCardData(dir) -> void:
	var fldr = DirAccess.open(dir.path_join("cartas"))
	var bCartaNomes : Array[String] 
	var bCartas : Array[Resource]
	pass

func switchMenu(new: int) -> void:
	if new == 2 and not bCartaNomes:
		extractCardData(G.dirSelected)
	atual.hide()
	atual = msMOD[new]
	atual.show()


func _on_voltar_pressed() -> void:
	pass # Replace with function body.


func _on_salvar_pressed() -> void:
	$ModBara.gget()
	print(G.dirSelected.path_join(barRes.nome + ".tres"))
	print(ResourceSaver.save(barRes, G.dirSelected.path_join(barRes.nome + ".tres")))
	get_parent().get_parent().mudarMenu(G.MENUS.INICIAL)
