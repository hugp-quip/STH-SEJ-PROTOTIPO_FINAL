extends Node

@onready var cardBackground := preload("res://Assets/carta.png")
@onready var slotBackground := preload("res://Assets/slot.PNG")
#@onready var rodada := preload("res://Scenes/pages/Rodada.tscn")
#@onready var cardDisplay := preload("res://Scenes/components/OLDCardDisplay.tscn")
@onready var nodeCardDisplay := load("res://Scenes/components/node_carta_display.tscn")
@onready var nodeSlot := load("res://Scenes/components/slot.tscn")
var pathCartas := "res://Resources/Cartas"
