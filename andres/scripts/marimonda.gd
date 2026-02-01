extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var boosted_speed := 350.0

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if collected:
		return

	if body is Octavio:
		collected = true

		body.increase_speed(boosted_speed)

		collision.set_deferred("disabled", true)
		monitoring = false

		queue_free()
