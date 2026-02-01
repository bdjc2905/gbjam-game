extends Area2D

@onready var animation_coin: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D


var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if collected:
		return

	if body is Octavio:
		collected = true

		body.add_coin()

		# Evita que se vuelva a activar
		collision.set_deferred("disabled", true)
		monitoring = false

		animation_coin.play("get")
		await animation_coin.animation_finished

		queue_free()
