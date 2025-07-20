@tool
class_name RodadaAnimationHandler extends Node2D

var cards_that_finished_auto_moving : int = 0
var cards: Array
var nodeCardScene = load("res://Scenes/components/node_carta_display.tscn")
var animationBatch : Array 
# has dictionaries containing:
# {card, final_position, short_stop, start_delay}

var rodada_data : RodadaRES

@onready var slotMan : SlotManager = get_node("SlotManager")


func _ready() -> void:
	if !Engine.is_editor_hint():
		_get_rodada_data.call_deferred()
		instantiate_cartas()
		#cards = get_children().map( func (child) : if child is NodeCard : return child).filter( func(child) : return child != null)
		cards.map(func (card) : card.finished_auto_moving.connect(_on_finished_auto_moving))
		var timer := Timer.new()
		timer.one_shot = true
		timer.timeout.connect(timertest)
		add_child(timer)
		timer.start(0.001)
		_insert_data_in_cards.call_deferred.call_deferred()
	else:
		instantiate_cartas_fakes()

func restart() -> void:
		_get_rodada_data.call_deferred()
		cards.map(func (card) : card.position == self.position)
		cards_that_finished_auto_moving = 0
		var timer := Timer.new()
		timer.one_shot = true
		timer.timeout.connect(timertest)
		add_child(timer)
		timer.start(0.001)
		_insert_data_in_cards.call_deferred()


func _get_rodada_data() -> void:
	rodada_data = get_parent().get_parent().data # -> rodada.data

func _insert_data_in_cards() -> void:
	var i := 0
	for res in rodada_data.cards:
		cards[i].criar_carta_display(res)
		i+=1

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
		#cards[j].get_node("UIHandlernode").get_node("Legenda").text += str(i)+str(i)
		cards[j].go_to_slot(slotMan.get_slot(i))
		#slotMan.cards[j] = cards[j]
		j+=1

func instantiate_cartas() -> void:
	var size : = util.scale_to_same_size(util.carta_size, util.get_size(nodeCardScene.instantiate()))
	for i : int in get_parent().n_cartas:
		var carta : Sprite2D = nodeCardScene.instantiate()
		carta.scale =  size
		cards.append(carta)
		add_child(carta)

func instantiate_cartas_fakes() -> void:
	var final_width : float = ((get_parent().n_cartas-1)*20 + ((get_parent().n_cartas)*util.carta_size.x  ) ) - util.carta_size.x
	var size : = util.scale_to_same_size(util.carta_size, util.get_size(nodeCardScene.instantiate()))
	for i : int in get_parent().n_cartas:
		var carta : Sprite2D =  nodeCardScene.instantiate()
		#print(util.get_size(carta))
		var rand : RandomNumberGenerator = RandomNumberGenerator.new()
		rand.randomize()
		carta.scale = size 
		carta.position.x += (carta.get_rect().size.x*(i) + (i)*20) - final_width/2 
		#print(util.get_size(carta))
		add_child(carta)
		var v = rand.randi_range(0, 71)
		#print(v)
		carta.load_fake_card(v)

func move_at_start(delta) -> void:
	for carta in cards:
		carta.move_at_start(delta)

func update_dragged(_card_being_dragged: Node2D, _cards_dragged: Array) -> void:
	_cards_dragged.remove_at(_cards_dragged.find(_card_being_dragged))
	_cards_dragged.push_back(_card_being_dragged)
	
func set_z_cards(_cards_dragged : Array) -> void:
	for _card : Node2D in _cards_dragged:
		_card.z_index = _cards_dragged.find(_card)
