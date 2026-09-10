extends Area2D
signal deck_clicked
@onready var card_manager: Node2D = $"../CardManager"
@onready var sfx_deck_draw: AudioStreamPlayer = $sfx_deck_draw
var window_size

func _ready() -> void:
	window_size = get_viewport_rect().size
	position = Vector2(window_size.x/2 -100, window_size.y/2)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and not card_manager.is_any_card_hovered():
		sfx_deck_draw.play()
		deck_clicked.emit()
