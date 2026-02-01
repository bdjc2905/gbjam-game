class_name Diavlo
extends CharacterBody2D

@export var velocidad = 70.0 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var escena_bala: PackedScene
var damage = 50
var objetivo: Octavio = null
var current_health:= max_health
@export var max_health:=10
var is_dead := false
var can_damage := true
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready():
	animation_player.play("demoniobolador")
	objetivo = get_tree().root.find_child("Octavio", true, false)
	play_sound("res://audios/demon-2-102993.mp3")
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
		body.take_damage(damage)
		
func play_sound(path: String) -> void:
	var sound = load(path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", path)

func disparar():
	if escena_bala and objetivo:
		var bala = escena_bala.instantiate()
		get_parent().add_child(bala)
		play_sound("res://audios/arrow-body-impact-146419.mp3")
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
