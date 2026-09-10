extends Node2D
@onready var card_manager: Node = $CardManager
var window_size

func _ready() -> void:
	window_size = get_viewport_rect().size

func _on_deck_deck_clicked() -> void:
	card_manager.spawn_card()

func _on_discard_pile_discard_pile_clicked() -> void:
	card_manager.discard_all($DiscardPile.global_position)
