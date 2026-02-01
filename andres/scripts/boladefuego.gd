class_name BolaDeFuego
extends CharacterBody2D

@export var speed := 150
var muriendo = false
@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var current_health = 10
var is_dead = false
var damage = 17
var target: CharacterBody2D
@onready var hitbox = $Hitbox/CollisionShape2D


func _ready():
	animation_player.play("bolita")
	$Hitbox.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node2D) -> void:
	if body is Octavio:
		body.take_damage(damage)
		queue_free()


func _physics_process(delta: float) -> void:
	if muriendo: return
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
			return body 
	return null
	

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
