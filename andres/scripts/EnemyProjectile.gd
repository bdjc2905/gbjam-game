extends CharacterBody2D

@export var velocidad := 200.0
@export var damage := 20.0
var current_health = 10
var is_dead = false

func _ready():
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	var timer_vida = get_tree().create_timer(1.0)
	timer_vida.timeout.connect(queue_free)
func _on_hitbox_body_entered(body: Node) -> void:
	if body is Octavio:
		body.take_damage(damage)
		queue_free() 
func _process(delta: float) -> void:
	position += transform.x * velocidad * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Octavio:
		print("¡Impacto en Octavio!")
		queue_free()
	elif body is TileMap:
		queue_free()
func take_damage(amount: int) -> void:
	current_health -= amount
	print("aaa")
	if current_health <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	queue_free()
