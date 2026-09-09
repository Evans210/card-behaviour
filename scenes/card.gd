extends Area2D
signal play_sfx_discarded
@onready var sfx_card_interact: AudioStreamPlayer = $sfx_card_interact
@export var drag_scale := 1.1
@export var discard_speed := 1000
var is_dragging = false
var grabbed_offset
var is_discarding = false
var discard_destination

func _physics_process(delta: float) -> void:
	if is_dragging:
		position = Vector2(get_global_mouse_position() + grabbed_offset)
	if is_discarding:
		move_to_discard_destination(delta)

func move_to_discard_destination(delta: float) -> void:
	var distance := position.distance_to(discard_destination)
	# Prevent overshooting the destination.
	if distance <= discard_speed * delta:
		position = discard_destination
		play_sfx_discarded.emit()
		queue_free()
		return
	position = position.move_toward(
		discard_destination,
		discard_speed * delta
	)

func discard_card(destination):
	is_discarding = true
	discard_destination = destination

func is_on_top() -> bool:
	for dragable in get_tree().get_nodes_in_group("hovered"):
		if dragable.get_index() > get_index():
			return false
	return true

func start_dragging():
	sfx_card_interact.play()
	is_dragging = true
	grabbed_offset = Vector2(position - get_global_mouse_position())
	get_parent().move_child(self, -1)
	var tween := create_tween()
	tween.tween_property(
		self, "scale", Vector2.ONE * drag_scale, 0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func stop_dragging():
	sfx_card_interact.play()
	is_dragging = false
	var tween := create_tween()
	tween.tween_property(
		self, "scale", Vector2.ONE, 0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and !is_discarding:
		if is_on_top():
			start_dragging()
	elif event.is_action_released("left_click") and self.is_dragging:
		stop_dragging()

func _on_mouse_entered() -> void:
	add_to_group("hovered")

func _on_mouse_exited() -> void:
	remove_from_group("hovered")
