extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D

var consumed := false

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if consumed:
		return

	if body is Octavio:
		consumed = true

		# Desactivar colisión SOLO de este café
		collision.set_deferred("disabled", true)
		monitoring = false

		body.heal(10)

		anim.play("get")
		await anim.animation_finished

		queue_free()
