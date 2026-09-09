extends Area2D
signal deck_clicked
@onready var sfx_deck_draw: AudioStreamPlayer = $sfx_deck_draw


func _ready():
	var window_size = get_viewport_rect().size
	position = Vector2(window_size.x/2 -100, window_size.y/2)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and get_tree().get_nodes_in_group("hovered").size()==0:
		sfx_deck_draw.play()
		deck_clicked.emit()
