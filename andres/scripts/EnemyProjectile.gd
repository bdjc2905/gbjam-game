extends CharacterBody2D

@export var velocidad := 900.0
@export var damage := 20.0


func _ready():
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	var timer_vida = get_tree().create_timer(1.0)
	timer_vida.timeout.connect(queue_free)
func _on_hitbox_body_entered(body: Node) -> void:
	if body is Octavio:
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
