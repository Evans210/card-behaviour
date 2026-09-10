extends Node2D
const CARD_SCENE := preload("res://scenes/card.tscn")
@onready var sfx_card_discarded: AudioStreamPlayer = $sfx_card_discarded
@export var spawn_padding := 50.0
var window_size
var active_cards := []
var hovered_cards := []

func _ready() -> void:
	window_size = get_viewport_rect().size

func spawn_card() -> void:
	var card = CARD_SCENE.instantiate()
	card.position = Vector2(
		randf_range(spawn_padding ,window_size.x - spawn_padding), 
		randf_range(spawn_padding ,window_size.y - spawn_padding)
		)
	get_parent().add_child(card)
	active_cards.append(card)
	card.hovered.connect(_on_card_hovered)
	card.unhovered.connect(_on_card_unhovered)
	card.pressed.connect(_on_card_pressed)
	card.tree_exited.connect(_on_card_freed.bind(card)) #From Node

func discard_all(destination) -> void:
	for card in active_cards:
		card.discard_card(destination)

func is_any_card_hovered() -> bool:
	return not hovered_cards.is_empty()

func _on_card_hovered(card) -> void:
	if card not in hovered_cards:
		hovered_cards.append(card)

func _on_card_unhovered(card) -> void:
	hovered_cards.erase(card)

func _on_card_pressed(card) -> void:
	if _is_topmost(card):
		card.start_dragging()
		
func _is_topmost(card) -> bool:
	for other in hovered_cards:
		if other.get_index() > card.get_index():
			return false
	return true

func _on_card_freed(card) -> void:
	active_cards.erase(card)
	hovered_cards.erase(card)
	sfx_card_discarded.play()
