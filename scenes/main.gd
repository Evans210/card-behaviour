extends Node2D
@onready var sfx_card_discarded: AudioStreamPlayer = $sfx_card_discarded
const CARD_SCENE := preload("res://scenes/card.tscn")
@export var spawn_padding := 50.0


func _on_deck_deck_clicked() -> void:
	var card = CARD_SCENE.instantiate()
	var window_size = get_viewport_rect().size
	card.position = Vector2(
		randf_range(spawn_padding ,window_size.x - spawn_padding), 
		randf_range(spawn_padding ,window_size.y - spawn_padding)
		)
	add_child(card)
	card.play_sfx_discarded.connect(_on_card_discarded)

func _on_discard_pile_discard_pile_clicked() -> void:
	var destination = $DiscardPile.global_position
	for card in get_tree().get_nodes_in_group("cards"):
		card.discard_card(destination)

func _on_card_discarded():
	sfx_card_discarded.play()
