extends Panel

var container : VBoxContainer 
var img : FileDialog
var csv : FileDialog
var imgback : Button
var selCsv : Button
var imgSel 
var baral_name: LineEdit

var pbckImage : String
var baralName : String
var sel_Csv : String

signal allPathsFound

func _ready() -> void:
	print(get_tree_string_pretty())
	container = get_child(1)
	imgback = container.get_child(2)
	img = imgback.get_child(0)
	imgSel = get_child(0)
	baral_name = container.get_child(0)
	selCsv = container.get_child(1)
	

func _on_enviar_pressed() -> void:
	if pbckImage and baralName and sel_Csv:
		allPathsFound.emit()
	else:
		print("error!!!")
func _on_imgback_pressed() -> void:
	img.visible = true

func _on_img_file_selected(path: String) -> void:
	pbckImage = path
	var image = Image.load_from_file(pbckImage)
	var texture = ImageTexture.create_from_image(image)
	imgSel.texture = texture
	image = null
	img.deselect_all()

func _on_baral_name_text_submitted(new_text: String) -> void:
	baralName = new_text
	baral_name.get_child(0).text = "nome selecionado = " + baralName


func _on_sel_csv_pressed() -> void:
	selCsv.get_child(1).visible = true


func _on_csv_file_selected(path: String) -> void:
	sel_Csv = path
	selCsv.get_child(0).text = "csv selecionado = " + sel_Csv
	selCsv.get_child(1).deselect_all()
