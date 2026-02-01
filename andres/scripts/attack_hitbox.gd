extends Area2D

@export var damage := 10
@export var life_time := 0.15

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _on_body_entered(body) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
