class_name Octavio
extends CharacterBody2D

var speed = 200.0
var max_speed := 300.0

@onready var sprite = $Sprite2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var hitbox : CollisionShape2D = $CollisionShape2D
@onready var attack_area : Area2D = $Area2D
@onready var attack_shape : CollisionShape2D = $Area2D/CollisionShape2D2
@onready var colision: CollisionShape2D = $Area2D/CollisionShape2D2
@onready var hud = $"../HUD"


var is_attacking := false

var animation_locked := false
var max_health = 100
var current_health = 100
var coins := 0
var coin_multiplier = 1

var invulnerable := false

func _physics_process(_delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	var direction = Vector2.ZERO
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_pressed("derecha"):
		direction.x += 1
	if Input.is_action_pressed("izquierda"):
		direction.x -= 1
	if Input.is_action_pressed("arriba"):
		direction.y -= 1
	if Input.is_action_pressed("abajo"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed

		if not animation_locked:
			animation_player.play("correr")
			if direction.x != 0:
				sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		if not animation_locked:
			animation_player.play("idle")

	move_and_slide()

	
func take_damage(amount: int) -> void:
	if invulnerable:
		return

	# 🔥 CANCELAR ATAQUE SI ESTABA ATACANDO
	is_attacking = false

	invulnerable = true
	animation_locked = true
	current_health -= amount
	if hud:
		hud.update_life(current_health, max_health)
	hitbox.disabled = true
	animation_player.play("hurt")
	await animation_player.animation_finished

	hitbox.disabled = false
	animation_locked = false
	invulnerable = false

	if current_health <= 0:
		current_health = 0
		die()


		
func die() -> void:
	print("Octavio murió")
	animation_player.play("die")
	set_physics_process(false)
	get_tree().change_scene_to_file("res://andres/escenas/control.tscn")

	

func add_coin() -> void:
	coins +=coin_multiplier
	if hud:
		hud.update_coins(coins)
	print(max_health)
	print("Monedas:",coins)
	
func heal(amount: int) -> void:
	current_health+= amount
	if current_health > max_health:
		current_health = max_health
	if hud:
		hud.update_life(current_health, max_health)
	print(current_health)
	
func set_coin_multiplier(multiplier: int) -> void:
	coin_multiplier = multiplier
	print("Multiplicador de monedas x", coin_multiplier)
	
func increase_max_health(amount: int, heal_full := true) -> void:
	max_health += amount
	
	if heal_full:
		current_health = max_health
	else:
		current_health = min(current_health + amount, max_health)
	if hud:
		hud.update_life(current_health, max_health)
	print("Vida máxima:", max_health)
	print("Vida actual:", current_health)

func increase_speed(new_speed: float) -> void:
	speed = min(new_speed, max_speed)
	print("Velocidad actual:", speed)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
		animation_locked = false

		# Forzar salida del último frame
		if velocity != Vector2.ZERO:
			animation_player.play("correr")
		else:
			animation_player.play("idle")
			

func attack():
	if is_attacking or animation_locked:
		return  # Evita atacar si ya está atacando o animación bloqueada

	is_attacking = true
	animation_locked = true

	# Desactivar colisión principal mientras ataca
	hitbox.disabled = true
	colision.disabled = false

	# Ajustar posición de la hitbox de ataque según dirección que mira el sprite
	if sprite.flip_h:
		colision.position.x = -13
	else:
		colision.position.x = 13  # o la posición "normal" que uses para derecha

	# Reproducir animación de ataque
	animation_player.play("attack")

	# Activar hitbox de ataque para detectar enemigos
	attack_area.monitoring = true
	attack_area.set_deferred("monitoring", true)

	# Esperar un poco para que la animación avance al golpe (ajusta este tiempo)
	await get_tree().create_timer(0.2).timeout

	# Detectar enemigos dentro del área de ataque
	var cuerpos = attack_area.get_overlapping_bodies()
	print("Cuerpos detectados en área de ataque:", cuerpos.size())
	for cuerpo in cuerpos:
		print("Detectado cuerpo:", cuerpo.name)
		if cuerpo.name=="Diavlo" or cuerpo.name=="Diavlo2":
			print("Haciendo daño a:", cuerpo.name)
			cuerpo.take_damage(190)

	# Desactivar hitbox de ataque
	attack_area.monitoring = false

	# Reactivar colisión principal (puedes dejar para cuando termine la animación si prefieres)
	hitbox.disabled = false
	colision.disabled = true

	# Esperar que termine la animación para liberar bloqueo
	await animation_player.animation_finished

	is_attacking = false
	animation_locked = false

	# Volver a animación idle o correr según velocidad
	if velocity != Vector2.ZERO:
		animation_player.play("correr")
	else:
		animation_player.play("idle")
