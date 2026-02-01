extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D

@export var extra_max_health := 20
@export var heal_full := true

var collected := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if collected:
		return

	if body is Octavio:
		collected = true

		body.increase_max_health(extra_max_health, heal_full)

		collision.set_deferred("disabled", true)
		monitoring = false

		anim.play("get")
		await anim.animation_finished

		queue_free()
