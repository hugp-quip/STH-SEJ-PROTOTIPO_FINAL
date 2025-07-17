@tool
extends Node2D

var cards_that_finished_auto_moving : int = 0
var cards: Array

var animationBatch : Array 
# has dictionaries containing:
# {card, final_position, short_stop, start_delay}

@onready var slotMan : SlotManager = get_node("SlotManager")


func _ready() -> void:
	instantiate_cartas()
	if !Engine.is_editor_hint():
		cards = get_children().map( func (child) : if child is NodeCard : return child).filter( func(child) : return child != null)
		cards.map(func (card) : card.finished_auto_moving.connect(_on_finished_auto_moving))
		var timer := Timer.new()
		timer.one_shot = true
		timer.timeout.connect(timertest)
		add_child(timer)
		timer.start(0.001)

func _physics_process(delta: float) -> void:
	if cards_that_finished_auto_moving < get_parent().n_cartas:
		move_at_start(delta)
	if animationBatch.size() > 0 :
		#execute_animation(card_to_animate)
		pass

func execute_animation(_card_to_animate : NodeCard) -> void :
	_card_to_animate.move_to_goal()


func _on_finished_auto_moving():	
	cards_that_finished_auto_moving += 1
	
func timertest() -> void:
	get_child(-1).queue_free()
	var j := 0
	for i : int in cards.size():
		cards[j].get_node("UIHandlernode").get_node("Legenda").text += str(i)+str(i)
		cards[j].go_to_slot(slotMan.get_slot(i))
		#slotMan.cards[j] = cards[j]
		j+=1

func instantiate_cartas() -> void:
	for i : int in get_parent().n_cartas:
		var carta : Sprite2D = load("res://Scenes/components/node_carta_display.tscn").instantiate()
		#print(util.get_size(carta))
		carta.scale =  util.scale_to_same_size(util.carta_size, util.get_size(carta))
		#print(util.get_size(carta))
		add_child(carta)

func move_at_start(delta) -> void:
	for carta in cards:
		carta.move_at_start(delta)

func update_dragged(_card_being_dragged: Node2D, _cards_dragged: Array) -> void:
	_cards_dragged.remove_at(_cards_dragged.find(_card_being_dragged))
	_cards_dragged.push_back(_card_being_dragged)
	
func set_z_cards(_cards_dragged : Array) -> void:
	for _card : Node2D in _cards_dragged:
		_card.z_index = _cards_dragged.find(_card)
