class_name Octavio
extends CharacterBody2D

@export var speed := 460.0
@export var ground_friction_factor := 3.0

func _physics_process(_delta: float) -> void:
	var input_vector := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	var move_direction := input_vector.normalized()

	var desired_velocity := speed * move_direction
	var steering := desired_velocity - velocity
	velocity += steering / ground_friction_factor
	set_velocity(velocity)
	move_and_slide()
