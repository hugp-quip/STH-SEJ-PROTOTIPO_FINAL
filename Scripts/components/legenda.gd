


@tool
class_name AutoSizeLabel extends Label

@export var min_font_size := 8 :
	set(v):
		min_font_size = clampi(v, 1, max_font_size)
		update()

@export var max_font_size := 56 :
	set(v):
		max_font_size = clampi(v, min_font_size, 191)
		update()

@export var max_line_number := 4 : 
	set(v):
		max_line_number = v if v != 0 else 1
 
@export var  past_text_size : int = 0

@export var past_text : String = ""

func _ready() -> void:
	self.theme = load("res://Assets/cardLegendatheme.tres")
	clip_text = true
	self.add_theme_font_size_override("font_size", max_font_size)	
	#print(self.theme.get_font("font_size", "").size)
	item_rect_changed.connect(update)

func _set(property: StringName, value: Variant) -> bool:
	# Listen for changes to text
	if property == "text":
		#if text.length() >= max_chars:
			#push_warning("TEXT TOO BIG")
		text = value
		if Engine.is_editor_hint():
			update()
		return true
	
	return false

func update() -> void:
	return update_font_size_label(self)

func update_font_size_label(label: AutoSizeLabel) -> void:
	var newText = []
	#var past_text_length = past_text.length()
	#print(str(label.text.length()) + "/" + str(past_text_size))
	for c in label.text.length() - past_text_size:
		newText.append(label.text[c + past_text.length()-1])
	#print(newText)
	newText.pop_front()
	for c in newText:
		past_text += c
		#print(past_text)
		_update_font_size(label, "font", "font_size", Vector2i(label.min_font_size, label.max_font_size), past_text, label.max_line_number)

func _update_font_size(label: Control, font_name: StringName, font_style_name: StringName, font_size_range: Vector2i, text: String, _max_number_lines: int) -> void:
	#var font := label.get_theme_font(font_name)
	var maximum : int = get_max_char_line(label, label.get_theme_font_size("font_size")) -1
	
	

	var line := TextLine.new()
	line.direction = label.text_direction as TextServer.Direction
	line.flags = label.autowrap_mode
	line.alignment = HORIZONTAL_ALIGNMENT_LEFT
	
	var label_width := label.size.x
	
	var font_size := label.get_theme_font_size("font_size")
	print(font_size)
	print()
	
	line.add_string(text, label.get_theme_font("font_size"), font_size)
	
	
	var text_width := line.get_line_width()
	# print(str(text_width) + "/" + str(label_width))
	# print(str(text.length()) + "/" + str(maximum))
	# print(font_size)
	# print(label_width)
	# label.max_line_number = label.size.y/font_size - 1 #if label.size.y/font_size < label.max_line_number else label.max_line_number
	# print(label.max_line_number)
	if label.past_text_size < past_text.length():
		print("augmenting size")
		var lines_in_text := (text.length()/maximum)
		if lines_in_text > _max_number_lines:
			push_warning("TEXT OVERFLOW")
		
		var line_size := text_width/(lines_in_text if lines_in_text > 1 else 1) 

		print(lines_in_text)
		#print("line_size: " + str(line_size))
		print(str(line_size) +"/"+ str( label_width))
		while  line_size > label_width:
			if font_size <= font_size_range.x:
				font_size = font_size_range.x
				break
			font_size -= 4
			line.clear()
			line.add_string(text, label.get_theme_font("font_size"), font_size)
			text_width = line.get_line_width()
			line_size = text_width/_max_number_lines
	else:
		print("reducing size")
		var line_size := text_width/_max_number_lines
		while  line_size <= label_width:
			if font_size > font_size_range.y:
				font_size = font_size_range.y
				break
			font_size += 2
			line.clear()
			line.add_string(text, label.get_theme_font("font_size"), font_size)
			text_width = line.get_line_width()
			line_size = text_width/_max_number_lines


	label.past_text_size = label.past_text.length()
	print(font_size)
	




	label.add_theme_font_size_override("font_size", font_size)	
		
	
	
	

	


static func  get_max_char_line(_label : Label, font_size : int) -> int:
	# if not (font_size == _label.min_font_size):
		# print(font_size)
	var max_char_line : int = 0
	var _line = TextLine.new()
	
	_line.direction = _label.text_direction as TextServer.Direction
	_line.flags = _label.autowrap_mode
	_line.alignment = HORIZONTAL_ALIGNMENT_LEFT
	 
	while  _line.get_line_width() < _label.size.x:
		_line.add_string("a", _label.get_theme_font("font_size"), font_size)
		max_char_line+=1

	return max_char_line if max_char_line != 0 else 1

