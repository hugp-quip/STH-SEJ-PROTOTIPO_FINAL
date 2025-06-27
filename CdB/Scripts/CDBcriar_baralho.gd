extends Control

var bNome : String
var bImagens : Array
var bIcone : Texture2D
var bDescrição : String
var bCSV : String
var images
var dirIm
var k = get_parent().get_parent()

func _ready():
	$LocalPasta.text += k.dirSelected

func _on_nome_baralho_text_changed(new_text:String) -> void:
	bNome = new_text
	$Labels/nomeBaralho.text = "nome da Pasta: " + new_text

func _on_desc_baralho_text_changed(new_text:String) -> void:
	bDescrição = new_text
	$Labels/descBaralho.text = "Informação do baralho: " + new_text

func _on_local_icon_pressed() -> void:
	$ICONFILE.show()

func _on_local_img_pressed() -> void:
	$IMAGESFOLDER.show()
	
func _on_local_csv_pressed() -> void:
	$CSVFILE.show()
	
func _on_csvfile_file_selected(path:String) -> void:
	bCSV = path
	$Labels/localCSV.text = path

func _on_iconfile_file_selected(path:String) -> void:
	var i = Image.new()
	i.load(path)
	var t = ImageTexture.new()
	t.set_image(i)
	bIcone = t
	$icone.texture = t

func makeResourceFromImage(path:String):
		#print(path," " ,path.get_file().get_extension() )
		var i = Image.new()
		i.load(path)
		var t = ImageTexture.new()
		#print("i ", i)
		t.set_image(i)
		return t

func _on_imagesfolder_dir_selected(dir:String) -> void:
	dirIm = dir
	var der = DirAccess.open(dirIm)
	images = der.get_files()
	bImagens = []
	for i in images:
		#if dir.path_join(i).get_file().get_extension() != "import":
		#	print("this ", dir.path_join(i).get_file().get_extension())
			bImagens.append(makeResourceFromImage(dir.path_join(i)))
	#print(bImagens)
	$Labels/localIMG.text = "local das imagens: " + dir

func _on_voltar_pressed() -> void:
	get_parent().get_parent().mudarMenu(k.MENUS.INICIAL)

func _on_criar_baralho_pressed() -> void:
	baralhoConstrutor()
	get_parent().get_parent().mudarMenu(k.MENUS.INICIAL)

func baralhoConstrutor() -> void:
	
	DirAccess.make_dir_absolute(k.dirSelected + "/" + bNome)
	var localBar = k.dirSelected + "/" + bNome
	DirAccess.make_dir_absolute(localBar +"/"+"imagens")
	var d = DirAccess.open(dirIm)
	for imagem in d.get_files():
		d.copy(dirIm + "/" + imagem, localBar +"/"+"imagens/" + imagem)

	var bInfo = BaralhoINFO.new()
	bInfo.nome = bNome
	bInfo.descrição = bDescrição
	bInfo.imagem = bIcone

	var data = getdataForCards() # -> retorna as cartas e os locais onde cada dado está
	var processedData = data
	bInfo.cartas = processedData 
	print(ResourceSaver.save(bInfo, localBar.path_join(bNome + ".tres")))

func getdataForCards():
	var file = FileAccess.open(bCSV, FileAccess.READ)
	var baralho: Array
	var cabecalho = Array(file.get_csv_line())
	var i = -1
	var imagem = i
	var nome = i
	var descriçãoCurta = i
	var descriçãoDica = i
	var anoShow = i
	for c in cabecalho:
		i+=1
		if c.to_lower() == "nome":
			nome = i
		elif c.to_lower() == "descriçãocurta":
			descriçãoCurta = i
		elif c.to_lower() == "descriçãodica":
			descriçãoDica = i
		elif c.to_lower() == "anoshow":
			anoShow = i
		elif c.to_lower() == "imagem":
			imagem = i



	while !file.eof_reached(): #repete até a o arquivo de tabela acabar
		var linhaCsv = Array(file.get_csv_line()) #pega uma linha da tabela
		var carta : Dictionary = {"nome" : linhaCsv[nome],
		  "anoshow": linhaCsv[anoShow],
		  "descriçãocurta": linhaCsv[descriçãoCurta],
		  "descriçãodica": linhaCsv[descriçãoDica]}
		carta["imagem"] = get_image(images, linhaCsv, imagem) # se a linha tiver uma imagem checa se esta existe no hdd
		baralho.append(carta)
	print(baralho)
	file.close()
	baralho.remove_at(baralho.size()-1) # remove uma linha extra
	baralho.remove_at(0) # remove o cabeçalho da tabela
	return baralho #[cartas, [nome, descriçãoCurta, descriçãoDica, anoShow, anoNum, imagem]]
	
func get_image(imagesPath : Array, linhaCsv : Array, imagem : int):
	for im in imagesPath:
		if !linhaCsv[imagem] is ImageTexture and im.get_basename() == "i" + linhaCsv[imagem]:
			return im #bImagens[i]
	return "Não há imagem atribuida a essa carta"
