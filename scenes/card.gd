extends Area2D
signal hovered
signal unhovered
signal pressed
@onready var sfx_card_interact: AudioStreamPlayer = $sfx_card_interact
@export var drag_scale := 1.1
@export var discard_speed := 1000
var is_dragging := false
var grabbed_offset
var is_discarding := false
var discard_destination
var window_size

func _ready() -> void:
	window_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if is_dragging:
		var mouse_pos = get_global_mouse_position()
		position = Vector2(
			clamp(mouse_pos.x + grabbed_offset.x, 0, window_size.x), 
			clamp(mouse_pos.y + grabbed_offset.y, 0, window_size.y)
			)
	elif is_discarding:
		move_to_discard_destination(delta)

func move_to_discard_destination(delta: float) -> void:
	var distance = position.distance_to(discard_destination)
	# Prevent overshooting the destination.
	if distance <= discard_speed * delta:
		position = discard_destination
		queue_free()
		return
	position = position.move_toward(
		discard_destination,
		discard_speed * delta
	)

func discard_card(destination) -> void:
	is_dragging = false
	is_discarding = true
	discard_destination = destination

func start_dragging() -> void:
	sfx_card_interact.play()
	is_dragging = true
	grabbed_offset = Vector2(position - get_global_mouse_position())
	get_parent().move_child(self, -1)
	var tween := create_tween()
	tween.tween_property(
		self, "scale", Vector2.ONE * drag_scale, 0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func stop_dragging() -> void:
	sfx_card_interact.play()
	is_dragging = false
	var tween := create_tween()
	tween.tween_property(
		self, "scale", Vector2.ONE, 0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and not is_discarding:
		pressed.emit(self)
	elif event.is_action_released("left_click") and self.is_dragging:
		stop_dragging()

func _on_mouse_entered() -> void:
	hovered.emit(self)

func _on_mouse_exited() -> void:
	unhovered.emit(self)
