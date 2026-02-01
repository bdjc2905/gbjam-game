class_name Lallorona
extends CharacterBody2D

@export var speed := 550
@onready var sprite: Sprite2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var damage = 17
var target: CharacterBody2D


func _ready():
	animation_player.play("llorona")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	

func _on_hitbox_body_entered(body: Node) -> void:
	if body is Octavio:
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
			return body 
	return null
