class_name Lallorona
extends CharacterBody2D

@export var speed := 160
@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $Hitbox/CollisionShape2D
var current_health = 10
var is_dead = false
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


var damage = 17
var target: CharacterBody2D

func play_sound(path: String) -> void:
	var sound = load(path) as AudioStream
	if sound:
		audio_player.stream = sound
		audio_player.play()
	else:
		print("No se pudo cargar el sonido:", path)

func _ready():
	animation_player.play("llorona")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	

func _on_hitbox_body_entered(body: Node) -> void:
	if body is Octavio:
		body.take_damage(damage)
		queue_free()

func _physics_process(delta: float) -> void:
	if target == null:
		target = find_target()
	if target:
		var dir = (target.global_position - global_position).normalized()
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func find_target() -> CharacterBody2D:
	for body in detection_area.get_overlapping_bodies():
		if body is Octavio:
			play_sound("res://audios/mujer_llorando-209276.mp3")
			return body 
	return null
	
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
