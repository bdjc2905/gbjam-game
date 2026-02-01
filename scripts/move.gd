extends CharacterBody2D
@export var speed: float = 200

func _physics_process(delta):
	var input_vector = Vector2.ZERO

	if Input.get_action_strength("arriba"):
		input_vector.y -= 1
	if Input.is_action_pressed("abajo"):
		input_vector.y += 1
	if Input.is_action_pressed("izquierda"):
		input_vector.x -= 1
	if Input.is_action_pressed("derecha"):
		input_vector.x += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()

	velocity = input_vector * speed
	var collision = move_and_collide(velocity * delta)
