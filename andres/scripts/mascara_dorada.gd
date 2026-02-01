extends Area2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var mask_id: int
var collected := false
@export var coin_multiplier := 3

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	
	if collected:
		return

	if body is Octavio:
		MaskManager.collect_mask(mask_id)
		collected = true

		body.set_coin_multiplier(coin_multiplier)

		collision.set_deferred("disabled", true)
		monitoring = false

		anim.play("get")
		await anim.animation_finished

		queue_free()
