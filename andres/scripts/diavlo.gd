extends CharacterBody2D

@export var velocidad = 80.0 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var escena_bala: PackedScene
var damage = 50
var objetivo: Octavio = null
var current_health:= max_health
@export var max_health:=10
var is_dead := false
var can_damage := true

func _ready():
	animation_player.play("demoniobolador")
	objetivo = get_tree().root.find_child("Octavio", true, false)
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 2.0
	timer.timeout.connect(disparar)
	timer.start()

func _physics_process(_delta):
	if objetivo:
		look_at(objetivo.global_position)
		
		var direccion = global_position.direction_to(objetivo.global_position)
		velocity = direccion * velocidad
		if direccion.x < 0:
			$Demonititoderpng.flip_v = true
		else:
			$Demonititoderpng.flip_v = false
		
		move_and_slide()

func _on_body_entered(body: Node2D) -> void:
	if body is Octavio:
		take_damage(10)
		

func disparar():
	if escena_bala and objetivo:
		var bala = escena_bala.instantiate()
		get_parent().add_child(bala)
		bala.global_position = global_position
		bala.rotation = rotation

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
