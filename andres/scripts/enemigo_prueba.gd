
extends CharacterBody2D

@export var damage := 10
@export var speed := 40.0
@export var max_health := 10

var current_health := max_health
var can_damage := true
var is_dead := false


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Movimiento simple
	velocity.x = speed
	move_and_slide()

	_check_player_collision()


# ─────────────────────────────
# DAÑO AL JUGADOR POR CONTACTO
# ─────────────────────────────
func _check_player_collision() -> void:
	if not can_damage or is_dead:
		return

	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		var body := collision.get_collider()

		if body is Octavio:
			can_damage = false
			body.take_damage(damage)
			_start_damage_cooldown()


func _start_damage_cooldown() -> void:
	await get_tree().create_timer(1.0).timeout
	can_damage = true
	

func take_damage(amount: int) -> void:
	current_health -= 100
	print("Enemigo recibió daño")

	if current_health <= 0:
		die()
		
func die():
	if is_dead:
		return
	is_dead = true
	print("Enemigo muerto")
	queue_free()
