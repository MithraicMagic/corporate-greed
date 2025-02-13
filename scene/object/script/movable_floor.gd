extends Node2D

@export var offset = Vector2(0, 0)
@export var duration = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start_tween()
	pass # Replace with function body.

func start_tween():
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property($AnimatableBody2D, "position", offset, duration / 2)
	tween.tween_property($AnimatableBody2D, "position", Vector2.ZERO, duration / 2)
