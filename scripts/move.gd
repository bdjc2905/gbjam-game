extends CharacterBody2D
@export var speed: float = 200

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.get_action_strength("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = input_vector * speed
	var collision = move_and_collide(velocity * delta)
