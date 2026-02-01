#extends Area2D
#
#@export var damage := 1000
#@onready var owner_player := get_parent()
#
#func _ready():
	#monitoring = false
	#body_entered.connect(_on_body_entered)
#
#func enable_attack():
	#monitoring = true
#
#func disable_attack():
	#monitoring = false
#
#func _on_body_entered(body):
	#if not owner_player.is_attacking:
		#return
#
	#if body.has_method("take_damage"):
		#body.take_damage(damage)
